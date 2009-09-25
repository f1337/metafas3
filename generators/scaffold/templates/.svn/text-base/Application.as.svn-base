package
{
	import com.ustrive2.controllers.*;
	import com.ustrive2.utils.*;

	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	import controllers.*;

	public class Application extends Sprite
	{
		// >>> STATIC METHODS
		static public function controller (name:String) :*
		{
			var className:String = 'controllers.' + Inflector.camelize(name) + 'Controller';
			var klass:Class = getDefinitionByName(className) as Class;
			var c:ReactionController = new klass();
			instance.addChild(c);
			return c;
		}

		static public function redirect_to (options:Object) :void
		{
			instance.redirect_to(options);
		}


		// >>> STATIC PROPERTIES
		static public function get instance () :Application
		{
			if (_instance == null) _instance = new Application();
			return _instance;
		}

		static private var _instance:Application;


		// >>> PRIVATE PROPERTIES
		private var <%= class_name.downcase %>Controller:<%= class_name %>Controller;


		// >>> PUBLIC METHODS
		public function Application ()
		{
			// singleton pattern:
			if (_instance == null)
			{
				// super constructor
				super();

				_instance = this;

				// setup FullScreen listener onAddToStage
				addEventListener(Event.ADDED_TO_STAGE, _added_to_stage);
			}
			else
			{
				throw new Error('Application follow singleton pattern. new() may only be invoked once.');
			}
		}

		public function redirect_to (options:Object) :void
		{
			// lookup controller: all controllers used as singletons
			var c:* = controller(options.controller);
			var action:String = options.action;
			delete options.controller;
			delete options.action;
			c[action](options);
		}


		// >>> PRIVATE METHODS
		// >>> EVENT HANDLERS
		private function _added_to_stage (e:Event) :void
		{
			// stop listening
			removeEventListener(Event.ADDED_TO_STAGE, _added_to_stage);

			// assign Stage scaleMode, align BEFORE attempting to do any visual rendering
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			// setup fullscreen listener ONCE
			if (! stage.hasEventListener(FullScreenEvent.FULL_SCREEN))
			{
				stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			}

			// HACK! ROUTES NEEDED?
			redirect_to({ controller: '<%= class_name.downcase %>', action: 'list' });
		}

		private function onFullScreen (event:FullScreenEvent) :void
		{
			trace('onFullScreen: ' + event);
		}
	}
}
