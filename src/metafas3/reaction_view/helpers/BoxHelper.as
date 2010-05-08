package metafas3.reaction_view.helpers
{
	import com.yahoo.astra.fl.containers.*;
	import metafas3.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	use namespace flash_proxy;

	dynamic public class BoxHelper extends LayoutHelper
	{
		static public var default_options:Hash = new Hash;

		static public function create (options:Object = null) :BoxHelper
		{
			// create the helper
			return (LayoutHelper.create(BoxHelper, options) as BoxHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	imageHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is an Image
		**/
		public var display_object:FlowPane = new FlowPane;

		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function BoxHelper ()
		{
			super(display_object);
		}
	}
}