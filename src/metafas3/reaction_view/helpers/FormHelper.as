package metafas3.reaction_view.helpers
{
	import com.yahoo.astra.fl.containers.*;
	import com.yahoo.astra.fl.containers.layoutClasses.*;
	import com.yahoo.astra.layout.*;
	import metafas3.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	use namespace flash_proxy;

	dynamic public class FormHelper extends LayoutHelper
	{
		static public var default_options:Hash = new Hash;

		/**
		*	FormHelper.create:
		*		returns a new instance of LayoutHelper klass,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :FormHelper
		{
			// create the helper
			return (LayoutHelper.create(FormHelper, options) as FormHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	form action property (url)
		**/
		public var action:String;

		/**
		*	boxHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a FlowPane
		**/
		public var display_object:FlowPane = new FlowPane;

		override public function set children (a:Array) :void
		{
			var buttons:Array = submit_buttons_from_children(a);

			for each (var button:ImageButtonHelper in buttons)
			{
				button.buttonMode = true;
				button.display_object.addEventListener('click', function (e:MouseEvent) :void
				{
					submit();
				});
			}

			super.children = a;
		}

		/**
		*	form method (GET or POST)
		**/
		public var method:String = 'POST';


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function FormHelper (proxied_object:Object = null)
		{
			super(proxied_object);
		}

		/**
		*	dispatch the "submit" event
		**/
		public function submit () :void
		{
			display_object.dispatchEvent(new NetStatusEvent('submit', false, true, this));
		}


		// >>> PRIVATE METHODS
		/**
		*	Expects array of child helpers, returns array of child ImageHelpers
		**/
		private function submit_buttons_from_children (children:Array) :Array
		{
			var buttons:Array = [];
			for each (var child:* in children)
			{
				if (child is LayoutHelper)
				{
					buttons.push.apply(buttons, submit_buttons_from_children(child.children));
				}
				else if (child is ImageButtonHelper)
				{
					buttons.push(child);
				}
			}
			return buttons;
		}
	}
}