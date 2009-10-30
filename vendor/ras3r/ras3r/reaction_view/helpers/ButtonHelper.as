package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import ras3r.*;

	use namespace flash_proxy;

	dynamic public class ButtonHelper extends UIComponentHelper
	{
		/**
		*	ButtonHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of ButtonHelper
		**/
		static public var default_options:Hash = new Hash({
            useHandCursor: true
        });

		/**
		*	ButtonHelper.create:
		*		returns a new instance of ButtonHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :ButtonHelper
		{
			return (UIComponentHelper.create(ButtonHelper, options) as ButtonHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	Button to proxy
		**/
		public var button:Button = new Button();

		/**
		*	buttonHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a Sprite container for button and text_field
		**/
		public var display_object:Sprite = new Sprite();

		/**
		*	proxy for button.height
		**/
		public function get height () :Number
		{
			return button.height;
		}

		public function set height (h:Number) :void
		{
			button.height = h;
		}

		/**
		*	proxy for text_field.label
		**/
		public function get label () :String
		{
			return text_field.text;
		}

		public function set label (val:String) :void
		{
			text_field.text = val;
		}

		/**
		*	buttonHelper.up: applied to "upSkin" style of Button
		**/
		public function set skin (skin:Object) :void
		{
            var accessors:XMLList = describeType(skin).accessor.(@name != 'prototype');
            for each (var a:XML in accessors)
            {
                this.setStyle(a.@name, skin[a.@name]);
            }
		}

		/**
		*	TextField for aligning and formatting text, finite layout control
		**/
		public var text_field:TextField = new TextField();

		/**
		*	proxy for button.width
		**/
		public function get width () :Number
		{
			return button.width;
		}

		public function set width (w:Number) :void
		{
			button.width = w;
			text_field.width = w;
		}

		/**
		*	proxy for display_object.x
		**/
		public function get x () :Number
		{
			return display_object.y;
		}

		public function set x (_x:Number) :void
		{
			display_object.x = _x;
		}

		/**
		*	proxy for display_object.y
		**/
		public function get y () :Number
		{
			return display_object.y;
		}

		public function set y (_y:Number) :void
		{
			display_object.y = _y;
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function ButtonHelper ()
		{
			super(button);

			button.label = '';
			display_object.addChild(button);

			text_field.autoSize = 'left';
			// prevent textfield from interfering with mouse events:
			text_field.mouseEnabled = false;
			text_field.mouseWheelEnabled = false;
			text_field.selectable = false;
			text_field.wordWrap = true;
			text_field.addEventListener('render', after_text_field_render);
			display_object.addChild(text_field);
		}

		/**
		*	buttonHelper.getStyle('textFormat');
		*	returns 'textFormat', 'embedFonts' styles from ButtonHelper text_field
		*	all other styles are returned from Button itself
		**/
		public function getStyle (key:String) :Object
		{
			return (key == 'textFormat' ? text_field.defaultTextFormat : button.getStyle(key));
		}

		/**
		*	buttonHelper.setStyle('textFormat', textFormat);
		*	applies 'textFormat' and 'embedFonts' styles to both
		*	the ButtonHelper's text_field and its button
		*	all other styles are applied only to the Button itself
		**/
		public function setStyle (key:String, value:*) :void
		{
			switch (key)
			{
				case 'embedFonts':
					text_field.embedFonts = value;
					break;
/*				case 'icon':
					text_field.embedFonts = value;
					break;
*/				case 'textFormat':
					text_field.defaultTextFormat = value;
					text_field.setTextFormat(value);
					break;
			}
			button.setStyle(key, value);
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
			if (e.newValue == this.label) return;
			// update display object
			this.label = e.newValue;
		}

		/**
		*	position custom text_field when text_field's size changes
		**/
		private function after_text_field_render (e:Object) :void
		{
			text_field.y = Math.min((height - text_field.textHeight) / 2);
		}
	}
}