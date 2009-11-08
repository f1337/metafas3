package ras3r.reaction_view.helpers
{
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import ras3r.*;

	use namespace flash_proxy;

	dynamic public class TextFieldHelper extends Helper
	{
		static public var default_options:Hash = new Hash({
			// autosize to end-run the 100x100 base size
			autoSize:	'left',
			/**
			* 	NOTE: condenseWhite interferes with
			*		some HTML rendering and multiline text
			*		probably best to EXCLUDE from default_options
			**/
			// condenseWhite: true,
			// prevent selection
			selectable: false,
			// wordWrap forces textField to expand to full given width
			wordWrap:	true
		});

		static public function create (options:Object = null) :TextFieldHelper
		{
			var closure:Function = function (helper:Helper, hoptions:Object) :void
			{
				// per ActionScript 3 Language Reference (TextField#condenseWhite):
				// "Set the condenseWhite property before setting the htmlText property."
				if (hoptions.condenseWhite) helper.condenseWhite = hoptions.remove('condenseWhite');

				// is a custom font defined?
				// if so, set default embedFonts = true
				hoptions.embedFonts = Boolean(hoptions.format && hoptions.format.font && hoptions.embedFonts !== false);

				/*
				Advanced anti-aliasing allows font faces to be rendered
				at very high quality at small sizes. It is best used 
				with applications that have a lot of small text. 
				Advanced anti-aliasing is not recommended for very 
				large fonts (larger than 48 points).
				*/ 
				hoptions.antiAliasType = (hoptions.embedFonts && hoptions.format.size <= 48 && hoptions.antiAliasType != 'normal') ? 'advanced' : 'normal';
			};

			return (Helper.create(TextFieldHelper, options, closure) as TextFieldHelper);
		}


		// >>> PUBLIC PROPERTIES
		private var _autoSize:String = 'none';
		public function get autoSize () :String
		{
			return _autoSize;
		}

		public function set autoSize (s:String) :void
		{
			_autoSize = s;
			setProperty('autoSize', s);
		}

		/**
		*	textFieldHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a TextField
		**/
		public var display_object:* = new TextField;

		/**
		*	textFieldHelper.format = textFormat
		*		applies textFormat to "textFormat" style on display_object
		*		write-only
		**/
		public function set format (fmt:Object) :void
		{
			// use Hash object for hash.apply
			fmt = new Hash(fmt);
			// get default text format
			var tf:TextFormat = this.defaultTextFormat;
			// update text format
			fmt.apply(tf);
			// apply new text format
			this.defaultTextFormat = tf;
			this.setTextFormat(tf);
			reset_text_size();
		}

		/**
		*	prevent textFieldHelper.htmlText from being set to null
		**/
		public function set htmlText (t:String) :void
		{
			set_text_property('htmlText', t);
		}

		public function get htmlText () :String
		{
			return getProperty('htmlText');
		}

		/**
		*	prevent textFieldHelper.text from being set to null
		**/
		public function set text (t:String) :void
		{
			set_text_property('text', t);
		}

		public function get text () :String
		{
			return getProperty('text');
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function TextFieldHelper (proxied_object:Object = null)
		{
			proxied_object ||= display_object;
			super(proxied_object);
		}

		/**
		*	Set up data binding
		**/
		public function bind_to (object:*, property:String) :void
		{
			// helper responds to changes to object[property]
			object.addEventListener(property + '_change', after_property_change);
		}


		// >>> EVENT HANDLERS
		/**
		*	update text
		**/
		private function after_property_change (e:Object) :void
		{
			// prevent superfluous event firing
			if (e.newValue == this.htmlText) return;
			// update display object
			this.htmlText = e.newValue;
		}

		private function reset_text_size () :void
		{
			// if autoSizing, work around scroll bug with this height hack
			if (_autoSize != 'none')
			{
				with (proxied_object)
				{
					autoSize = _autoSize;
					var h:Number = height;
					autoSize = 'none';
					height = h + getTextFormat().leading;
				}
			}
		}

		private function set_text_property (p:String, t:String) :void
		{
			// if autoSizing, work around scroll bug with this height hack
			if (_autoSize != 'none') proxied_object.autoSize = _autoSize;
			t ||= '';
			setProperty(p, t);
			// if autoSizing, work around scroll bug with this height hack
			if (_autoSize != 'none')
			{
				with (proxied_object)
				{
					var h:Number = height;
					autoSize = 'none';
					height = h + getTextFormat().leading;
				}
			}
		}
	}
}