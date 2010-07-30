package metafas3
{
	import com.gigya.*;

	import metafas3.*;
	import metafas3.reaction_view.helpers.*;

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
		// >>> BASE VIEW CLASSES
		private static var xhtmlView:XHTMLView;


		// >>> STATIC PROPERTIES
		public static var debug:Boolean = false;


		// >>> STATIC METHODS
		// USAGE: 	ReactionView.create('layouts/application', { header: 'my name' });
		//			ReactionView.create('products/show', { title: 'Cheeseburger' });
		// Instantiates DisplayObject/View described by @template, and 
		// copies properties from assigns hash to new DisplayObject/View
		static public function create (template:* = '', assigns:Object = null) :DisplayObject
		{
			// instantiate view class from template name
			var view:* = template_view(template);

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

		// template_view('layouts/application') => views.layouts.ApplicationLayout
		// template_view('rockets/show') => views.rockets.ShowRocket
		// template_view('rockets/list') => views.rockets.ListRockets
		// instantiate view class from template name
		// returns an instance of ReactionView
		static private function template_view (template:String) :*
		{
			var klass:Class;

			if (template)
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

				// lookup class definition from template name
				try
				{
					klass = (getDefinitionByName(className) as Class);
				}
				// fallback to XHTMLView
				catch (exception:*)
				{
					var view:* = (new XHTMLView());
					view.path = ((template.indexOf('http') == 0) ? template : SupervisingController.view_path + template);
					return view;
				}
			}
			// default to BaseReactionView if template empty
			else
			{
				klass = BaseReactionView;
			}

			return (new klass());
		}


		// >>> PROTECTED PROPERTIES
		private var controller:SupervisingController;


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
		protected function render (template:String, assigns:Object = null) :DisplayObject
		{
			// inject controller property into assigns hash
			if (controller) assigns = new Hash(assigns).update({ controller: controller });
			// create the view
			return addChild(ReactionView.create(template, assigns));
		}

		protected function url_for (absolute_path:String, subdomain:String = null) :String
		{
			return SupervisingController.url_for(absolute_path, subdomain);
		}

		protected function url_request_for (absolute_path:String, subdomain:String = null) :URLRequest
		{
			return SupervisingController.url_request_for(absolute_path, subdomain);
		}


		// >>> EVENT HANDLERS
		protected function after_added_to_stage (e:Event) :void
		{
			removeEventListener('addedToStage', after_added_to_stage);
			addEventListener('render', after_render);
			build();
		}

		private function after_render (e:Event) :void
		{
			removeEventListener('render', after_render);
			// mixin on_instance_event methods
			controller.map_event_listeners(this);
		}


		// >>> PRIVATE METHODS
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
	}
}


/**
*	Private ReactionView subclass for failsafe ONLY!
**/
dynamic class BaseReactionView extends metafas3.ReactionView
{
}