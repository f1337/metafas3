package metafas3.reaction_view.helpers
{
	import fl.controls.*;
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import metafas3.*;

	use namespace flash_proxy;

	dynamic public class RuleHelper extends Helper
	{
		/**
		*	RuleHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of RuleHelper
		**/
		static public var default_options:Hash = new Hash;

		/**
		*	RuleHelper.create:
		*		returns a new instance of RuleHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :RuleHelper
		{
			return (Helper.create(RuleHelper, options) as RuleHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	ruleHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a Rule
		**/
		public var display_object:Shape = new Shape();

		/**
		*	stroke color
		**/
		public var stroke:uint = 0xffffff;


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function RuleHelper ()
		{
			super(display_object);
			// redraw on width/height change
			addEventListener('propertyChange', draw);
		}


		// >>> PRIVATE METHODS
		/**
		*	draws fill
		**/
		private function draw (...args) :void
		{
			with (this.graphics)
			{
				clear();
	            beginFill(stroke, 1);
				// b/c we assign properties from a hash "with indifferent access"
				// we need to draw a fill that is full width and height
				// using "100" for either undefined dimension
	            drawRect(0, 0, (this.width || 100), (this.height || 100));
	            endFill();
			}
		}
	}
}
