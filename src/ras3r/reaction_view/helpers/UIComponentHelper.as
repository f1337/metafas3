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
			return (Helper.create(klass, options, create_helper_callback) as UIComponentHelper);
		}

		static private function create_helper_callback (helper:Helper, hoptions:Object) :void
		{
			// is a custom font defined?
			// if so, set default embedFonts = true
			hoptions.embedFonts = Boolean(hoptions.format && hoptions.format.font && hoptions.embedFonts !== false);

			/**
			*	Advanced anti-aliasing allows font faces to be rendered
			*	at very high quality at small sizes. It is best used
			*	with applications that have a lot of small text.
			*	Advanced anti-aliasing is not recommended for very
			*	large fonts (larger than 48 points).
			**/
			hoptions.antiAliasType = (hoptions.embedFonts && hoptions.format.size <= 48 && hoptions.antiAliasType != 'normal') ? 'advanced' : 'normal';

			// apply textFormat before assigning any text
			// to prevent text rendering errors:
			if (hoptions.format) helper.format = hoptions.remove('format');
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	helper.antiAliasType = 'advanced' or 'normal'
		*		applies value to display_object's textField (if present)
		*		write-only
		**/
		public function set antiAliasType (type:String) :void
		{
			if (hasOwnProperty('textField'))
			{
				try
				{
					this.textField.antiAliasType = type;
				}
				// TextInput chokes when antiAliasType is set
				catch (exception:Object)
				{
					// do nothing
				}
			}
		}

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
