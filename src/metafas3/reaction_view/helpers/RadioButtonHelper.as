package metafas3.reaction_view.helpers
{
	import fl.controls.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import mx.events.PropertyChangeEvent;
	import metafas3.*;

	use namespace flash_proxy;

	dynamic public class RadioButtonHelper extends FormItemHelper
	{
		/**
		*	RadioButtonHelper.default_options
		*		a Hash of properties to be used as default assigns
		*		to new instances of RadioButtonHelper
		**/
		static public var default_options:Hash = new Hash;

		/**
		*	RadioButtonHelper.create:
		*		returns a new instance of RadioButtonHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :RadioButtonHelper
		{
			return (FormItemHelper.create(RadioButtonHelper, options) as RadioButtonHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	radioButtonHelper.checked: HTML5 property alias for RadioButton.selected
		**/
		public function set checked (checked:Boolean) :void
		{
			this.selected = true;
		}

		/**
		*	public display_object interface
		*	RadioButton to proxy
		**/
		public var display_object:RadioButton = new RadioButton();

		/**
		*	sets up label clicks to trigger checkbox clicks
		**/
		public function set label (helper:TextFieldHelper) :void
		{
			helper.display_object.addEventListener('click', function (e:Event) :void
			{
				display_object.dispatchEvent(new MouseEvent('click'));
			});
		}

		/**
		*	proxy for radio_button.group
		**/
		public function get group () :*
		{
			return getProperty('group');
		}

		public function set group (g:*) :void
		{
			var group:RadioButtonGroup = RadioButtonGroup.getGroup(g as String);
			if (! group)
			{
				group = new RadioButtonGroup(g);
			}
			setProperty('group', group);
		}


		// >>> PUBLIC METHODS
		public function RadioButtonHelper ()
		{
			super(display_object);
			display_object.label = '';
		}

		/**
		*	Set up data binding
		**/
		override public function bind_to (object:*, property:String) :void
		{
			// initialize object[property] w/ value if selected:
			if (this.selected) 
			{
				object[property] = this.value;
			}
			// toggle "selected" w/ current value of object[property]:
			else if (object[property] !== null)
			{
				this.selected = (object[property] == this.value);
			}

			// helper responds to changes to object[property]
			object.addEventListener(property + '_change', after_property_change);

			// object[property] responds to changes to text_input.text
			display_object.addEventListener('change', function (e:Object) :void
			{
				// prevent superfluous event firing
				if (this.selected != null && object[property] != this.value)
				{
					// update data object
					object[property] = this.value;
				}
			});

			// setup validation handlers
			super.bind_to(object, property);
		}

		/**
		*	update display_object.selected
		**/
		private function after_property_change (e:PropertyChangeEvent) :void
		{
			// prevent superfluous event firing
			if (e.newValue == this.value && this.selected) return;
			// update display object
			this.selected = (e.newValue == this.value);
		}
	}
}