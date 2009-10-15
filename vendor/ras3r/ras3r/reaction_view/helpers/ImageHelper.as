package ras3r.reaction_view.helpers
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import ras3r.*;
	import ras3r.controls.*;
	import ras3r.utils.*;

	public class ImageHelper extends Helper
	{
		static public var default_options:Hash = new Hash;

		static public function create (options:Object = null) :Image
		{
			options = default_options.merge(options);
			var loader:Image = new Image();

/*			// catch IO errors (throws runtime exception)
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, after_io_error);

			// catch init event for content processing
			loader.contentLoaderInfo.addEventListener('init', after_init);
*/
			// assign properties from options hash
			options.apply(loader);

			return loader;
		}


		// >>> PRIVATE PROPERTIES
		private var _source:URLRequest;


		// >>> PUBLIC PROPERTIES
		/**
		*	returns URLRequest
		**/
		public function get source () :Object
		{
			return (_source as Object);
		}

		/**
		*	applies url_for(source) if source is string
		**/
		public function set source (s:Object) :void
		{
			trace('set source: ' + s.toString());
			_source = (s is URLRequest) ? 
				(s as URLRequest) : ReactionController.url_request_for(s.toString());
			load(_source);
		}


		// >>> PUBLIC METHODS
		/**
		*	applies LoaderContext to allow bitmap smoothing
		**/
		public function load (request:URLRequest, context:LoaderContext = null) :void
		{
			if (! context) context = new LoaderContext(true);
			super.load(request, context);
		}


		// >>> EVENT HANDLERS
		/**
		* 	after_init: attempt to smooth loaded bitmap
		**/
		static private function after_init (e:Event) :void
		{
			try
			{
				var iBitmap:Bitmap = e.target.content as Bitmap;
				iBitmap.smoothing = true;
			}
			catch (e:Object)
			{
				Logger.debug('ImageHelper#after_io_error cannot smooth loaded bitmap: ' + e);
			}
		}

		/**
		* 	after_io_error: log it
		**/
		static private function after_io_error (e:IOErrorEvent) :void
		{
			Logger.info('ImageHelper#after_io_error: ' + e.text);
		}
	}
}