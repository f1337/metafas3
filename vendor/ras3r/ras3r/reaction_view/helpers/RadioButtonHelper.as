package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.text.*;
	import ras3r.*;
	import ras3r.utils.*;

	dynamic public class RadioButtonHelper extends Helper
	{
		static public var default_options:Hash = new Hash;

		static public function create (options:Object = null) :RadioButtonHelper
		{
			return (Helper.create(RadioButtonHelper, options) as RadioButtonHelper);
		}


		// >>> PUBLIC PROPERTIES
		public var display_object:RadioButton = new RadioButton();


		// >>> PUBLIC METHODS
		public function RadioButtonHelper ()
		{
			super(display_object);
		}
	}
}
