package ras3r.controls
{
	import ras3r.*;
	import ras3r.utils.*;

	import fl.containers.UILoader;
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class Image extends UILoader
	{
		// >>> PUBLIC PROPERTIES
		override public function set source (s:Object) :void
		{
			Logger.info('Image#source: ' + s);
			if (s is String) s = ReactionController.asset_host + '/' + s.toString();
			super.source = s;
		}

		// >>> PUBLIC METHODS
		public function Image ()
		{
			super();

			maintainAspectRatio = false;

			// catch IO errors (throws runtime exception)
			addEventListener(IOErrorEvent.IO_ERROR, after_load_error);
		}

		override public function load (request:URLRequest = null, context:LoaderContext = null) :void
		{
			if (request && (! context))
			{
				context = new LoaderContext(true);
			}

			super.load(request, context);

			// HACK: to allow re-using Image#load
			// if this isn't set here, UILoader#drawLayout() will throw an error
			// b/c UILoader#load set contentInited=true if a DisplayObject exists!
			contentInited = false;
		}


		// >>> PROTECTED METHODS
		override protected function handleInit (event:Event) :void
		{
			try
			{
				var iBitmap:Bitmap = loader.content as Bitmap;
				iBitmap.smoothing = true;
			}
			catch (e:Object)
			{
				Logger.debug('Image cannot manipulate loaded bitmap: ' + e);
			}

			super.handleInit(event);
		}


		// >>> EVENT HANDLERS
		private function after_load_error (e:IOErrorEvent) :void
		{
			Logger.info('error loading Image: ' + e.text);
		}
	}
}