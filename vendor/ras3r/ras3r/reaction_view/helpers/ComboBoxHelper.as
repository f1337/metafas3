package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.text.*;
	import ras3r.*;
	import ras3r.reaction_view.helpers.*;

	dynamic public class ComboBoxHelper extends Helper
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
			var combo_box:ComboBoxHelper = (Helper.create(ComboBoxHelper, options) as ComboBoxHelper);

/*			options = default_options.merge(options);
			var combo_box:ComboBox = new ComboBox();
*/
			// apply TextFormat from options.format hash
			// from: blogs.adobe.com/pdehaan/2008-03/using_embedded_fonts_with_the_3.html
/*			apply_text_format_to(combo_box.textField, options);*/

			// assign properties from options hash
/*			options.apply(combo_box);*/

			// apply same TextFormat to dropdown
			// from: blogs.adobe.com/pdehaan/2008-03/using_embedded_fonts_with_the_3.html
			combo_box.dropdown.setRendererStyle('embedFonts', combo_box.textField.getStyle('embedFonts'));
			combo_box.dropdown.setRendererStyle('textFormat', combo_box.textField.getStyle('textFormat'));

			return combo_box;
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
		*	returns 'textFormat' style from ComboBox label textField
		*	all other styles are returned from ComboBox itself
		**/
		public function getStyle (key:String) :Object
		{
			return (key == 'textFormat' ? this.textField : display_object).getStyle(key);
		}

		/**
		*	comboBoxHelper.setStyle('textFormat', textFormat);
		*	applies 'textFormat' style to ComboBox label textField
		*	ref: blogs.adobe.com/pdehaan/2008-03/using_embedded_fonts_with_the_3.html
		*	all other styles are applied to ComboBox itself
		**/
		public function setStyle (key:String, value:Object) :void
		{
			(key == 'textFormat' ? this.textField : display_object).setStyle(key, value);
		}

		static public function apply_text_format_to (text_input:*, options:Object) :void
		{
			if (options.format)
			{
				// use Hash object for hash.apply
				var format:Hash = new Hash(options.remove('format'));
				// is a custom font defined?
				// if so, set default embedFonts = true
				options.embedFonts = Boolean(format.font && options.embedFonts !== false);
				// get default text format
				var tf:Object = text_input.getStyle('textFormat');
				tf ||= new TextFormat();
				// update text format
				format.apply(tf);
				// apply new textFormat, embedFonts styles
				text_input.setStyle('embedFonts', options.remove('embedFonts'));
				text_input.setStyle('textFormat', tf);
			}
			else
			{
				text_input.setStyle('embedFonts', false);
			}
		}

	}
}
