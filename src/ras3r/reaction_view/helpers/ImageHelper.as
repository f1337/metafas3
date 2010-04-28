package ras3r.reaction_view.helpers
{
	import fl.containers.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	import ras3r.*;
	import ras3r.controls.*;

	use namespace flash_proxy;

	dynamic public class ImageHelper extends Helper
	{
		/**
		*	ImageHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of ImageHelper
		**/
		static public var default_options:Hash = new Hash;


		/**
		*	ImageHelper.create:
		*		returns a new instance of ImageHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :ImageHelper
		{
			// catch if required param "source" exists
			if (! options.source) throw new ArgumentError("Expected argument, options.source, is missing from ImageHelper.create(options).");

			return (Helper.create(ImageHelper, options) as ImageHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	imageHelper.click = String
		*	URL to fetch on "click" event
		*	TODO: extend to accept controller/view syntax ("products/show")
		*	write-only
		**/
		public function set click (url:String) :void
		{
			display_object.addEventListener('click', function (e:Event) :void
			{
				ReactionController.redirect_to_url(url);
			});
		}

		/**
		*	imageHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is an Image
		**/
		public var display_object:UILoader = new ReUILoader();

		/**
		*	returns URLRequest
		**/
		public function get source () :Object
		{
			return getProperty('source');
		}

		/**
		*	applies url_for(source) if source is string
		**/
		public function set source (s:Object) :void
		{
			if (s is String) s = ReactionController.url_for(s.toString());
			setProperty('source', s);
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function ImageHelper ()
		{
			super(display_object);

			// catch IO errors (throws runtime exception)
			display_object.addEventListener('ioError', after_io_error);

			// smooth bitmap after init
			display_object.addEventListener('init', after_init);
		}

		/**
		*	Set up data binding
		**/
		public function bind_to (object:*, property:String) :void
		{
			// helper responds to changes to object[property]
			object.addEventListener(property + '_change', after_property_change);
		}


		// >>> EVENT HANDLERS
		/**
		*	update image source
		**/
		private function after_property_change (e:Object) :void
		{
			// prevent superfluous event firing
			if (e.newValue == this.source) return;
			// update display object
			this.source = e.newValue;
		}

		/**
		* 	after_init: attempt to smooth loaded bitmap
		**/
		static private function after_init (e:Event) :void
		{
			try
			{
				var iBitmap:Bitmap = e.target.content as Bitmap;
				if (iBitmap) iBitmap.smoothing = true;
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