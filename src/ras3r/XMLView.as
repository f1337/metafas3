package ras3r
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	dynamic public class XMLView extends ReactionView
	{
		public var xml:XML;

		private static var _templates_cache:Object = {};
		private static function templates_cache (klass:Object, xml:XML = null) :XML
		{
			// TODO: watch to ensure this doesn't break order's dynamic templates
			// determine key for cache array:
			//		if exists, use view's 'path'
			//		else, use view's class name
			var key:String = (klass['path'] ? klass['path'].toString() : getQualifiedClassName(klass));
			if (xml) _templates_cache[key] = xml;
			return _templates_cache[key];
		}

		private static function load_template (klass:Object, path:String, callback:Function) :void
		{
			// load the XML template
			klass['loader'] = new URLLoader();
			klass['loader'].addEventListener('ioError', after_load);
			klass['loader'].addEventListener('securityError', after_load);
			klass['loader'].addEventListener('complete', function (e:Event) :void
			{
				// if XML template loaded successfully, cache the data
				if (e.target.data && e.target.data.toString().indexOf('<') == 0)
				{
					templates_cache(klass, XML(e.target.data));
				}
				callback(e);
			});
			klass['loader'].load(ReactionController.url_request_for(path));
		}

		override public function build () :void
		{
			xml_children_to_display_objects(xml.children());
		}


		// >>> PROTECTED METHODS
		// >>> PRIVATE METHODS
		// parse XML attributes as properties
		private function attributes_to_hash (xml:XML) :Hash
		{
			var options:Hash = new Hash;
			for each (var attr:XML in xml.attributes())
			{
				options[attr.localName()] = (attr.toString() === 'false' ? false : attr.toString());
			}
			return options;
		}

		private function xml_children_to_display_objects (xml_children:XMLList) :Array
		{
			var display_objects:Array = new Array;
			var method:String;

			for each (var child:XML in xml_children)
			{
				method = child.localName();

				if (method)
				{
					// args defaults to empty array
					var args:Array = new Array;

					// layout boxes
					// <vbox x="160" y="0" padding="10">...</vbox>
					// =>
					// vbox({ x: 160, y: 0, padding: 10 }, ... );
					if (method.match(/^[vh]box$/))
					{
						args = xml_children_to_display_objects(child.children());
						args.unshift(attributes_to_hash(child));
					}
					// subtemplates:
					// <orders.subtotal x="160" y="200" />
					// =>
					// render('orders/subtotal', { x: 160, y: 200 });
					else if (method.indexOf('.') >= 0)
					{
						args = [ method.replace('.', '/') ];
						args.push(attributes_to_hash(child))
						method = 'render';
					}
					// other UI elements
					else
					{
						var options:Hash = xml_to_hash(child);

						// handle data bindings
						if (options['for'])
						{
							args = options.remove('for').toString().split('.');
							method += '_for';
						}

						args.push(options);
					}

					display_objects.push(this[method].apply(this, args));
				}
			}

			return display_objects;
		}

		private function xml_to_hash (xml:XML) :Hash
		{
			var key:String;
			var options:Hash = attributes_to_hash(xml);
			var value:*;

			// parse children as properties
			for each (var child:XML in xml.children())
			{
				// value is a simple string, or a hash deserialed from XML
				value = (
					((! child.hasSimpleContent()) || child.attributes().length()) ?
					xml_to_hash(child) : child.children().toString());

				// use node name as key for non-text childrean
				key = child.localName();

				if (options[key] == null)
				{
					options[key] = value;
				}
				// options[key] is an array of values
				else if (options[key] is Array)
				{
					options[key].push(value);
				}
				// options[key] already exists as a single value
				// create an array of the old value and the new value
				else
				{
					options[key] = [ options[key], value ];
				}
			}

			return options;
		}

		// >>> EVENT HANDLERS
		// hijack added_to_stage => build() => render event chain
		// to load XML template
		override protected function after_added_to_stage (e:Event) :void
		{
			removeEventListener('addedToStage', after_added_to_stage);

			// cache the XML, if defined
			if (xml)
			{
				templates_cache(this, xml);
			}
			// else lookup XML from cache
			else
			{
				xml = templates_cache(this);
			}

			if (xml)
			{
				// resume event chain and build()
				super.after_added_to_stage(e);
			}
			else if (this['loader'])
			{
				this['loader'].addEventListener('complete', after_added_to_stage);
			}
			else if (this['path'])
			{
				load_template(this, this['path'], after_added_to_stage);
			}
		}

		// trap urlloader events
		private static function after_load (e:Event) :void
		{
		}
	}
}
