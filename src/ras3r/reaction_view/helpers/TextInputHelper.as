package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.text.*;
	import flash.utils.*;
	import mx.events.*;
	import ras3r.*;

	use namespace flash_proxy;

	dynamic public class TextInputHelper extends UIComponentHelper
	{
		/**
		*	TextInputHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of TextInputHelper
		**/
		static public var default_options:Hash = new Hash;

		/**
		*	TextInputHelper.create:
		*		returns a new instance of TextInputHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :TextInputHelper
		{
			return (UIComponentHelper.create(TextInputHelper, options) as TextInputHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	textInputHelper.background: applied to "upSkin" style of TextInput
		**/
		public function set background (skin:Class) :void
		{
			this.setStyle('upSkin', skin);
		}

		/**
		*	textInputHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a TextInput
		**/
		public var display_object:TextInput = new TextInput();

		/**
		*	textInputHelper.padding: applied to "textPadding" style of TextInput
		**/
		public function set padding (padding:Number) :void
		{
			this.setStyle('textPadding', padding);
		}

		/**
		*	prevent textInputHelper.text from being set to null
		**/
		public function set text (t:String) :void
		{
			t ||= '';
			setProperty('text', t);
		}

		public function get text () :String
		{
			return getProperty('text');
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a TextInput.
		**/
		public function TextInputHelper ()
		{
			super(display_object);
		}

		/**
		*	Set up data binding
		**/
		override public function bind_to (object:*, property:String) :void
		{
			// helper responds to changes to object[property]
			object.addEventListener(property + '_change', after_property_change);

			// object[property] responds to changes to text_input.text
			display_object.addEventListener('change', function (e:Object) :void
			{
				// prevent superfluous event firing
				if (object[property] == e.target.text) return;
				// update data object
				object[property] = e.target.text;
			});

			// setup validation handlers
			super.bind_to(object, property);
		}


		// >>> EVENT HANDLERS
		/**
		*	update textinput.text
		**/
		private function after_property_change (e:PropertyChangeEvent) :void
		{
			// prevent superfluous event firing
			if (e.newValue == this.text) return;
			// update display object
			this.text = e.newValue.toString();
		}
	}
}
