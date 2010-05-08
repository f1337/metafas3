package metafas3.reaction_view.helpers
{
	import fl.controls.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import metafas3.*;
	import metafas3.controls.*;

	use namespace flash_proxy;

	dynamic public class ImageButtonHelper extends UIComponentHelper
	{
		/**
		*	ImageButtonHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of ButtonHelper
		**/
		static public var default_options:Hash = new Hash({
			label: '',
            useHandCursor: true
        });

		/**
		*	ImageButtonHelper.create:
		*		returns a new instance of ButtonHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :ImageButtonHelper
		{
			return (UIComponentHelper.create(ImageButtonHelper, options) as ImageButtonHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	imageButtonHelper.click = String
		*	URL to fetch on "click" event
		*	TODO: extend to accept controller/view syntax ("products/show")
		*	write-only
		**/
		public function set click (url:String) :void
		{
			display_object.addEventListener('click', function (e:Event) :void
			{
				SupervisingController.redirect_to_url(url);
			});
		}

		/**
		*	imageButtonHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is an ImageButton
		**/
		public var display_object:ImageButton = new ImageButton();

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
		public function ImageButtonHelper ()
		{
			super(display_object);
		}
	}
}