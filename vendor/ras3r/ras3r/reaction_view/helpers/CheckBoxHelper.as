package ras3r.reaction_view.helpers
{
	import ras3r.*;
	import fl.controls.*;

	public class CheckBoxHelper extends UIComponentHelper
	{
		/**
		*	CheckBoxHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of CheckBoxHelper
		**/
		static public var default_options:Hash = new Hash;

		/**
		*	CheckBoxHelper.create:
		*		returns a new instance of CheckBoxHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :CheckBoxHelper
		{
			return (UIComponentHelper.create(CheckBoxHelper, options) as CheckBoxHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	checkBoxHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a CheckBox
		**/
		public var display_object:CheckBox = new CheckBox();


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function CheckBoxHelper ()
		{
			super(display_object);
		}
	}
}
