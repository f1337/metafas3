package ras3r
{
	import ras3r.*;

	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.system.*;

	public class Application extends Sprite
	{
		// >>> STATIC PROPERTIES
		static public var application:Application;

		// >>> CONTROLLERS (compiler hacks)
		// >>> LAYOUTS (compiler hacks)


		// >>> PUBLIC PROPERTIES
		public function get parameters () :Object
		{
			var p:Object = {};
			try
			{
				p = LoaderInfo(this.root.loaderInfo).parameters;
			}
			catch (e:Object)
			{
				Logger.debug('Application#parameters error: ' + e);
			}
			finally
			{
				return new Hash(p);
			}
		}

		public function get url () :String
		{
			var url:String;
			try
			{
				url = LoaderInfo(this.root.loaderInfo).url;
			}
			catch (e:Object)
			{
				Logger.debug('Application#url error: ' + e);
			}
			finally
			{
				return url;
			}
		}


		// >>> PUBLIC METHODS
		public function Application ()
		{
			// super constructor
			super();

			application ||= this;

			// customize context menu
/*			new_context_menu_item('About This App', et_phone_home);*/

			// setup FullScreen listener onAddToStage
			addEventListener(Event.ADDED_TO_STAGE, after_added_to_stage);
		}


		// >>> EVENT HANDLERS
		private function after_added_to_stage (e:Event) :void
		{
			try
			{
				// remove listeners
				removeEventListener(Event.ADDED_TO_STAGE, after_added_to_stage);
				stage.removeEventListener(Event.RESIZE, after_added_to_stage);

				// HACK: Flash content that renders below the fold on Firefox 3 (Mac)
				// 		renders with a stage size of 0. If stageHeight or stageWidth
				//		is less than zero, delay rendering until resize event is received
				if (! (stage.stageHeight > 0 && stage.stageWidth > 0))
				{
					stage.addEventListener(Event.RESIZE, after_added_to_stage);
					return;
				}

				// assign Stage scaleMode, align BEFORE attempting to do any visual rendering
				// TODO: move to base framework!!
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;				
			}
			catch (e:Error)
			{
				// we don't own the stage, do nothing
			}

			ReactionController.container = this;

			// load environment config
			Environment.load(url);

			var params:Hash = parameters.merge({ controller: 'application', action: 'load' });

			// HACK! ROUTES NEEDED?
			ReactionController.redirect_to(params);
		}
	}
}