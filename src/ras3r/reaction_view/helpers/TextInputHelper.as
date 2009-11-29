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
		*	textInputHelper.invalid = function event listener
		**/
		public function set invalid (listener:Function) :void
		{
			display_object.addEventListener('invalid', listener);
		}

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

		/**
		*	textInputHelper.valid = function event listener
		**/
		public function set valid (listener:Function) :void
		{
			display_object.addEventListener('valid', listener);
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function TextInputHelper ()
		{
			super(display_object);
		}

		/**
		*	Set up data binding
		**/
		public function bind_to (object:*, property:String) :void
		{
			// helper responds to changes to object[property]
			object.addEventListener(property + '_change', after_property_change);

			// helper responds to object[property] validation events
			// use lower priority, so controllers may use stopImmediatePropagation()
			// to prevent background color changes
			object.addEventListener(property + '_invalid', after_property_invalid, false, -1);
			object.addEventListener(property + '_valid', after_property_valid, false, -1);

			// object[property] responds to changes to text_input.text
			display_object.addEventListener('change', function (e:Object) :void
			{
				// prevent superfluous event firing
				if (object[property] == e.target.text) return;
				// update data object
				object[property] = e.target.text;
			});
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

		private function after_property_invalid (e:ValidationResultEvent) :void
		{
			var newEvent:ValidationResultEvent = new ValidationResultEvent('invalid', false, true);
			newEvent.field = e.field;
			newEvent.results = e.results;
			display_object.dispatchEvent(newEvent);

			if (! newEvent.isDefaultPrevented())
			{
				this.opaqueBackground = 0xff0000;
			}
		}

		private function after_property_valid (e:ValidationResultEvent) :void
		{
			var newEvent:ValidationResultEvent = new ValidationResultEvent('valid', false, true);
			newEvent.field = e.field;
			display_object.dispatchEvent(newEvent);

			if (! newEvent.isDefaultPrevented())
			{
				this.opaqueBackground = null;
			}
		}
/*
	    private function textField_textInputHandler(event:TextEvent):void
	    {
	        event.stopImmediatePropagation();

	        // Dispatch a cancelable version of this event.
	        var newEvent:TextEvent =
	            new TextEvent(TextEvent.TEXT_INPUT, false, true);
	        newEvent.text = event.text;
	        dispatchEvent(newEvent);

	        // If any handler has called preventDefault(),
	        // then stop the TextField from accepting the text.
	        if (newEvent.isDefaultPrevented())
	            event.preventDefault();
	    }
*/
	}
}
