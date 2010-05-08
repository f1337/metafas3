package metafas3.reaction_view.helpers
{
	import fl.controls.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import metafas3.*;
	import metafas3.controls.*;

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
		*	buttonHelper.click = String
		*	URL to fetch on "click" event
		*	TODO: extend to accept controller/view syntax ("products/show")
		*	write-only
		**/
		public function set click (url:String) :void
		{
			display_object.addEventListener('click', function (e:Event) :void
			{
				SupervisingController.redirect_to_url(url);
			});
		}

		/**
		*	buttonHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a Button
		**/
		public var display_object:Button = new ReButton();

		/**
		*	buttonHelper.icon = Class
		*	applies Class to "icon" style on button
		*	write-only
		**/
		public function set icon (icon:Object) :void
		{
			this.setStyle('icon', icon);
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function ButtonHelper ()
		{
			super(display_object);

			display_object.addEventListener('mouseDown', after_state_change);
			display_object.addEventListener('rollOut', after_state_change);
			display_object.addEventListener('rollOver', after_state_change);
		}

		/**
		*	Set up data binding
		**/
		override public function bind_to (object:*, property:String) :void
		{
			// helper responds to changes to object[property]
			object.addEventListener(property + '_change', after_property_change);
		}


		// >>> EVENT HANDLERS
		/**
		*	data binding handler: update text
		**/
		private function after_property_change (e:Object) :void
		{
			// prevent superfluous event firing
			if (e.newValue == this.label) return;
			// update display object
			this.label = e.newValue;
		}

		/**
		*	after_state_change apply state's TextFormat
		**/
		protected function after_state_change (e:MouseEvent) :void
		{
			// map event to state: "rollOver" => 'over', "mouseDown" => 'down'
			var state:String = e.type.match(/([A-Z][a-z]+)$/).pop().toString().toLowerCase();
			// "rollOut" => 'up'
			if (state == 'out') state = 'up';

			// apply stateTextFormat, if exists
			var fmt:Object = this.getStyle(state + 'TextFormat');
			if (fmt) format = fmt;
		}
	}
}