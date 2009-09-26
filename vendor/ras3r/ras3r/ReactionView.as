package ras3r
{
	import ras3r.*;
	import ras3r.controls.*;
	import ras3r.utils.*;

	import fl.core.*;
	import fl.controls.*;

	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;

	public class ReactionView extends Sprite
	{
		// >>> PUBLIC PROPERTIES
		protected function get controller () :ReactionController
		{
			var c:*;
			// traverse up parent hierarchy until Controller is located
			for (c = parent; (! (c is ReactionController)); c = c.parent)
			{
				// if parent is null, we are in limbo. break!
				if (! c) break;
			}
			// return Controller or null
			return c;
		}

		// >>> PUBLIC METHODS
		public function ReactionView ()
		{
			super();
		}

		public function build (w:Number, h:Number) :void
		{
			// override this method in subclasses (think: configUI())
			throw new Error('You must override build() in subclasses!');
		}

		public function hide (...args) :void
		{
			dispatchEvent(new Event('hide_view'));
		}

		public function show (...args) :void
		{
			dispatchEvent(new Event('show_view'));
		}
		
		// >>> PROTECTED METHODS
		// >>> HELPERS
		// box layout helper:
		protected function box (options:Object, ...args) :DisplayObjectContainer
		{
			options = new Hash({ direction: 'horizontal', padding: 4 }).update(options);

			var direction:String = options.remove('direction');
			var padding:uint = options.remove('padding');

			var axis_property:String = (direction == 'horizontal' ? 'x' : 'y');
			var size_property:String = (direction == 'horizontal' ? 'width' : 'height');

			// create container for positional grouping
			var container:Sprite = new Sprite();
			addChild(container);

			var previous:*;
			while (previous = args.shift())
			{
				// if box has explicit width, apply to children
				if (options.width) previous.width = options.width;

				container.addChild(previous);

				if (args.length > 0) 
				{
					args[0][axis_property] = previous[axis_property] + previous[size_property] + padding;
				}
			}

			return container;
		}

		// label: String. Text label to display on button.
		// attr: Hash. Optional. Properties to be applied to button upon creation (w, h, x, y, etc).
		protected function button (label:String, attr:Object = null, styles:Object = null) :*
		{
			var klass:Class = LabelButton;
			if (attr)
			{
				if (attr.klass as Class) klass = attr.klass;
				delete attr.klass;
			}
			else
			{
				attr = {};
			}
			if (! attr.width) attr.width = 100;
			if (! attr.height) attr.height = 20;
			attr.label = label;
			attr.useHandCursor = true;
			return sprite(klass, attr, styles);
		}

		// label: String. Text label to display on button.
		// options: Hash. Valid options:
		//	- action: 	String method name of controller to call when visual element dipatches event.
		// attr: Hash. Optional. Properties to be applied to button upon creation (w, h, x, y, etc).
		protected function button_to (label:String, options:Object, attr:Object = null) :*
		{
			var button:* = button(label, attr);
			link_to(button, options);
			return button;
		}

		// label: String. Text label to display on button.
		// handler: Function. Function to call when visual element dipatches event.
		// attr: Hash. Optional. Properties to be applied to button upon creation (w, h, x, y, etc).
		// event: String. Optional. Event dispatched by visual element to listen for. Default = 'click'
		//protected function button_to_function (label:String, ...args) :*
		protected function button_to_function (label:String, handler:Function, attr:Object = null, event:String = 'click') :*
		{
			//			attr:Object = null, event:String = 'click') :void
//			var attr:Object = args.splice(1, 1).shift();
			var button:* = button(label, attr);
			link_to_function(button, handler, event);
			return button;
		}

		protected function combo_box (object_name:String, property:String, attributes:Object = null, styles:Object = null) :ComboBox
		{
			return (instance_sprite(ComboBox, 'dataProvider', object_name, property, attributes, styles) as ComboBox);
		}

		// horizontal layout helper:
		protected function hbox (options:Object, ...args) :DisplayObjectContainer
		{
			args.unshift(options);
			return box.apply(null, args);
		}

		protected function image (object_name:String, property:String, attributes:Object = null, styles:Object = null) :Image
		{
			return (instance_sprite(Image, 'source', object_name, property, attributes, styles) as Image);
		}

		protected function instance_sprite (name:*, assign_property:String, object_name:String, object_property:String, attributes:Object = null, styles:Object = null) :DisplayObject
		{
			// infer default instance id, but allow for manual override
			attributes = new Hash({ id: (object_name + '_' + object_property) }).update(attributes);
			// assignment via attributes hash
			try
			{
				attributes[assign_property] = this[object_name][object_property];
				//instance[assign_property] = this[object_name][object_property];
			}
			catch (exception:*)
			{
				// do nothing, just a sand trap
				// to debug:
				// Logger.info('ReactionView#instance_sprite exception: ' + exception);
			}
			// instantiation
			var instance:* = sprite(name, attributes, styles);
			// return
			return instance;
		}

		protected function label (object_name:String, property:String, html:String, attributes:Object = null, styles:Object = null) :TextField
		{
			// infer default instance id, but allow for manual override
			attributes = new Hash({ 
				id: 		(object_name + '_' + property + '_label'),
				htmlText:	html
			}).update(attributes);
			return (sprite(TextField, attributes, styles) as TextField);
		}

		// elem: Object. Visual element for whom the handler is being wired
		// options: Hash. Valid options:
		//	- action: 	String method name of controller to call when visual element dipatches event.
		//	- on:		String. Optional. Event dispatched by visual element to listen for. Default = 'click'
		public function link_to (elem:Object, options:Object) :void
		{
			// default controller name
			if (! options.controller) options.controller = controller.controller_name();

			// lookup controller instance
//			var c:* = ReactionController.controller(options.controller);
//			delete options.controller;

			var args:Array = [ ];

			// custom event override
			if (options.on) args.push(options.on);
			delete options.on;

			// controller action
//			var action:String = options.action;
//			delete options.action;

			// filter chain delegate
//			args.unshift(Delegate.create(c.process, action, options));
			args.unshift(Delegate.create(ReactionController.redirect_to, options));

			args.unshift(elem);
			link_to_function.apply(null, args);
		}

		protected function link_to_url (elem:Object, url:String) :void
		{
			link_to(elem, { action: 'get_url', url: url });
		}

		// elem: Object. Visual element for whom the handler is being wired
		// handler: Function. Function to call when visual element dipatches event.
		// event: String. Optional. Event dispatched by visual element to listen for. Default = 'click'
		protected function link_to_function (elem:Object, handler:Function, event:String = 'click') :void
		{
			elem.addEventListener(event, handler);
		}

		// name: String OR Class. 
		//		string: The under_score_name of the Sprite to create. Ex: 'text_field'
		//		class: 	Reference to the class constructor. Ex: LabelButton
		// attr: Hash. Optional. Properties to be applied to sprite upon creation (w, h, x, y, etc).
		// USAGE:
		// sprite('text_field', { x: 5, y: 22, width: 200, height: 20, autoSize: 'center' });
		// sprite(TextField, { x: 5, y: 22, width: 200, height: 20, autoSize: 'center' });
		protected function sprite (name:*, attr:Object = null, styles:Object = null) :*
		{
			// get class from under_score_name
			var klass:Class = (name is String) ? name_to_class(name) : (name as Class);
			var sprite:* = new klass();

			// track by id if present
			if (attr && attr.id)
			{
				this[attr.id] = sprite;
				delete attr.id;
			}

			// assign attributes
			for (var p:String in attr)
			{
				sprite[p] = attr[p];
			}

			// assign styles
			var ui:UIComponent = sprite as UIComponent;
			if (ui)
			{
				for (var s:String in styles)
				{
					ui.setStyle(s, styles[s]);
				}
			}

			// TextField size sanity check
//			if (sprite.hasOwnProperty('textHeight') && sprite.textHeight) sprite.height = (sprite.textHeight + 4);

			// add to display list
			return addChild(sprite);
		}

		protected function text_field (object_name:String, property:String, attributes:Object = null, styles:Object = null) :TextField
		{
			return (instance_sprite(TextField, 'htmlText', object_name, property, attributes, styles) as TextField);
		}

		protected function text_input (object_name:String, property:String, attributes:Object = null, styles:Object = null) :TextInput
		{
			return (instance_sprite(TextInput, 'text', object_name, property, attributes, styles) as TextInput);
		}

		protected function truncate (tf:TextField, suffix:String = '...') :void
		{
			var fw:Number = tf.width;
			var tw:Number = tf.textWidth;
			if (tw > fw)
			{	
				var sl:Number = tf.text.length;
				var max_sl:Number = Math.round(sl * (fw / tw)) - 5;
				var regex:RegExp = new RegExp('.{0,'+max_sl+'}\\b');
				tf.text = regex.exec(tf.text) + '...';
			}
		}

		protected function url_for (absolute_path:String, subdomain:String = null) :String
		{
			return ReactionController.url_for(absolute_path, subdomain);
		}

		protected function url_request_for (absolute_path:String, subdomain:String = null) :URLRequest
		{
			return ReactionController.url_request_for(absolute_path, subdomain);
		}

		// vertical layout helper:
		protected function vbox (options:Object, ...args) :DisplayObjectContainer
		{
			options.direction = 'vertical';
			args.unshift(options);
			return box.apply(null, args);
		}


		// >>> PRIVATE METHODS
		private function name_to_class (name:String) :Class
		{
			var klass:Class;
			var className:String = Inflector.camelize(name);

			try
			{
				klass = getDefinitionByName('fl.components.' + className) as Class
			}
			catch (e:Error)
			{
				// ok, that didn't work
				klass = getDefinitionByName('flash.text.' + className) as Class
/*
				try
				{
				}
				catch (e:Error)
				{
					// ok, that didn't work
				}
*/
			}
			finally
			{
				return klass;
			}
		}


		// >>> EVENT HANDLERS
	}
}
