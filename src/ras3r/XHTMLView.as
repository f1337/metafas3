package ras3r
{
	import fl.controls.*;
	import fl.data.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	import ras3r.reaction_view.helpers.*;

	dynamic public class XHTMLView extends ReactionView
	{
		public var xml:XML;

		private static var layout_tags:Object = {
			article:	'box',
			aside:		'box',
			fieldset:	'box',
			header:		'box',
			section:	'box'
		};

		private static var text_tags:Object = {
			a:			true,
			div:		true,
			h1:			true,
			h2:			true,
			h3:			true,
			h4:			true,
			h5:			true,
			h6:			true,
/*			label:		true,*/
			p:			true,
			span:		true
		};

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
			var display_object:Object;
			var method:String;

			for each (var child:XML in xml_children)
			{
				display_object = null;
				method = child.localName();

				if (method)
				{
					// args defaults to empty array
					var args:Array = new Array;
					var options:Hash;

					// layout boxes
					if (layout_tags[method])
					{
						method = layout_tags[method];
						args = xml_children_to_display_objects(child.children());
						args.unshift(attributes_to_hash(child));
					}
					// text tags
					// <h2>text</h2>
					else if (text_tags[method])
					{
						options = attributes_to_hash(child);
						// re-serialize HTML for htmlText
						options.update({
							htmlText: child.toXMLString() // includes "child", its attributes, and children
						});
						args.push(options);
						method = 'label';
					}
					// other UI elements
					else
					{
						options = xml_to_hash(child);
						args.push(options);
					}

					// invoke the helper method, if it exists
					if (this[method])
					{
						display_object = this[method].apply(this, args);
						if (display_object) display_objects.push(display_object);
					}
					// helper method unknown: ignore the parent tag,
					//	process its children as siblings
					else
					{
						display_objects.push.apply(display_objects, xml_children_to_display_objects(child.children()));
					}
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
/*				value = (
					((! child.hasSimpleContent()) || child.attributes().length()) ?
					xml_to_hash(child) : child.children().toString());
*/
				value = (
					(child.hasComplexContent() || child.attributes().length()) ?
					xml_to_hash(child) : child.toString());

				// use node name as key for non-text childrean
				key = child.localName();
				if (key) key = key.toString();

				// use '_text' as key for text nodes
				if (key == null)
				{
					options['_text'] = value;
				}
				// options[key] is a single value
				else if (options[key] == null)
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


		// >>> TAG HANDLERS
		protected function box (options:Object, ...args) :DisplayObjectContainer
		{
			options.children = args;
			options.direction ||= 'vertical';
			return (helper(BoxHelper, new Hash(options)) as DisplayObjectContainer);
		}

		protected function fieldset (options:Object, ...args) :DisplayObjectContainer
		{
			options.children = args;
			options.direction ||= 'horizontal';
			return (helper(FieldsetHelper, new Hash(options)) as DisplayObjectContainer);
		}

		// parse <embed> tag as "Image" (custom UILoader)
		// (mf) kinda defeats the purpose of HTML5 fallback content?
/*		protected function embed (options:Hash) :DisplayObject
		{
			options.remove('type'); // discard type, we don't use it.
			options.source = options.remove('src');
			return image(options);
		}
*/
		override protected function image (options:Object) :DisplayObject
		{
			throw(new Error('<image> is not a valid XHTML tag!'));
		}

		// parse <img> tag as "Image" (custom UILoader)
		protected function img (options:Hash) :DisplayObject
		{
			options.remove('alt'); // discard alt, we don't use it.
			options.source = options.remove('src');
			return super.image(options);
		}

		// parse <input> tags as corresponding UIComponents
		protected function input (options:Hash) :DisplayObject
		{
			// infer data bindings from field names
			var bindings:Array;
			if (options.name)
			{
				bindings = options.remove('name').match(/(data\[)?(\w+)\]?\[(\w+)\]/);
				if (bindings) bindings[2] = bindings[2].toLowerCase()
			}

			var method:String;
			var type:String = options.remove('type');
			switch (type)
			{
				case 'checkbox':
					method = 'check_box_for';
					break;
				case 'radio':
					return radio_button(options);
					break;
				// allow hidden fields to assign model properties
				case 'hidden':
					if (bindings) this[bindings[2]][bindings[3]] = options.value;
					break;
				case 'image':
					options.source = options.remove('src');
					return image_button(options);
					break;
				case 'text':
				default:
					method = 'text_input_for';
					break;
			}

			return ((method && bindings) ? this[method](bindings[2], bindings[3], options) : null);
		}

		override protected function label (...args) :TextField
		{
			var options:Hash = args.pop();

			// support <label> nodes
			if (options._text) options.text = options.remove('_text');

			// strip <span>s and convert to <font>
			// <span style="color: #b87236; font-family: 'Helvetica Neue LT Std 56 Italic'; font-style: italic;"> special discount </span>
			if (options.htmlText)
			{
				options.htmlText = options.htmlText.replace(/\s{2,}/gs, '').replace(/<span[^>]*style="([^>]+)"[^>]*>([^<]+)<\/span>/g, ' $2 ');
/*				options.condenseWhite = false;*/
				logger.info('htmlText: ' + options.htmlText);
			}


			// hijack <a>nchor href properties
			if (options.href) options.htmlText = options.htmlText.replace(/<a([^>]+)href="[^\"]+"/, '<a$1href="event:' + options.remove('href') + '"');

			return super.label(options);
		}

		// parse <select> tag as ComboBox
		protected function select (options:Hash) :ComboBox
		{
			// extract choices from options
			var choices:* = options.remove('option');
			// translate XHTML5 option data for ComboBox
			choices.every(function (o:Hash, ...args) :Boolean
			{
				// re-key "value" as "data"
				o.data = o.remove('value');
				// re-key "text" as "label"
				o.label = o.remove('_text');
				// assign selected item
				if (o.remove('selected')) options.selectedItem = o;
				return true;
			});
			// cast choices to DataProvider
			options.dataProvider = (choices is DataProvider) ? choices : (new DataProvider(choices));
			// invoke the ComboBox factory and return
			return (helper(ComboBoxHelper, options) as ComboBox);
		}
	}
}