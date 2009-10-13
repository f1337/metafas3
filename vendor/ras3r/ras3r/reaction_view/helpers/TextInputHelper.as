package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.text.*;
	import ras3r.*;
	import ras3r.utils.*;

	dynamic public class TextInputHelper extends Helper
	{
		static public var default_options:Hash = new Hash;

		static public function create (options:Object = null) :TextInputHelper
		{
			return (Helper.create(TextInputHelper, options) as TextInputHelper);
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

		// prevent text=null
		public function get text () :String
		{
			return display_object.text;
		}

		public function set text (t:String) :void
		{
			t ||= '';
			display_object.text = t;
		}


		// >>> PUBLIC METHODS
		public function TextInputHelper ()
		{
			super(display_object);
		}
	}
}
