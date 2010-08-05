package metafas3.reaction_view.helpers
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import mx.events.*;
	import metafas3.*;

	use namespace flash_proxy;

	dynamic public class HiddenInputHelper extends FormItemHelper
	{
		/**
		*	HiddenInputHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of HiddenInputHelper
		**/
		static public var default_options:Hash = new Hash;

		/**
		*	HiddenInputHelper.create:
		*		returns a new instance of HiddenInputHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :HiddenInputHelper
		{
			return (FormItemHelper.create(HiddenInputHelper, options) as HiddenInputHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	Every Helper is expected to provide a display_object.
		*	This one is a Sprite
		**/
		public var display_object:Sprite;// = new Sprite;

		public var value:String = '';


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a Sprite.
		**/
		public function HiddenInputHelper ()
		{
			super(display_object);
		}

		/**
		*	Set up data binding
		**/
		override public function bind_to (object:*, property:String) :void
		{
			// initialize object[property] w/ value, if defined:
			if (value) object[property] = value;

			// helper responds to changes to object[property]
			object.addEventListener(property + '_change', after_property_change);

			// setup validation handlers
			super.bind_to(object, property);
		}

		override public function getStyle (key:String) :Object
		{
			return null;
		}

		override public function setStyle (key:String, value:Object) :void
		{
			// do nothing, this is a hidden input
		}


		// >>> EVENT HANDLERS
		/**
		*	update value
		**/
		private function after_property_change (e:PropertyChangeEvent) :void
		{
			// prevent superfluous event firing
			if (e.newValue == value) return;
			// update display object
			value = e.newValue.toString();
		}
	}
}
