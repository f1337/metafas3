package ras3r.reaction_view.helpers
{
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import ras3r.*;

	use namespace flash_proxy;

	dynamic public class TextFieldHelper extends FormattableHelper
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
			// multiline: true for HTML5 support!
			multiline: true,
			// prevent selection
			selectable: false,
			// wordWrap forces textField to expand to full given width
			// also true for HTML5 support!
			wordWrap:	true
		});

		static public function create (options:Object = null) :TextFieldHelper
		{
			return (Helper.create(TextFieldHelper, options, create_helper_callback) as TextFieldHelper);
		}

		static public function create_helper_callback (helper:Helper, hoptions:Object) :void
		{
			// per ActionScript 3 Language Reference (TextField#condenseWhite):
			// "Set the condenseWhite property before setting the htmlText property."
			if (hoptions.condenseWhite) helper.condenseWhite = hoptions.remove('condenseWhite');

			// per fantasticmf:
			// Set the multiline property before setting the htmlText property,
			// if you want <li>s to render
			if (hoptions.multiline) helper.multiline = hoptions.remove('multiline');

			// invoke FormattableHelper's callback
			FormattableHelper.create_helper_callback(helper, hoptions);

			// HACKTASTIC HACK! stylesheet hack!
			// these styles are hard-coded until they can be
			// REMOVED in favor of runtime CSS in <style> tags
			var style:StyleSheet = new StyleSheet();
			style.setStyle('a:link', {
				textDecoration: 'none'
			});
			style.setStyle('a:hover', {
				textDecoration: 'underline'
			});
			style.setStyle('a:active', {
				textDecoration: 'underline'
			});

			// this may need to become template-specific
			// in which case, inline styles won't be enough!
			style.setStyle('li', {
				marginLeft: -18
			});
			hoptions.styleSheet = style;


			// another bugfixing attempt: strange bugs sizing!
			if (hoptions.autoSize) helper.autoSize = hoptions.remove('autoSize');
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
			//after_textfield_render({});
		}

		/**
		*	textFieldHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a TextField
		**/
/*		public var display_object:* = new TextField;*/
		public var display_object:Sprite = new Sprite();
		public var text_field:TextField = new TextField();

		/**
		*	proxy for display_object.filters
		**/
		public function get filters () :Array
		{
			return display_object.filters;
		}

		public function set filters (f:Array) :void
		{
			display_object.filters = f;
		}

		/**
		*	textFieldHelper.format = textFormat
		*		applies textFormat to "textFormat" style on display_object
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
		}

		/**
		*	textFieldHelper.format => defaultTextFormat
		*		returns display_object.defaultTextFormat
		**/
		public function get format () :Object
		{
			return this.defaultTextFormat;
		}

		/**
		*	proxy for display_object.height
		**/
        private var _height:Number;
		public function get height () :Number
		{
			return (_height ? _height : text_field.height);
		}

		public function set height (val:Number) :void
		{
            _height = val;
			text_field.height = (text_field.y - val);
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
		*	provides CSS-style padding support
		**/
		public function set padding (n:Number) :void
		{
			paddingLeft = n;
			paddingTop = n;
		}

		public function set paddingLeft (n:Number) :void
		{
			text_field.x = n;
			text_field.width = (width - n);
		}

		public function set paddingTop (n:Number) :void
		{
			text_field.y = n;
			text_field.height = (height - n);
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

		/**
		*	proxy for display_object.visible
		**/
		public function get visible () :Boolean
		{
			return display_object.visible;
		}

		public function set visible (val:Boolean) :void
		{
			display_object.visible = val;
		}

		private var _width:Number;
		public function get width () :Number
		{
			return (_width ? _width : text_field.width);
		}

		public function set width (val:Number) :void
		{
			_width = val;
			text_field.width = (text_field.x - val);
		}

		/**
		*	proxy for display_object.x
		**/
		public function get x () :Number
		{
			return display_object.x;
		}

		public function set x (val:Number) :void
		{
			display_object.x = val;
		}

		/**
		*	proxy for display_object.y
		**/
		public function get y () :Number
		{
			return display_object.y;
		}

		public function set y (val:Number) :void
		{
			display_object.y = val;
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function TextFieldHelper (proxied_object:Object = null)
		{
			proxied_object ||= text_field;
			super(proxied_object);
			proxied_object.addEventListener('render', after_textfield_render);
			display_object.addChild(text_field);
		}

		/**
		*	Set up data binding
		**/
		public function bind_to (object:*, property:String) :void
		{
			// helper responds to changes to object[property]
			object.addEventListener(property + '_change', after_property_change);
		}


		// >>> PROTECTED METHODS
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

		protected function after_textfield_render (e:Object) :void
		{
			// if autoSizing, work around scroll bug with this height hack
			if (_autoSize != 'none')
			{
				proxied_object.autoSize = _autoSize;
				with (proxied_object)
				{
					autoSize = _autoSize;
					var h:Number = height;
					autoSize = 'none';
					height = h + getTextFormat().leading + 4;
				}
			}

            // force the width in case autoSize broke it:
            if (proxied_object.width != _width)
            {
                proxied_object.width = _width;
            }
		}

		private function set_text_property (p:String, t:String) :void
		{
			t ||= '';
			setProperty(p, t);
		}
	}
}