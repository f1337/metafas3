/* 
- Extend ObjectProxy? - 11k footprint! #*@!^&%  - but Proxy is in the player!
*/
package ras3r 
{
	import ras3r.utils.*;
	import ras3r.reactive_resource.*;

	import fl.data.DataProvider;
	import fl.events.DataChangeEvent;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;

	//import code.google.as3httpclient.*;

	use namespace flash_proxy;

	// required if you want to use BindingUtils or ChangeWatcher on dynamic properties!
	// curly braces bindings in MXML cause this directive to be created at compile-time,
	// however AS3 runtime bindings do NOT.
	[Bindable("propertyChange")]

	dynamic public class ReactiveResource extends ObjectProxy
	{
		XML.prettyPrinting = false;

		// >>> PUBLIC PROPERTIES
		// Hashmap to track databound properties whose change events need broadcasted.
		public var attributes:Object = new Object();
		public var errors:Array = new Array();
		public var location:String; // prevent location from serialzing
		public var prefix:String = '/';

		public function set error (msg:String) :void
		{
			errors.push(msg);
		}

		// >>> PROTECTED PROPERTIES

		// >>> CONSTANTS

		// >>> STATIC PROPERTIES
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
			var url:String = prefix_source(self, prefix_options);
						
			url += '.xml';

			return url;
		}
		
		static public function element_path (self:Class, id:Object, prefix_options:Object = null, query_options:Object = null) :String // pseudo-equivalent to RoR's table_name
		{
			var url:String = prefix_source(self, prefix_options);
			
			url += '/' + id + '.xml';

			return url;
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

		static private function find_all (self:Class, options:Hash = null) :DataProvider
		{
			// pop from: param
			var from:String = options.remove('from');

			// pop from: param
			var limit:String = options.remove('limit');

			// create empty collection
			var collection:DataProvider = new DataProvider();

			// bubble DataChange event to 'complete' handler
			//if (options && options.complete is Function) collection.addEventListener(DataChangeEvent.DATA_CHANGE, options.remove('complete'));
			// wire event handlers (aka 'observers')
			add_observers(collection, options, DataChangeEvent.DATA_CHANGE);

			// execute request
			get((from ? from : collection_path(self, options)), Delegate.create(after_find_all, self, collection, limit), onFindAllFault, options);

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

		static private function find_single (self:Class, id:int, args:Hash = null) :*
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
		// ReactiveResource.extend(prototype.constructor)
		static public function extend (c:Class, prefix:String = '/') :void
		{
			// set prefix
			c.prototype.prefix = prefix;

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


		// >>> PUBLIC METHODS
		public function ReactiveResource (attrs:* = null) 
		{
			super(attributes);

			// assign attributes if passed
			if (attrs is XML)
			{
				load((new Response(attrs)).body);
			}
			else if (attrs is Object)
			{
				load(attrs);
			}
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
			self().prototype.prefix.replace(/:(\w+)/g, inject_prefix_option);

			return prefix_options;
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

		public function save (args:Object = null) :void
		{
			// clear errors
			errors = new Array();

			if (args && args.complete is Function)
			{
				// bubble complete event
				addEventListener('complete', args.complete);
			}
			(this.id ? update() : create());
/*			create();*/
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
				xml.appendChild(node);
				// every child node's value must be cast to String
				xml[i] = value;
			}

			// send it back
			return xml;
		}

		// >>> PROTECTED METHODS
		protected function create () :void
		{
			send('POST', collection_path(), to_xml(), after_create, after_create_failed);
		}

		protected function collection_path (options:Object = null) :String
		{
			return ReactiveResource.collection_path(self(), (options ? options : prefix_options()));
		}

		protected function element_path (options:Object = null) :String
		{
			return ReactiveResource.element_path(self(), this.id, (options ? options : prefix_options()));
		}

		protected function update () :void
		{
			send('PUT', element_path(), to_xml(), after_update, after_update_failed);
		}

		protected function self () :Class
		{
			return getDefinitionByName(getQualifiedClassName(this).replace('::', '.')).prototype.constructor;
		}

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
		private function send (method:String, path:String, data:XML, success:Function, failure:Function) :void
		{
			var request:Request = new Request(method, path);

			// Set the data property to the dataToSave XML instance to send the XML
			// data to the server
			request.data = data;
			// Set the contentType to signal XML data being sent
			request.contentType = 'text/xml';

			// When the server response is finished downloading, invoke handleResponse
			request.addEventListener('complete', success);
			request.addEventListener('ioError', failure);

			// Finally, send off the XML data to the URL
			request.load();
		}


		// >>> EVENT HANDLERS
		private function after_create (e:Event) :void
		{
			var location:String = e.target.data.location.toString();
			if (! (location.length)) return after_create_failed(e);
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
				// if response data is an array
				// use the first item
				Logger.dump(e.target.data);
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