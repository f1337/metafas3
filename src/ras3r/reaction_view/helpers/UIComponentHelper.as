package ras3r.reaction_view.helpers
{
	import flash.text.*;
	import ras3r.*;

	dynamic public class UIComponentHelper extends Helper
	{
		// >>> STATIC METHODS
		/**
		*	UIComponentHelper.create:
		*		returns a new instance of UIComponentHelper klass,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static protected function create (klass:Class, options:Object = null) :UIComponentHelper
		{
			var closure:Function = function (helper:Helper, hoptions:Object) :void
			{
				// is a custom font defined?
				// if so, set default embedFonts = true
				hoptions.embedFonts = Boolean(hoptions.format && hoptions.format.font && hoptions.embedFonts !== false);
			}

			return (Helper.create(klass, options, closure) as UIComponentHelper);
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
		public function UIComponentHelper (display_object:Object = null)
		{
			super(display_object);
		}
	}
}
