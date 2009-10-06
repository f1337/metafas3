package ras3r.reaction_view.helpers
{
	import flash.text.*;
	import ras3r.*;
	import ras3r.controls.*;

	public class TextFieldHelper
	{
		static public var default_options:Hash = new Hash;
		default_options.update({
			// autosize to end-run the 100x100 base size
			autoSize:	'left',
			// wordWrap forces textField to expand to full given width
			wordWrap:	true
		});

		static public function create (options:Object = null) :TextField
		{
			options = default_options.merge(options);
			var text_field:TextField = new TextField();

			// apply TextFormat via format hash
			if (options.format)
			{
				// use Hash object for hash.apply
				var format:Hash = new Hash(options.remove('format'));
				// is a custom font defined?
				// if so, set default embedFonts = true
/*				options.embedFonts = (format.font && options.embedFonts !== false);*/
				/*
				Advanced anti-aliasing allows font faces to be rendered
				at very high quality at small sizes. It is best used 
				with applications that have a lot of small text. 
				Advanced anti-aliasing is not recommended for very 
				large fonts (larger than 48 points).
				*/ 
/*				options.antiAliasType = (options.embedFonts && format.size <= 48 && options.antiAliasType != 'normal') ? 'advanced' : 'normal';*/

				// get default text format
				var tf:TextFormat = text_field.defaultTextFormat;
				// update text format
				format.apply(tf);
				// apply new text format
				text_field.defaultTextFormat = tf;
				text_field.setTextFormat(tf);
			}

			// assign TextField properties from options hash
			options.apply(text_field);

			return text_field;
		}
	}
}