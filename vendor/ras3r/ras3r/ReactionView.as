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

	import mx.events.PropertyChangeEvent;

	public class ReactionView extends Sprite
	{
		// >>> STATIC PROPERTIES
		public static var debug:Boolean = false;

		// >>> STATIC METHODS
		// USAGE: 	ReactionView.create('layouts/application', { header: 'my name' });
		//			ReactionView.create('products/show', { title: 'Cheeseburger' });
		// Instantiates DisplayObject/View described by @template, and 
		// copies properties from assigns hash to new DisplayObject/View
		static public function create (template:* = null, assigns:Object = null) :DisplayObject
		{
			// default to BaseReactionView if template empty
			template = (template ? template_class_name(template) : BaseReactionView);
			// lookup class definition from template name
			var klass:Class = (template is Class ? template : (getDefinitionByName(template) as Class));
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
/*		protected function button (label:String, attr:Object = null, styles:Object = null) :*
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
*/
		protected function combo_box_for (object_name:String, property:String, choices:*, attributes:Object = null) :ComboBox
		{
			// cast choices to DataProvider
			var dataProvider:DataProvider = (choices is DataProvider) ? choices : (new DataProvider(choices));
			// update atrributes with choices 
			attributes = new Hash(attributes).update({ dataProvider: dataProvider });
			return (helper_for(ComboBoxHelper, attributes, 'selectedItem', object_name, property) as ComboBox);
		}

		protected function hbox (options:Object, ...args) :DisplayObjectContainer
		{
			return (addChild(BoxHelper.hbox(options, args)) as DisplayObjectContainer);
		}

		protected function image_for (object_name:String, property:String, options:Object = null) :DisplayObject
		{
			return helper_for(ImageHelper, options, 'source', object_name, property);
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

		public function radio_buttons_for (object_name:String, property:String, choices:*, options:Object = null) :DisplayObject
		{
			// cast choices to DataProvider
			var dataProvider:DataProvider = (choices is DataProvider) ? choices : (new DataProvider(choices));
			// update options with choices 
			options = new Hash(options).update({ dataProvider: dataProvider });
			return (helper_for(RadioButtonGroupHelper, options, 'selectedData', object_name, property) as DisplayObject);
		}

		protected function text (html:String, attributes:Object = null) :TextField
		{
			attributes = new Hash(attributes).update({ multiline: true, wordWrap: true });
			return (label(html, attributes) as TextField);
		}

		protected function text_for (object_name:String, property:String, options:Object = null) :TextField
		{
			if (debug) options = new Hash({ opaqueBackground: 0xddffdd }).update(options);
			return (helper_for(TextFieldHelper, options, 'htmlText', object_name, property) as TextField);
		}

		public function text_input_for (object_name:String, property:String, options:Object = null) :TextInput
		{
			return (helper_for(TextInputHelper, options, 'text', object_name, property) as TextInput);
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

		private function bind_property (display_object:*, object_name:String, object_property:String) :void
		{
			var listener:* = ((display_object is Helper) ? display_object.display_object : display_object);
			if (controller && controller.hasOwnProperty('on_' + display_object.name + '_change'))
			{
				// after_render will setup display object change handler
				// all we need to do here is setup model property change handler
				this[object_name].addEventListener((object_property + '_change'), controller[('on_' + display_object.name + '_change')]);
			}
			else if (this[object_name] is IEventDispatcher)
			{
				var view:ReactionView = this;
				var responder:Function = function (e:Event) :void
				{
					if (e.target is TextInput)
					{
/*						Logger.info('binding responder: ' + object_name + '.' + object_property + ' = ' + e.target.text);*/
						view[object_name][object_property] = e.target.text;
					}
					else if (e.target is ComboBox)
					{
/*						Logger.info('binding responder: ' + object_name + '.' + object_property + ' = ' + e.target.selectedItem);*/
						view[object_name][object_property] = e.target.selectedItem;
					}
					else if (display_object is TextInputHelper)
					{
/*						Logger.info('binding responder: ' + display_object + '.text = ' + view[object_name][object_property]);*/
						display_object.text = view[object_name][object_property];
					}
					else if (display_object is ComboBoxHelper)
					{
/*						Logger.info('binding responder: ' + display_object + '.selectedItem = ' + view[object_name][object_property]);*/
						display_object.selectedItem = view[object_name][object_property];
					}
				};
				listener.addEventListener('change', responder);
				this[object_name].addEventListener((object_property + '_change'), responder);
			}
		}

		// return helper_for(TextInputHelper, options, 'text', object_name, property)
		private function helper_for (helper:*, options:Object, assign_property:String, object_name:String, object_property:String) :DisplayObject
		{
			var name:String = (object_name + '_' + object_property);
			options = new Hash({ name: name }).update(options);
			// TODO: replace with databinding
			options[assign_property] = this[object_name][object_property];
			this[name] = helper.create(options);
			bind_property(this[name], object_name, object_property);
			return addChild((this[name] is Helper) ? this[name].display_object : this[name]);
		}


		// >>> EVENT HANDLERS
		private function after_added_to_stage (e:Event) :void
		{
			try
			{
				removeEventListener('addedToStage', after_added_to_stage);
				addEventListener('render', after_render);
/*				Logger.info(this + ' addedToStage pre build');*/
				build();
/*				Logger.info(this + ' addedToStage post build');*/
			}
			catch (exception:*)
			{
/*				Logger.info('RV#build debug: ' + exception);*/
				removeEventListener('addedToStage', after_added_to_stage);
				removeEventListener('render', after_render);
			}
		}

		private function after_render (e:Event) :void
		{
			removeEventListener('render', after_render);
/*			Logger.info(this + ' render');*/

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
					if (this.hasOwnProperty(element)) ((this[element] is Helper) ? this[element].display_object : this[element]).addEventListener(event, controller[method]);
				}
			}
		}
	}
}



/**
*	Private ReactionView subclass for failsafe ONLY!
**/
dynamic class BaseReactionView extends ras3r.ReactionView
{
}