package metafas3.reaction_view.helpers
{
	import fl.containers.*;
	import fl.video.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	import metafas3.*;
	import metafas3.controls.*;

	use namespace flash_proxy;

	dynamic public class VideoHelper extends Helper
	{
		/**
		*	VideoHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of VideoHelper
		**/
		static public var default_options:Hash = new Hash;


		/**
		*	VideoHelper.create:
		*		returns a new instance of VideoHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :VideoHelper
		{
			// catch if required param "source" exists
			if (! options.source) throw new ArgumentError("Expected argument, options.source, is missing from VideoHelper.create(options).");

			return (Helper.create(VideoHelper, options) as VideoHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	VideoHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a FLVPlayback
		*	http://help.adobe.com/en_US/FlashPlatform//reference/actionscript/3/fl/video/FLVPlayback.html?allClasses=1
		**/
		public var display_object:FLVPlayback = new FLVPlayback();

		/**
		*	returns String skin URL
		**/
		public function get skin () :String
		{
			return getProperty('skin');
		}

		/**
		*	applies url_for(skin) if skin is string
		**/
		public function set skin (s:String) :void
		{
			setProperty('skin', SupervisingController.url_for(s.toString()));
		}

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
			if (s is String) s = SupervisingController.url_for(s.toString());
			setProperty('source', s);
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function VideoHelper ()
		{
			super(display_object);

			// catch IO errors (throws runtime exception)
			display_object.addEventListener('ioError', after_io_error);
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
		* 	after_io_error: log it
		**/
		static private function after_io_error (e:IOErrorEvent) :void
		{
			Logger.info('VideoHelper#after_io_error: ' + e.text);
		}
	}
}