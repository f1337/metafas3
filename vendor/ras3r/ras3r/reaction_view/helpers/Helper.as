package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.text.*;
	import ras3r.*;
	import ras3r.utils.*;

	dynamic public class Helper extends ObjectProxy
	{
		static public function create (klass:Class, options:Object = null) :Helper
		{
			options = klass.default_options.merge(options);
			var helper:Helper = new klass();

			// is a custom font defined?
			// if so, set default embedFonts = true
			options.embedFonts = Boolean(options.format && options.format.font && options.embedFonts !== false);

			// assign TextInput properties from options hash
			options.apply(helper);

			return helper;
		}

		public function Helper (display_object:Object = null)
		{
			super(display_object);
		}

		public function set embedFonts (flag:Boolean) :void
		{
			this.setStyle('embedFonts', flag);
		}

		public function set format (fmt:Object) :void
		{
			// use Hash object for hash.apply
			fmt = new Hash(fmt);
			// get default text format
			var tf:Object = this.getStyle('textFormat');
			tf ||= new TextFormat();
			// update text format
			fmt.apply(tf);
			// apply new textFormat
			this.setStyle('textFormat', tf);
		}
	}
}
