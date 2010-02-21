package ras3r
{
	import com.gigya.*;

	import ras3r.*;
	import ras3r.reaction_view.helpers.*;

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

			// for each public controller property and accessor,
			// add property name and current value to assigns hash
			_assigns_from_controller(describeType(controller).variable, _assigns);
			// filter to use accessors declared in controllers.*
			// .accessor returns public accessors up the inheritance chain,
			// .variable only returns public properties from current class
			_assigns_from_controller(describeType(controller).accessor.(@declaredBy.indexOf('controllers::') == 0), _assigns);

			return _assigns;
		}

		private function _assigns_from_controller (properties:XMLList, _assigns:Hash) :void
		{
			var p:String;
            for (var n:String in properties)
			{
				p = properties.@name[n];
				_assigns[p] = controller[p];
			}
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
/*			Logger.info('DEPRECATION NOTICE: ReactionView#build');*/
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
		/**
		*	TODO HELPERS:
		*		* fields_for
		*		* file_field
		*		* form_for?
		*		* password_field
		*		* text_area
		**/
/*
		public function button (options:Object) :Helper
		{
			var o:DisplayObject = (helper_for(ButtonHelper, options, 'label', object_name, property) as DisplayObject);
			return this[object_name + '_' + property];
		}
*/
		public function button (options:Object) :Button
		{
			return (helper(ButtonHelper, (new Hash(options))) as Button);
		}

		public function button_for (object_name:String, property:String, options:Object = null) :Helper
		{
			var o:DisplayObject = (helper_for(ButtonHelper, options, 'label', object_name, property) as DisplayObject);
			return this[object_name + '_' + property];
		}

		protected function check_box (options:Object) :DisplayObject
		{
			return helper(CheckBoxHelper, (new Hash(options)));
		}

		public function check_box_for (object_name:String, property:String, options:Object = null) :CheckBox
		{
			return (helper_for(CheckBoxHelper, options, 'selected', object_name, property) as CheckBox);
		}

		public function combo_box_for (object_name:String, property:String, options:Object = null) :ComboBox
		{
			// hash-ify options
			options = new Hash(options);
			// extract choices from options
			var choices:* = options.remove('choices');
			// default choices: plural property
			if (! choices) choices = this[object_name][Inflector.pluralize(property)];
			// cast choices to DataProvider
			var dataProvider:DataProvider = (choices is DataProvider) ? choices : (new DataProvider(choices));
			// update options with choices
			options.update({ dataProvider: dataProvider });
			return (helper_for(ComboBoxHelper, options, 'selectedItem', object_name, property) as ComboBox);
		}

		protected function hbox (options:Object, ...args) :DisplayObjectContainer
		{
			var box:DisplayObjectContainer = (addChild(BoxHelper.hbox(options, args)) as DisplayObjectContainer);
			if (options.id) this[options.id] = box;
			return box;
		}

		protected function image (options:Object) :DisplayObject
		{
			// catch if required param "source" exists
			if (! options.source) throw new ArgumentError("Expected argument, options.source, is missing from ras3r::ReactionView/image(options).");
			return helper(ImageHelper, (new Hash(options)));
		}

		protected function image_button (options:Object) :DisplayObject
		{
			// inject buttonMode: true into options
			return helper(ImageButtonHelper, (new Hash(options)));
/*			return helper(ImageHelper, (new Hash(options).update({ buttonMode: true })));*/
/*			return helper(ImageHelper, (new Hash(options).update({ buttonMode: true, tabEnabled: true })));*/
		}

		protected function image_button_for (object_name:String, property:String, options:Object = null) :DisplayObject
		{
			// inject buttonMode, tabEnabled into options
			options = new Hash(options).update({ buttonMode: true });
/*			options = new Hash(options).update({ buttonMode: true, tabEnabled: true });*/
			return helper_for(ImageHelper, options, 'source', object_name, property);
		}

		protected function image_for (object_name:String, property:String, options:Object = null) :DisplayObject
		{
			return helper_for(ImageHelper, options, 'source', object_name, property);
		}

/*		protected function label (text:String, options:Object = null) :TextField*/
/*		protected function label (options:Object) :TextField*/
		protected function label (...args) :TextField
		{
			// HACK: pseudo-polymorphic params for XML templates:
			if (args.length < 1) throw new ArgumentError("Argument count mismatch on ras3r::ReactionView/label(). Expected 1, got 0.");
			var text:String = (args[0] is String ? args[0] : '');
			var options:Hash = new Hash(args.length == 2 ? args[1] : args[0]);

			if (text) options.update({ htmlText: text });
			return (helper(TextFieldHelper, options) as TextField);
/*
			var id:String = options.remove('id');
			if (debug) options.opaqueBackground = 0xddffdd;
			var sprite:DisplayObject = TextFieldHelper.create(options).display_object;
			assign_id_for_object(id, sprite);
			return (addChild(sprite) as TextField);
*/
		}

/*		protected function label_for (object_name:String, property:String, html:String, options:Object = null) :TextField*/
/*		protected function label_for (object_name:String, property:String, options:Object) :TextField*/
		protected function label_for (object_name:String, property:String, ...args) :TextField
		{
			// HACK: pseudo-polymorphic params for XML templates:
			if (args.length < 1) throw new ArgumentError("Argument count mismatch on ras3r::ReactionView/label_for(). Expected 3, got " + (args.length + 2) + '.');
			var text:String = (args[0] is String ? args[0] : '');
			var options:Hash = new Hash(args.length == 2 ? args[1] : args[0]);

			if (text) options.update({ htmlText: text });
			if (debug) options.update({ opaqueBackground: 0xddffdd });

			return (helper(TextFieldHelper, options) as TextField);
/*
			var helper:Helper = TextFieldHelper.create(options);
			assign_id_for_object(id: (object_name + '_' + property + '_label'), helper);
			return (addChild(helper.display_object) as TextField);
*/
		}

		protected function radio_button (options:Object) :DisplayObject
		{
			return helper(RadioButtonHelper, (new Hash(options)));
		}

		protected function render (template:String, assigns:Object = null) :DisplayObject
		{
			// inject controller property into assigns hash
			if (controller) assigns = new Hash(assigns).update({ controller: controller });
			// create the view
			return addChild(ReactionView.create(template, assigns));
		}

		public function radio_button_group (options:Object) :DisplayObject
		{
			return helper(RadioButtonGroupHelper, (new Hash(options)));
		}

		public function radio_button_group_for (object_name:String, property:String, options:Object = null) :DisplayObject
		{
			// hash-ify options
			options = new Hash(options);
			// extract choices from options
			var choices:* = options.remove('choices');
			// default choices: plural property
			if (! choices) choices = this[object_name][Inflector.pluralize(property)];
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

		public function tool_tip_for (object_name:String, property:String, options:Object = null) :Helper
		{
			var o:DisplayObject = (helper_for(TooltipHelper, options, 'htmlText', object_name, property) as DisplayObject);
			return this[object_name + '_' + property];
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
			var box:DisplayObjectContainer = (addChild(BoxHelper.vbox(options, args)) as DisplayObjectContainer);
			if (options.id) this[options.id] = box;
			return box;
		}

		public function vrule (options:Object) :DisplayObject
		{
			return (addChild(RuleHelper.create(options).display_object) as DisplayObject);
		}

		// USAGE: wildfire(1234567, { height: 260, width: 340 });
		protected function wildfire (partner_id:int, options:Object = null) :DisplayObject
		{
			options.partner = partner_id;
			return addChild(new Wildfire(options));
		}

		// >>> PRIVATE METHODS
		protected function helper (helper:*, options:Hash) :DisplayObject
		{
			// remove id for later assignment
			var id:String = options.remove('id');
			// invoke the helper factory
			var object:Helper = helper.create(options);
			// assign id, name
			if (id)
			{
				this[id] = object;
				object.name = id;
			}
			// add to display list and return
			return addChild(object.display_object as DisplayObject);
		}

		protected function helper_for (helper:*, options:Object, assign_property:String, object_name:String, object_property:String) :DisplayObject
		{
/*			Logger.info('helper_for: ' + helper + ', this: ' + this);*/
			var name:String = (object_name + '_' + object_property);
			options = new Hash({ name: name }).update(options);
			// TODO: replace with databinding
			if (this[object_name][object_property] !== null) options[assign_property] = this[object_name][object_property];
			this[name] = helper.create(options);
			if (this[name].hasOwnProperty('bind_to'))
			{
				this[name].bind_to(this[object_name], object_property);
			}
			return addChild(this[name].display_object);
		}
/*
		private function new_helper_for (helper:*, object_name:String, object_property:String, options:Object) :DisplayObject
		{
			var name:String = (object_name + '_' + object_property);
			options = new Hash({ name: name }).update(options);

			this[name] = helper.create(options);
			this[name].bind_to(this[object_name], object_property);

			return addChild(this[name].display_object);
		}
*/

		// >>> EVENT HANDLERS
		protected function after_added_to_stage (e:Event) :void
		{
/*			try
			{
*/				removeEventListener('addedToStage', after_added_to_stage);
				addEventListener('render', after_render);
/*				Logger.info(this + ' addedToStage pre build');*/
				build();
/*				Logger.info(this + ' addedToStage post build');*/
/*			}
			catch (exception:*)
			{
*//*				Logger.info('RV#build debug: ' + exception);
				removeEventListener('addedToStage', after_added_to_stage);
				removeEventListener('render', after_render);
			}
*/		}

		private function after_render (e:Event) :void
		{
			removeEventListener('render', after_render);
			// mixin on_instance_event methods
			mixin_members(describeType(controller).method.(@name.indexOf('on_') == 0));
			// mixin on_instance_event properties
			mixin_members(describeType(controller).variable.(@name.indexOf('on_') == 0));
		}

		private function mixin_members (methods:XMLList) :void
		{
			// for each public controller method named "on_some_element_event",
			// add event listener some_element
			var element:String;
			var event:String;
			var parts:Array;

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
/*					logger.info('mixin_members: ' + method + ', ' + this + '.hasOwnProperty(' + element + '): ' + this.hasOwnProperty(element));*/
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