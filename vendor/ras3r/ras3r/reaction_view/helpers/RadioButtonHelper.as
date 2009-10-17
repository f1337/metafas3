package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.display.*;
	import flash.text.*;
	import ras3r.*;
	import ras3r.utils.*;

	dynamic public class RadioButtonHelper extends UIComponentHelper
	{
		static public var default_options:Hash = new Hash;

		static public function create (options:Object = null) :RadioButtonHelper
		{
			return (UIComponentHelper.create(RadioButtonHelper, options) as RadioButtonHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	container for radio_button and text_field
		**/
		public var display_object:Sprite = new Sprite();

		/**
		*	proxy for radio_button.group
		**/
		public function get group () :RadioButtonGroup
		{
			return radio_button.group;
		}

		public function set group (g:RadioButtonGroup) :void
		{
			radio_button.group = g;
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
		*	RadioButton to proxy
		**/
		public var radio_button:RadioButton = new RadioButton();

		/**
		*	TextField for wrapped text, finite layout control
		**/
		public var text_field:TextField = new TextField();

		/**
		*	proxy for display_object.width
		**/
		public function get width () :Number
		{
			return display_object.width;
		}

		public function set width (w:Number) :void
		{
			text_field.width = (w - text_field.x);
		}



		// >>> PUBLIC METHODS
		public function RadioButtonHelper ()
		{
			super(display_object);
			radio_button.label = '';
			text_field.autoSize = 'left';
			text_field.wordWrap = true;
			display_object.addChild(radio_button);
			display_object.addChild(text_field);
			radio_button.addEventListener('render', after_radio_button_render);
		}

		/**
		*	radioButtonHelper.getStyle('textFormat');
		*	returns 'textFormat', 'embedFonts' styles from RadioButtonHelper text_field
		*	all other styles are returned from RadioButton itself
		**/
		public function getStyle (key:String) :Object
		{
			return (key == 'textFormat' ? text_field.defaultTextFormat : radio_button.getStyle(key));
		}

		/**
		*	radioButtonHelper.setStyle('textFormat', textFormat);
		*	applies 'textFormat' and 'embedFonts' styles to both
		*	the RadioButtonHelper's text_field and its radio_button
		*	all other styles are applied only to the RadioButton itself
		**/
		public function setStyle (key:String, value:*) :void
		{
			switch (key)
			{
				case 'textFormat':
					text_field.defaultTextFormat = value;
					text_field.setTextFormat(value);
					break;
				case 'embedFonts':
					text_field.embedFonts = value;
					break;
			}
			radio_button.setStyle(key, value);
		}

		/**
		*	position custom text_field where radio_button's
		*	internal textField is positioned
		**/
		private function after_radio_button_render (e:Object) :void
		{
			text_field.x = radio_button.textField.x;
			text_field.y = radio_button.textField.y;
		}
	}
}