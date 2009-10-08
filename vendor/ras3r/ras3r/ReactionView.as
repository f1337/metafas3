package ras3r
{
	import com.gigya.*;

	import ras3r.*;
	import ras3r.controls.*;
	import ras3r.reaction_view.helpers.*;
	import ras3r.utils.*;

	import fl.core.*;
	import fl.controls.*;
	import fl.data.*;

	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;

	public class ReactionView extends Sprite
	{
		// >>> STATIC PROPERTIES
		public static var debug:Boolean = false;

		// >>> STATIC METHODS
		// USAGE: 	ReactionView.create('layouts/application', { header: 'my name' });
		//			ReactionView.create('products/show', { title: 'Cheeseburger' });
		// Instantiates DisplayObject/View described by @template, and 
		// copies properties from assigns hash to new DisplayObject/View
		static public function create (template:String = null, assigns:Object = null) :DisplayObject
		{
			// default to ReactionView if template empty
			template = (template ? template_class_name(template) : 'ras3r.ReactionView');
			// lookup class definition from template name
			var klass:Class = (getDefinitionByName(template) as Class);
			// new View()
			var view:* = new klass();
			// assign controller property first
			assigns = new Hash(assigns);
			if (assigns.controller)
			{
				view.controller = assigns.remove('controller');
				assigns.update(view.assigns_from_controller());
			}
			// inject debug backgrounds
			if (debug) assigns.opaqueBackground = ((template.indexOf('views.layouts.') == 0) ? 0xddddff : 0xffdddd);
			// copy properties from assigns hash to DisplayObject/View
			assigns.apply(view);
			// create child display
			view.addEventListener('addedToStage', view.after_added_to_stage);
			// return DisplayObject/View
			return (view as DisplayObject);
		}

		// template_class_name('layouts/application') => 'views.layouts.ApplicationLayout'
		// template_class_name('rockets/show') => 'views.rockets.ShowRocket'
		// template_class_name('rockets/list') => 'views.rockets.ListRockets'
		static private function template_class_name (template:String) :String
		{
			var t:Array = template.split('/');
			var className:String = 'views.';
			className += t[0] + '.';
			if (t[1])
			{
				className += Inflector.camelize(t[1]);
				if (t[1].indexOf('list') == -1) t[0] = Inflector.singularize(t[0]);
			}
			className += Inflector.camelize(t[0]);
			return className;
		}


		// >>> PUBLIC PROPERTIES
		// >>> PRIVATE PROPERTIES
		private function assigns_from_controller () :Hash
		{
			var _assigns:Hash = new Hash;

			// for each public controller property,
			// add key and current value to assigns hash
            var properties:XMLList = describeType(controller).variable;
			var p:String;
            for (var n:String in properties)
			{
				p = properties.@name[n];
				_assigns[p] = controller[p];
			}

			return _assigns;
		}


		// >>> PROTECTED PROPERTIES
		private var controller:ReactionController;


		// >>> PUBLIC METHODS
		public function ReactionView ()
		{
			super();
		}

		public function build () :void
		{
			// override this method in subclasses (think: configUI())
			Logger.info('DEPRECATION NOTICE: ReactionView#build');
			//throw new Error('You must override build() in subclasses!');
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

		protected function combo_box_for (object_name:String, property:String, choices:*, attributes:Object = null, styles:Object = null) :ComboBox
		{
			var dataProvider:DataProvider = (choices is DataProvider) ? choices : (new DataProvider(choices));
			attributes = new Hash(attributes).update({ dataProvider: dataProvider });

			return (addChild(assigns_for(ComboBoxHelper.create(attributes), 'selectedItem', object_name, property)) as ComboBox);
		}

		protected function hbox (options:Object, ...args) :DisplayObjectContainer
		{
			return (addChild(BoxHelper.hbox(options, args)) as DisplayObjectContainer);
		}

/*		protected function image_for (object_name:String, property:String, attributes:Object = null, styles:Object = null) :Image
		{
			return (sprite_for(Image, 'source', object_name, property, attributes, styles) as Image);
		}
*/
		protected function image_for (object_name:String, property:String, options:Object = null) :DisplayObject
		{
			return helper_for(ImageHelper, options, 'source', object_name, property);
/*			return (addChild(assigns_for(ImageHelper.create(attributes), 'source', object_name, property)) as DisplayObject);*/
/*			return (addChild(assigns_for(ImageHelper.create(attributes), 'source', object_name, property)) as DisplayObject);*/
		}

		protected function label (html:String, options:Object = null) :TextField
		{
			options = new Hash(options).update({ htmlText: html });
			var id:String = options.remove('id');
			if (debug) options.opaqueBackground = 0xddffdd;
			var sprite:DisplayObject = TextFieldHelper.create(options);
			assign_id_for_object({ id: id }, sprite);
			return (addChild(sprite) as TextField);
		}

		protected function label_for (object_name:String, property:String, html:String, options:Object = null, styles:Object = null) :TextField
		{
			options = new Hash({ htmlText: html }).update(options);
			if (debug) options = new Hash({ opaqueBackground: 0xddffdd }).update(options);

			var sprite:DisplayObject = TextFieldHelper.create(options);
			assign_id_for_object({ id: (object_name + '_' + property + '_label') }, sprite);
			return (addChild(sprite) as TextField);
		}

		protected function render (template:String, assigns:Object = null) :DisplayObject
		{
			// inject controller property into assigns hash
			if (controller) assigns = new Hash(assigns).update({ controller: controller });
			// create the view
			return addChild(ReactionView.create(template, assigns));
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

			// assign id if defined
			assign_id_for_object(attr, sprite);

			// assign attributes
			for (var p:String in attr)
			{
				try
				{
					sprite[p] = attr[p];
				}
				catch (exception:*)
				{
					Logger.info('ReactionView#sprite attribute assignment exception: ' + exception);
				}
			}

			var ui:UIComponent = sprite as UIComponent;
			if (ui)
			{
				// TODO: deprecate seperate styles hash
				// assign styles
				for (var s:String in styles)
				{
					ui.setStyle(s, styles[s]);
				}

				// work around sizing bug:
				// ui.setSize(ui.width, ui.height);
			}

			// add to display list
			return addChild(sprite);
		}

/*		protected function sprite_for (name:*, assign_property:String, object_name:String, object_property:String, attributes:Object = null, styles:Object = null) :DisplayObject
		{
			attributes = options_for(assign_property, object_name, object_property).update(attributes);

			// HACK: juggling two usage methods until all helpers are refactored
			if (name is DisplayObject) assign_id_for_object(attributes, name);
			return ((name is DisplayObject) ? name : sprite(name, attributes, styles));
		}
*/
		protected function text (html:String, attributes:Object = null) :TextField
		{
			attributes = new Hash(attributes).update({ multiline: true, wordWrap: true });
			return (label(html, attributes) as TextField);
		}

		protected function text_for (object_name:String, property:String, options:Object = null) :TextField
		{
			options = options_for('htmlText', object_name, property).update(options);
			var id:String = options.remove('id');
			if (debug) options = new Hash({ opaqueBackground: 0xddffdd }).update(options);

			var sprite:DisplayObject = TextFieldHelper.create(options);
			assign_id_for_object({ id: id }, sprite);
			return (addChild(sprite) as TextField);
		}

		protected function text_input_for (object_name:String, property:String, options:Object = null) :TextInput
		{
			return (helper_for(TextInputHelper, options, 'text', object_name, property) as TextInput);
/*			return (addChild(assigns_for(TextInputHelper.create(options), 'text', object_name, property)) as TextInput);*/
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

		protected function vbox (options:Object, ...args) :DisplayObjectContainer
		{
			return (addChild(BoxHelper.vbox(options, args)) as DisplayObjectContainer);
		}

		// USAGE: wildfire(1234567, { height: 260, width: 340 });
		protected function wildfire (partner_id:int, options:Object = null) :DisplayObject
		{
			options.partner = partner_id;
			return addChild(new Wildfire(options));
		}

		// >>> PRIVATE METHODS
		private function assign_id_for_object (attr:Object, sprite:Object) :void
		{
			if (attr && attr.id)
			{
				this[attr.id] = sprite;
				sprite.name = attr.id;
				delete attr.id;
			}
		}

		private function assigns_for (name:*, assign_property:String, object_name:String, object_property:String, attributes:Object = null, styles:Object = null) :*
		{
			attributes = options_for(assign_property, object_name, object_property).update(attributes);
			// HACK: juggling two usage methods until all helpers are refactored
			assign_id_for_object(attributes, name);
			return name;
		}

		// return helper_for(TextInputHelper, options, 'text', object_name, property)
		private function helper_for (helper:*, options:Object, assign_property:String, object_name:String, object_property:String) :DisplayObject
		{
			options = new Hash({ name: (object_name + '_' + object_property) }).update(options);
			// TODO: replace with databinding
			options[assign_property] = this[object_name][object_property];
			this[options.name] = helper.create(options);
			return addChild(this[options.name]);
		}

/*		private function options_for (assign_property:String, object_name:String, object_property:String, options:Object) :Hash*/
		private function options_for (assign_property:String, object_name:String, object_property:String) :Hash
		{
			// infer default instance id, but allow for manual override
			var options:Hash = new Hash({ id: (object_name + '_' + object_property) });

			// assignment via attributes hash
			// TODO: replace with databinding
			options[assign_property] = this[object_name][object_property];

			return options;
		}

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
		private function after_added_to_stage (e:Event) :void
		{
			removeEventListener('addedToStage', after_added_to_stage);
			//Logger.info(this + ' addedToStage pre build');
			addEventListener('render', after_render);
			build();
			//Logger.info(this + ' addedToStage post build');
		}

		private function after_render (e:Event) :void
		{
			removeEventListener('render', after_render);
			//Logger.info(this + ' render');

			// for each public controller method named "on_some_element_event",
			// add event listener some_element
			var element:String;
			var event:String;
			var parts:Array;
            var methods:XMLList = describeType(controller).method;
			var method:String;
            for (var n:String in methods)
			{
				method = methods.@name[n];
				if (method.indexOf('on_') == 0)
				{
					parts = method.split('_');
					parts.shift(); // drop on_
					event = parts.pop(); // grab _event
					element = parts.join('_');
					if (this.hasOwnProperty(element)) this[element].addEventListener(event, controller[method]);
				}
			}
		}


		/*****************************************************
		*
		*	D E P R E C A T E D    M E T H O D S
		*
		*****************************************************/
/*
		// label: String. Text label to display on button.
		// options: Hash. Valid options:
		//	- action: 	String method name of controller to call when visual element dipatches event.
		// attr: Hash. Optional. Properties to be applied to button upon creation (w, h, x, y, etc).
		private function button_to (label:String, options:Object, attr:Object = null) :*
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
		private function button_to_function (label:String, handler:Function, attr:Object = null, event:String = 'click') :*
		{
			var button:* = button(label, attr);
			link_to_function(button, handler, event);
			return button;
		}

		// elem: Object. Visual element for whom the handler is being wired
		// options: Hash. Valid options:
		//	- action: 	String method name of controller to call when visual element dipatches event.
		//	- on:		String. Optional. Event dispatched by visual element to listen for. Default = 'click'
		private function link_to (elem:Object, options:Object) :void
		{
			// default controller name
			if (! options.controller) options.controller = controller.controller_name();

			var args:Array = [ ];

			// custom event override
			if (options.on) args.push(options.on);
			delete options.on;

			// filter chain delegate
			args.unshift(Delegate.create(controller.redirect_to, options));

			args.unshift(elem);
			link_to_function.apply(null, args);
		}

		private function link_to_url (elem:Object, url:String) :void
		{
			link_to(elem, { action: 'get_url', url: url });
		}

		// elem: Object. Visual element for whom the handler is being wired
		// handler: Function. Function to call when visual element dipatches event.
		// event: String. Optional. Event dispatched by visual element to listen for. Default = 'click'
		private function link_to_function (elem:Object, handler:Function, event:String = 'click') :void
		{
			elem.addEventListener(event, handler);
		}
*/
	}
}
