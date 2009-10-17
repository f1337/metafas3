package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.text.*;
	import ras3r.*;

	dynamic public class ComboBoxHelper extends UIComponentHelper
	{
		/**
		*	ComboBoxHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of ComboBoxHelper
		**/
		static public var default_options:Hash = new Hash;

		/**
		*	ComboBoxHelper.create:
		*		returns a new instance of ComboBoxHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :ComboBoxHelper
		{
			return (UIComponentHelper.create(ComboBoxHelper, options) as ComboBoxHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	comboBoxHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a ComboBox
		**/
		public var display_object:ComboBox = new ComboBox();


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function ComboBoxHelper ()
		{
			super(display_object);
		}

		/**
		*	comboBoxHelper.getStyle('textFormat');
		*	returns 'textFormat', 'embedFonts' styles from ComboBox label textField
		*	all other styles are returned from ComboBox itself
		**/
		public function getStyle (key:String) :Object
		{
			return (key == 'textFormat' ? this.textField : display_object).getStyle(key);
		}

		/**
		*	comboBoxHelper.setStyle('textFormat', textFormat);
		*	applies 'textFormat' and 'embedFonts' styles to both
		*	the ComboBox's label textField and its listItemRenderer
		*	ref: blogs.adobe.com/pdehaan/2008-03/using_embedded_fonts_with_the_3.html
		*	all other styles are applied only to the ComboBox itself
		**/
		public function setStyle (key:String, value:Object) :void
		{
			if (key == 'textFormat' || key == 'embedFonts')
			{
				display_object.textField.setStyle(key, value);
				display_object.dropdown.setRendererStyle(key, value);
			}
			else
			{
				display_object.setStyle(key, value);
			}
		}
	}
}
