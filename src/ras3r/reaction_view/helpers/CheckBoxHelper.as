package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.utils.*;
	import mx.events.PropertyChangeEvent;
	import ras3r.*;

	use namespace flash_proxy;

	public class CheckBoxHelper extends UIComponentHelper
	{
		/**
		*	CheckBoxHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of CheckBoxHelper
		**/
		static public var default_options:Hash = new Hash;

		/**
		*	CheckBoxHelper.create:
		*		returns a new instance of CheckBoxHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :CheckBoxHelper
		{
			return (UIComponentHelper.create(CheckBoxHelper, options) as CheckBoxHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	checkBoxHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a CheckBox
		**/
		public var display_object:CheckBox = new CheckBox();

		/**
		*	proxy for display_object.width
		**/
		public function get width () :Number
		{
			return getProperty('width');
		}

		public function set width (w:Number) :void
		{
			setProperty('width', w);
			display_object.textField.width = (w - display_object.textField.x);
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function CheckBoxHelper ()
		{
			super(display_object);
			display_object.textField.wordWrap = true;
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
				// convert true/false to 1/0
				var val:int = (e.target.selected ? 1 : 0);
				// prevent superfluous event firing
				if (object[property] == val) return;
				// update data object
				object[property] = val;
			});

			// setup validation handlers
			// super.bind_to(object, property);
		}


		// >>> EVENT HANDLERS
		/**
		*	update display_object.selected
		**/
		private function after_property_change (e:PropertyChangeEvent) :void
		{
			// convert 1/0 to true/false
			var selected:Boolean = Boolean(e.newValue);
			// prevent superfluous event firing
			if (selected == this['selected']) return;
			// update display object
			this['selected'] = selected;
		}
	}
}
