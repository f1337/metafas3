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
			var method:String;

			for each (var child:XML in xml.children())
			{
				// <content x="24" y="24" width="372" height="369"/>
				method = child.localName();

				if (method)
				{
					var options:Hash = xml_to_hash(child);

					if (options['for'])
					{
						var args:Array = options.remove('for').toString().replace(/\{\s*/g, '').replace(/\s*\}/g, '').split('.');
						args.push(options);
						this[method + '_for'].apply(this, args);
					}
				}
			}
		}


		// >>> PROTECTED METHODS
/*		protected function content_for_layout (bounds:Object) :void
		{
			Logger.info('content_for_layout');
			Logger.dump(bounds);
		}
*/

		// >>> PRIVATE METHODS
		private function xml_to_hash (xml:XML) :Hash
		{
			var options:Hash = new Hash;

			// parse attributes as properties
			for each (var attr:XML in xml.attributes())
			{
				options[attr.localName()] = attr;
			}

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
