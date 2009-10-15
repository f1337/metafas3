package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.text.*;
	import ras3r.*;
	import ras3r.utils.*;

	dynamic public class Helper extends ObjectProxy
	{
		// >>> STATIC METHODS
		/**
		*	Helper.create:
		*		returns a new instance of Helper klass,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static protected function create (klass:Class, options:Object = null) :Helper
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


		// >>> PUBLIC PROPERTIES
		/**
		*	helper.embedFonts = true
		*		applies value to "embedFonts" style on display_object
		*		write-only
		**/
		public function set embedFonts (flag:Boolean) :void
		{
			this.setStyle('embedFonts', flag);
		}

		/**
		*	helper.format = textFormat
		*		applies textFormat to "textFormat" style on display_object
		*		write-only
		**/
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


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function Helper (display_object:Object = null)
		{
			super(display_object);
		}
	}
}
