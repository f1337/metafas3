package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.text.*;
	import ras3r.*;
	import ras3r.reaction_view.helpers.*;

	public class ComboBoxHelper
	{
		static public var default_options:Hash = new Hash;

		// from: blogs.adobe.com/pdehaan/2008-03/using_embedded_fonts_with_the_3.html
		// cb.textField.setStyle('embedFonts', true);
		// cb.textField.setStyle('textFormat', tf);
		// cb.dropdown.setRendererStyle('embedFonts', true);
		// cb.dropdown.setRendererStyle('textFormat', tf);
		static public function create (options:Object = null) :ComboBox
		{
			options = default_options.merge(options);
			var combo_box:ComboBox = new ComboBox();

			// apply TextFormat from options.format hash
			TextInputHelper.apply_text_format_to(combo_box.textField, options);

			// apply same TextFormat to dropdown
			combo_box.dropdown.setRendererStyle('embedFonts', combo_box.textField.getStyle('embedFonts'));
			combo_box.dropdown.setRendererStyle('textFormat', combo_box.textField.getStyle('textFormat'));

			// assign properties from options hash
			options.apply(combo_box);

			return combo_box;
		}
	}
}
