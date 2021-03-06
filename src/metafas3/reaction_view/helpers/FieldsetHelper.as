package metafas3.reaction_view.helpers
{
	import com.yahoo.astra.fl.containers.*;
	import metafas3.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	use namespace flash_proxy;

	dynamic public class FieldsetHelper extends LayoutHelper
	{
		static public var default_options:Hash = new Hash;

		static public function create (options:Object = null) :FieldsetHelper
		{
			// create the helper
			return (LayoutHelper.create(FieldsetHelper, options) as FieldsetHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	fieldsetHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a BoxPane
		**/
		public var display_object:BoxPane = new BoxPane;

		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function FieldsetHelper ()
		{
			super(display_object);
		}
	}
}