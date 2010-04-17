package ras3r.reaction_view.helpers
{
	dynamic public class FormattableHelper extends Helper
	{
		// shared creation callback
		static protected function create_helper_callback (helper:Helper, hoptions:Object) :void
		{
			// apply inline CSS styles
			hoptions.format = new Hash(hoptions.format);
			if (hoptions.color) hoptions.format.color = hoptions.remove('color').replace('#', '0x');
			if (hoptions.fontFamily) hoptions.format.font = hoptions.remove('fontFamily');
			if (hoptions.fontSize) hoptions.format.size = hoptions.remove('fontSize');
			if (hoptions.fontWeight) hoptions.format.bold = (hoptions.remove('fontWeight') == 'bold');
			if (hoptions.leading) hoptions.format.leading = hoptions.remove('leading');
			if (hoptions.letterSpacing) hoptions.format.letterSpacing = hoptions.remove('letterSpacing');
			if (hoptions.marginLeft) hoptions.format.leftMargin = hoptions.remove('marginLeft');
			if (hoptions.marginRight) hoptions.format.rightMargin = hoptions.remove('marginRight');
			if (hoptions.textAlign) hoptions.format.align = hoptions.remove('textAlign');
			if (hoptions.textDecoration) hoptions.format.underline = (hoptions.remove('textDecoration') == 'underline');
			if (hoptions.textIndent) hoptions.format.indent = hoptions.remove('textIndent');

			// is a custom font defined?
			// if so, set default embedFonts = true
			// hoptions.embedFonts = Boolean(hoptions.format && hoptions.format.font && hoptions.embedFonts !== false);

			/**
			*	Advanced anti-aliasing allows font faces to be rendered
			*	at very high quality at small sizes. It is best used
			*	with applications that have a lot of small text.
			*	Advanced anti-aliasing is not recommended for very
			*	large fonts (larger than 48 points).
			**/
			hoptions.antiAliasType = (hoptions.embedFonts && hoptions.format && hoptions.format.size <= 48 && hoptions.antiAliasType != 'normal') ? 'advanced' : 'normal';

			// apply textFormat before assigning any text
			// to prevent text rendering errors:
			if (hoptions.format) helper.format = hoptions.remove('format');
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function FormattableHelper (proxied_object:Object)
		{
			super(proxied_object);
		}
	}
}