package metafas3
{
	import fl.controls.*;
	import fl.data.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	import metafas3.reaction_view.helpers.*;
	import metafas3.reaction_view.tags.*;

	dynamic public class XHTMLView extends ReactionView
	{
		public var xml:XML;

		// >>> COMPILER HACKS
		private static var __div:Function = div;
		private static var __embed:Function = embed;
		private static var __img:Function = img;
		private static var __input:Function = input;
		private static var __label:Function = label;
		private static var __select:Function = select;
		private static var __video:Function = video;

		private static var layout_tags:Object = {
			article:	'div',
			aside:		'div',
			fieldset:	'div',
			section:	'div'
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
					var ignoreWhitespace:Boolean = XML.ignoreWhitespace;
					XML.ignoreWhitespace = false;
					templates_cache(klass, XML(e.target.data.match(/<body>.*<\/body>/s).toString()));
					XML.ignoreWhitespace = ignoreWhitespace;
				}
				callback(e);
			});
			klass['loader'].load(SupervisingController.url_request_for(path));
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

					// TODO: this whole text vs box nonsense should be factored out into
					//		 individual tag classes and helpers. seriously. OOP this. (mf)
					// text tags
					// <h2>text</h2>
					if (text_tags[method])
					{
						options = attributes_to_hash(child);
						// re-serialize HTML for htmlText
						options.update({
							htmlText: child.toXMLString() // includes "child", its attributes, and children
						});
						args.push(options);
						method = 'label';
					}
					// layout boxes
					else if (layout_tags[method])
					{
						var vargs:Array = args;
						method = layout_tags[method];
						args = xml_children_to_display_objects(child.children());
						args.unshift(attributes_to_hash(child));
						logger.info(child);
						logger.info('--------box--------');
						logger.info('args: ' + args);
						logger.dump(args);
						logger.info('===================');
						vargs.push(xml_to_hash(child));
						logger.info('vargs: ' + vargs);
						logger.dump(vargs);
						logger.info('++++++++box++++++++');
					}
					// other UI elements
					else
					{
						options = xml_to_hash(child);
						args.push(options);
					}

					args.unshift(method);
					display_object = tag.apply(this, args);

					// add resulting object to display list
					if (display_object)
					{
						display_objects.push(display_object);
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

		// tag handler
		private function tag (node:String, options:Hash, ...args) :Helper
		{
			// lookup the tag helper
			try
			{
				var ztag:* = getDefinitionByName('metafas3.reaction_view.tags::' + node);
			}
			catch (e:*)
			{
				logger.info('XHTMLView unsupported tag: <' + node + ' />');
				return null;
			}

			// remove id, name for later assignment
			var id:String = options.remove('id');
			var name:String = options.remove('name');
			var matches:Array;

			// TODO: theoretically, all this databinding belongs in tags or helpers
			// parse name="model[property]" for databinding
			if (name)
			{
				// strip cakephp's data[] prefix
				name = name.replace(/^data\[(\w+)\]/, '$1');
				// infer data binding params from name
				matches = name.match(/(\w+)\[(\w+)\]/);
				if (matches)
				{
					// sanitize model name
					matches[1] = matches[1].toLowerCase();
					// set id to object_property
					options.name = id = matches[1] + '_' + matches[2];
					// allow <input type="hidden"> fields to assign model properties
					if (node == 'input' && options.type == 'hidden') this[matches[1]][matches[2]] = options.value;
				}
			}

			// invoke the tag factory
			args.unshift(options);
			var object:Helper = ztag.apply(null, args);

			if (object)
			{
				// assign id, name
				if (id)
				{
					this[id] = object;
					object.name = id;
				}

				// invoke the databinding helper
				if (matches && object.hasOwnProperty('bind_to')) object.bind_to(this[matches[1]], matches[2]);

				// add to display list and return
				addChild(object.display_object);
			}

			return object;
		}
	}
}