/* 
- Extend ObjectProxy? - 11k footprint! #*@!^&%  - but Proxy is in the player!
*/
package metafas3 
{
	import metafas3.reactive_resource.*;

	import fl.data.DataProvider;
	import fl.events.DataChangeEvent;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectProxy;

	//import code.google.as3httpclient.*;

	use namespace flash_proxy;

	// required if you want to use BindingUtils or ChangeWatcher on dynamic properties!
	// curly braces bindings in MXML cause this directive to be created at compile-time,
	// however AS3 runtime bindings do NOT.
	[Bindable("propertyChange")]

	dynamic public class ReactiveResource extends ObjectProxy
	{
		XML.prettyPrinting = false;

		// >>> STATIC PROPERTIES
		// >>> STATIC METHODS
		static private function add_observers (o:*, options:Hash, complete:String = 'complete') :void
		{
			// after_find == complete
			var after_find:Function;
		 	if (options.complete is Function)
			{
				Logger.info('ReactiveResource.find: "complete: func" handler syntax deprecated in favor of "after_find: func"');
				after_find = options.remove('complete');
			}
			else
			{
				after_find = options.remove('after_find');
			}
			if (after_find is Function) o.addEventListener(complete, after_find);

			// custom after_* hooks:
			for (var key:String in options)
			{
				if (key.indexOf('after_') == 0)
				{
					o.addEventListener(key, options.remove(key));
				}
			}
		}

		static private function collection_name (self:Class) :String // pseudo-equivalent to RoR's table_name
		{
			return Inflector.restify(Inflector.demodulize(getQualifiedClassName(self)));
		}

		static public function collection_path (self:Class, prefix_options:Object = null, query_options:Object = null) :String // pseudo-equivalent to RoR's table_name
		{
			return (prefix_source(self, prefix_options) + '.' + model_format(self));
		}
		
		static public function element_path (self:Class, id:Object, prefix_options:Object = null, query_options:Object = null) :String // pseudo-equivalent to RoR's table_name
		{
			return (prefix_source(self, prefix_options) + '/' + id + '.' + model_format(self));
		}

		// Rails-inspired finder
		// self: reference to class (Product, Store, etc)
		// scope: 'all' or 'one' or '43'
		// args: { store_id: 43 } or { from: 'http://www.example.com/items/3.xml' }
		//static public function find (self:Class, scope:*, options:Object = null) :*
		static public function find (...args) :*
		{
			var self:Class = (args[0] is Class) ? (args.shift()) : ReactiveResource;
			var scope:* = args.shift();
			//var options:Object = args.shift();
			var options:Hash = new Hash(args.shift());

			switch (scope)
			{
				case 'all': 	return find_all(self, options); break;
				case 'one': 	return find_one(self, options); break;
				default: 		return find_single(self, scope, options);
			}
		}

		/**
		* SHOULD BE DEFINED IN SUBCLASS.
		* AS3 DOESN'T INHERIT STATICS.
		*
		* Blantantly copied from api.rubyonrails.org:
		* Sets the format that attributes are sent and received in from
		* a mime type reference:
		*
		<code>
			Person.format = 'html';
			Person.find(1) # => GET /people/1.html

			Person.format = 'json';
			Person.find(1) # => GET /people/1.json

			Person.format = 'xml';
			Person.find(1) # => GET /people/1.xml
		</code>
		*
		* Default format is 'xml'.
		**/
		// static public var format:String;
		static private function model_format (self:Class) :String
		{
			// if self.format is undefined, use 'xml' as default
			return ((self.format) ? self.format : 'xml');
		}

		/**
		* SHOULD BE DEFINED IN SUBCLASS.
		* AS3 DOESN'T INHERIT STATICS.
		*
		* Blantantly copied from api.rubyonrails.org:
		* Sets the URI of the REST resources to map for this class to the
		* value in the site argument. The site variable is required for
		* ReactiveResource‘s mapping to work.
		*
		* Product.site = 'http://www.example.com';
		**/
		// static public var site:String;


		static private function find_all (self:Class, options:Hash = null) :DataProvider
		{
			// pop from: param
			var from:String = options.remove('from');

			// pop from: param
			var limit:String = options.remove('limit');

			// create empty collection
			var collection:DataProvider = new DataProvider();

			// bubble DataChange event to 'complete' handler
			// wire event handlers (aka 'observers')
			add_observers(collection, options, DataChangeEvent.DATA_CHANGE);

			// execute request
			var after_find:Function = function (e:Event) :void
			{
				after_find_all(e, self, collection, uint(limit));
			};
			get((from ? from : collection_path(self, options)), after_find, onFindAllFault, options);

			// return collection (may be empty: listen for 'dataChange'!)
			return collection;
		}

		static private function find_one (self:Class, options:Hash = null) :*
		{
			// pop from: param
			var from:String = options.remove('from');

			// create new instance of Class
			var rr:* = new self();

			// wire event handlers (aka 'observers')
			// wire up 'complete' and all 'after_*' events/listeners passed in options Hash
			add_observers(rr, options);

			// execute request
			get(from, rr.after_find, rr.after_find_failed, options);

			// return item (may be empty: listen for 'complete'!)
			return rr;
		}

		static private function find_single (self:Class, id:String, args:Hash = null) :*
		{
			// assemble from: path
			args.from = element_path(self, id, args);

			// create new instance of Class
			var rr:* = find_one(self, args);

			// assign id
			rr.id = id;

			// return item (may be empty: listen for 'complete'!)
			return rr;
		}

		// TODO: move to a connection management object of some sort
		protected static function get (path:String, onResult:Function, onFault:Function, args:Object = null) :void
		{
			var request:Request = new Request('get', path);

			request.addEventListener('complete', onResult);
			request.addEventListener('status', on_response_status);
			request.addEventListener('ioError', onFault);

			if (args)
			{
				if (args.fault is Function) request.addEventListener('ioError', args.fault);
				if (args.progress is Function) request.addEventListener('progress', args.progress);
				if (args.status is Function) request.addEventListener('httpStatus', args.status);
			}

			request.load();
		}

		// For use ONLY in ReactiveResource subclasses for static init:
		// extend(prototype.constructor)
		static public function model (c:Class) :void
		{
			// define find method
			c['find'] = function (...args) :*
			{
				args.unshift(c);
				return ReactiveResource.find.apply(null, args);
			};
		}

		// TODO: check for :symbols in prefix and throw error if missing from options!
		static public function prefix_source (self:Class, options:Object = null) :String
		{
			// if self.site is null (test suite), use empty string
			var url:String = (self.site) ? self.site : '';
			
			if (url.charAt(url.length - 1) != '/')
			{
				url += '/';
			}
			
			for (var key:String in options)
			{
				if (key.indexOf('_id') == key.length - 3)
				{
					url += Inflector.pluralize(key.substr(0, (key.length - 3))) + '/' + options[key].toString() + '/';
				}
			}

			url += collection_name(self);
			
			return url;
		}


		// >>> PUBLIC PROPERTIES
		// Hashmap to track databound properties whose change events need broadcasted.
		public var attributes:Object = new Object();
		public var errors:Array = new Array();
		public var location:String; // prevent location from serialzing
		public var prefix:String = '/';
		public var response:Response;


		public function set error (msg:String) :void
		{
			errors.push(msg);
		}


		// >>> PUBLIC METHODS
		public function ReactiveResource (attrs:* = null) 
		{
			super(attributes);

			// assign attributes if passed
			if ((attrs is XML) || (attrs is ByteArray))
			{
				load((new Response(attrs)).body);
			}
			else if (attrs is Object)
			{
				load(attrs);
			}

			// listen for own "propertyChange" events and re-delegate
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, after_property_change);
		}

		public function load (attrs:Object, e:Event = null) :void
		{
			for (var pname:String in attrs)
			{
				// strip JSON namespaces
				var lname:String = pname.replace(/\w+:/, '');
				this[lname] = attrs[pname];
			}
			if (e) dispatchEvent(e);
		}

		public function prefix_options () :Object
		{
			var me:* = this;
			var prefix_options:Object = new Object();

			var inject_prefix_option:Function = function (...args) :String {
				if (me[args[1]])
				{
					prefix_options[args[1]] = me[args[1]];
				}
				return me[args[1]];
			};

			// for prefix: /stores/:store_id/
			// calls inject_prefix_option(':store_id', 'store_id', 8, '/stores/:store_id/')
/*			self().prototype.prefix.replace(/:(\w+)/g, inject_prefix_option);*/
			prefix.replace(/:(\w+)/g, inject_prefix_option);

			return prefix_options;
		}

		public function put (path:String, options:Object = null) :void
		{
			// clear errors
			errors = new Array();

			if (options && options.complete is Function)
			{
				// bubble complete event
				addEventListener('complete', options.complete);
			}

			path = element_path().replace(/(\/[^\/\.]*)(\.\w+)/, '$1/' + path + '$2');
			send('PUT', path, after_update, after_update_failed);
		}

		public function reload (args:Object = null) :void
		{
			// clear errors
			errors = new Array();
			// clear attributes, except id
			for (var i:String in attributes)
			{
				if (i != 'id') delete this[i];
			}

			// add a cache-breaker to the path
			var path:String = element_path() + '?ibreakcache=' + (new Date().getTime());

			// make the request
			get(path, after_find, after_find_failed);
		}

		public function save (args:Object = null) :Boolean
		{
			// clear errors
			errors = new Array();

			// TODO: apply validations BEFORE any network operations
			// 		 return false if validations fail

			if (args && args.complete is Function)
			{
				// bubble complete event
				addEventListener('complete', args.complete);
			}

			(this.id ? update() : create());

			return true;
		}

		public function to_param () :URLVariables
		{
			// create collection
			var params:URLVariables = new URLVariables();

			var root:String = Inflector.demodulize(getQualifiedClassName(this));

			// populate values
			for (var i:String in attributes)
			{
				// every child's value must be cast to String
				var value:String = String(this[i]);
				// trap combobox serialization bug: value serializes as [object Object]
				if (value == '[object Object]' && this[i].data) value = String(this[i].data);
				// assign to collection
/*				params[i] = value;*/
				params['data[' + root + '][' + i + ']'] = value;
			}

			// send it back
			return params;
		}

		public function to_xml () :XML
		{
			// root node
			var root:String = Inflector.underscore(Inflector.demodulize(getQualifiedClassName(this)));
			var xml:XML = new XML('<' + root + '></' + root + '>');

			// child nodes
			for (var i:String in attributes)
			{
				var node:XML = new XML('<' + i + ' />');
				var value:String = String(this[i]);
				// trap combobox serialization bug: value serializes as [object Object]
				if (value == '[object Object]' && this[i].data) value = String(this[i].data);
				xml.appendChild(node);
				// every child node's value must be cast to String
				xml[i] = value;
			}

			// send it back
			return xml;
		}

		// dispatch property_validate for validators
		// triggers validators for property
		public function validate (property:*) :void
		{
			var validateEvent:PropertyChangeEvent = new PropertyChangeEvent(property + '_validate');
			// validateEvent.kind = e.kind;
			validateEvent.property = property;
			// validateEvent.oldValue = e.oldValue;
			validateEvent.newValue = this[property];
			// validateEvent.source = this;
			dispatchEvent(validateEvent);
		}


		// >>> PROTECTED METHODS
		/**
		 *  validates_presence_of('first_name', 'last_name', { message: '...' })
		 *  =>
		 *  Validates.presence_of(this, 'first_name', 'last_name', { message: '...' })
		 *
		 *  @param name The name of the validator method being invoked.
		 *
		 *  @param rest An array specifying the arguments to the
		 *  called validator method.
		 *
		 *  @return The return value of the called validator method.
		 */
		override flash_proxy function callProperty (name:*, ... rest): *
		{
			if (name.toString().indexOf('validates_') == 0)
			{
				// add "this" to validator args
				rest.unshift(this);
				// invoke the validator method
				Validates[name.toString().replace('validates_', '')].apply(null, rest);
				return;
			}
/*			else
			{
				rest.unshift(name);
				return super.callProperty.apply(null, rest);
			}
*/		}

		protected function create () :void
		{
			send('POST', collection_path(), after_create, after_create_failed);
		}

		protected function collection_path (options:Object = null) :String
		{
			return ReactiveResource.collection_path(self(), (options ? options : prefix_options()));
		}

		protected function element_path (options:Object = null) :String
		{
			return ReactiveResource.element_path(self(), this.id, (options ? options : prefix_options()));
		}

        protected function id_from_response (request:Object) :void
        {
			var fmt:String = model_format(self());

			if (fmt == 'html')
			{
				var root:String = Inflector.underscore(Inflector.demodulize(getQualifiedClassName(this)));
				var re:RegExp = new RegExp('<input[^>]*id="' + root + '_id"[^>]*>');
				var input:XML = XML(request.response.raw.match(re).toString());
				this.id = input.@value.toString();
			}
			else if (fmt == 'xml')
			{
				var matches:Array;
				// parse id from location
				if (request.data.location) matches = request.data.location.toString().match(/\/([^\/]*?)(\.\w+)?$/);
				// assign id IFF match is not null
				if (matches && matches[1]) this.id = matches[1];
			}
        }

		protected function update () :void
		{
			send('PUT', element_path(), after_update, after_update_failed);
		}

		protected function self () :Class
		{
			return getDefinitionByName(getQualifiedClassName(this).replace('::', '.')).prototype.constructor;
		}

	    /**
	     *  Updates the specified property on the proxied object
	     *  and sends notification of the update to the handler.
	     *
	     *  @param name Object containing the name of the property that
	     *  should be updated on the proxied object.
	     *
	     *  @param value Value that should be set on the proxied object.
	     */
		override flash_proxy function setProperty (name:*, value:*) :void
		{
			// sanitize Boolean 'false' values
			if (value === 'false')
			{
				value = false;
			}

			super.setProperty(name, value);
		}

		// >>> PRIVATE METHODS
		// TODO: move to a connection management object of some sort
		private function send (method:String, path:String, success:Function, failure:Function) :void
		{
			var fmt:String = model_format(self());

			var request:Request = new Request(method, path);

			// Set the data property to the dataToSave XML instance to send the XML
			// data to the server
			request.data = (fmt == 'xml' ? to_xml() : to_param());

			// Set the contentType
			// TODO: Extend to support JSON, others!
			request.contentType = (fmt == 'html' ? 'application/x-www-form-urlencoded' : ('text/' + fmt));

			// When the server response is finished downloading, invoke handleResponse
			request.addEventListener('complete', success);
			request.addEventListener('ioError', failure);

			// Finally, send off the XML data to the URL
			request.load();
		}


		// >>> EVENT HANDLERS
		private function after_create (e:Event) :void
		{
            id_from_response(e.target);
            after_find(e);
		}

		private function after_create_failed (e:Event) :void
		{
			Logger.debug(collection_name(self()) + ' after_create_failed: ' + e);
		}

		private function after_find (e:Event) :void
		{
			try
			{
				// store response
				response = e.target.response;
				// if response data is an array
				// use the first item
				var data:Object = (e.target.data is Array) ? e.target.data.shift() : e.target.data;
				// load data, then refire event
				load(data, e);
			}
			catch (err:Object)
			{
				Logger.debug('after_find! ' + err + ' :: Unable to parse result: ');
				Logger.dump(e.target.data);
			}
		}

		private function after_find_failed (e:Event) :void
		{
			Logger.debug(getQualifiedClassName(this) + ' after_find_failed: ' + e);
		}

		static public function after_find_all (e:Event, self:Class, collection:DataProvider, limit:uint) :void
		{
			try
			{
				// do NOT remove this logic:
				// ensures items is ALWAYS an array,
				// b/c XML parser doesn't know to force arrays
				var items:Array = (e.target.data is Array) ? e.target.data : [ e.target.data ];

				// instantiate each Model
				// add to collection in a batch, so only 1 'dataChange' event is fired
				var members:Array = [];
				for each (var item:Object in items)
				{
					members.push(new self(item));
					if (limit && members.length >= limit) break;
				}
				collection.addItems(members);
			}
			catch (err:Object)
			{
				Logger.debug('after_find_all! ' + err + ' :: Unable to parse result: ');
				Logger.dump(e.target.data);
			}
		}

		protected function after_property_change (e:PropertyChangeEvent) :void
		{
			// dispatch property_change for "change" listeners
	        var changeEvent:PropertyChangeEvent = new PropertyChangeEvent(e.property + '_change');
	        changeEvent.kind = e.kind;
	        changeEvent.property = e.property;
	        changeEvent.oldValue = e.oldValue;
	        changeEvent.newValue = e.newValue;
	        changeEvent.source = this;
			dispatchEvent(changeEvent);

			// dispatch property_validate for validators
			// prevents validators' stopImmediatePropagation() from
			// 	interfering with "change" listeners
			validate(e.property);
		}

		private function after_update (e:Event) :void
		{
			after_find(e);
		}

		private function after_update_failed (e:Event) :void
		{
			Logger.debug(collection_name(self()) + ' after_update_failed: ' + e);
		}

		static public function onFindAllFault (e:Event) :void
		{
			Logger.debug('ReactiveResource.onFindAllFault: ' + e);
		}

		private static function on_response_status (e:HTTPStatusEvent) :void
		{
			Logger.info('on_response_status: ' + e.status);
		}
	}
}