package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.text.*;
	import ras3r.*;
	import ras3r.utils.*;

	dynamic public class TextInputHelper extends ObjectProxy
	{
		static public var default_options:Hash = new Hash;

		static public function create (options:Object = null) :TextInputHelper
		{
			options = default_options.merge(options);
			var text_input:TextInputHelper = new TextInputHelper();

			// set "upSkin" style from "background" option
/*			if (options.background) text_input.setStyle('upSkin', options.remove('background'));*/

			// apply TextFormat from options.format hash
			apply_text_format_to(text_input, options);

			// prevent text=null
			if (options.hasOwnProperty('text')) options.text ||= '';

			// assign TextInput properties from options hash
			options.apply(text_input);

			return text_input;
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

		// >>> PUBLIC PROPERTIES
		// set "upSkin" style from "background" option
		public function set background (skin:Class) :void
		{
			display_object.setStyle('upSkin', skin);
		}

		public var display_object:TextInput = new TextInput();

		public function TextInputHelper ()
		{
			super(display_object);
		}
	}
}
