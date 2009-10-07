package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.text.*;
	import ras3r.*;

	public class TextInputHelper
	{
		static public var default_options:Hash = new Hash;

		static public function create (options:Object = null) :TextInput
		{
			options = default_options.merge(options);
			var text_input:TextInput = new TextInput();

			// set "upSkin" style from "background" option
			if (options.background) text_input.setStyle('upSkin', options.remove('background'));

			// apply TextFormat via format hash
			if (options.format)
			{
				// use Hash object for hash.apply
				var format:Hash = new Hash(options.remove('format'));
				// is a custom font defined?
				// if so, set default embedFonts = true
				options.embedFonts = Boolean(format.font && options.embedFonts !== false);
				/*
				Advanced anti-aliasing allows font faces to be rendered
				at very high quality at small sizes. It is best used 
				with applications that have a lot of small text. 
				Advanced anti-aliasing is not recommended for very 
				large fonts (larger than 48 points).
				*/ 
/*				options.antiAliasType = (options.embedFonts && format.size <= 48 && options.antiAliasType != 'normal') ? 'advanced' : 'normal';*/

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

			// assign TextInput properties from options hash
			options.apply(text_input);

			return text_input;
		}
	}
}
