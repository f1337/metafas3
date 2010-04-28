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

		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function CheckBoxHelper ()
		{
			super(display_object);
			display_object.label = '';
		}

		/**
		*	Set up data binding
		**/
		override public function bind_to (object:*, property:String) :void
		{
			// initialize "selected" w/ current value of object[property]:
			if (object[property] !== null) selected = object[property];

			// helper responds to changes to object[property]
			object.addEventListener(property + '_change', after_property_change);

			// object[property] responds to changes to text_input.text
			display_object.addEventListener('change', function (e:Object) :void
			{
				// prevent superfluous event firing
				if (object[property] == selected) return;
				// update data object
				object[property] = selected;
			});

			// setup validation handlers
			// super.bind_to(object, property);
		}

		/**
		*	override "selected" property setter to translate 1/0 as true/false
		**/
		public function set selected (n:uint) :void
		{
			setProperty('selected', (n === 1 ? true : false))
		}

		public function get selected () :uint
		{
			return (getProperty('selected') ? 1 : 0);
		}


		// >>> EVENT HANDLERS
		/**
		*	update display_object.selected
		**/
		private function after_property_change (e:PropertyChangeEvent) :void
		{
			// prevent superfluous event firing
			if (e.newValue == selected) return;
			// update display object
			selected = uint(e.newValue);
		}
	}
}
