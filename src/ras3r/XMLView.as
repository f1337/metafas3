package ras3r
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	dynamic public class XMLView extends ReactionView
	{
		private var xml:XML;

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
					var args:Array= new Array;

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
			var options:Hash = attributes_to_hash(xml);

			// parse children as properties
			for each (var child:XML in xml.children())
			{
				options[child.localName()] = (
					((! child.hasSimpleContent()) || child.attributes().length()) ?
					xml_to_hash(child) : child.children().toString());
			}

			return options;
		}

		// >>> EVENT HANDLERS
		// hijack added_to_stage => build() => render event chain
		// to load XML template
		override protected function after_added_to_stage (e:Event) :void
		{
			removeEventListener('addedToStage', after_added_to_stage);

			// load the XML template
			var loader:URLLoader = new URLLoader();
			loader.addEventListener('complete', after_load);
			// loader.addEventListener('httpStatus', after_load);
			loader.addEventListener('ioError', after_load);
			// loader.addEventListener('open', after_load);
			// loader.addEventListener('progress', after_load);
			loader.addEventListener('securityError', after_load);
			loader.load(ReactionController.url_request_for(this['path']));
		}

		// after XML template loads, resume event chain
		private function after_load (e:Event) :void
		{
			// if XML template loaded,
			if (e.target.data && e.target.data.toString().indexOf('<') == 0)
			{
				// parse XML
				xml = XML(e.target.data);
				// resume event chain and build()
				super.after_added_to_stage(e);
			}
		}
	}
}
