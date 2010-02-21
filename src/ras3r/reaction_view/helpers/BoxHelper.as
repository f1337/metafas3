package ras3r.reaction_view.helpers
{
	import com.yahoo.astra.fl.containers.*;
	import ras3r.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	use namespace flash_proxy;

	dynamic public class BoxHelper extends UIComponentHelper
	{
		static public function hbox (options:Object, children:Array) :Sprite
		{
			options.direction = 'horizontal';
			return (new BoxHelper(options, children)).display_object;
		}

		static public function vbox (options:Object, children:Array) :Sprite
		{
			options.direction = 'vertical';
			return (new BoxHelper(options, children)).display_object;
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	imageHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is an Image
		**/
		public var display_object:BoxPane = new BoxPane;

		public function set id (s:String) :void
		{
			display_object.name = s;
		}

		public function get id () :String
		{
			return display_object.name;
		}

		public function set padding (p:Number) :void
		{
			this.paddingBottom = p;
			this.paddingLeft = p;
			this.paddingRight = p;
			this.paddingTop = p;
		}


		// >>> PRIVATE PROPERTIES
		private var children:Array;


		// >>> PUBLIC METHODS
		public function BoxHelper (options:Object = null, _children:Array = null)
		{
			super(display_object);

			// assign properties from options hash
			for (var p:String in options)
			{
				this[p] = options[p];
			}

			// add children to stage
			children = _children;
			for each (var child:* in children)
			{
				display_object.addChild((child is Helper) ? child.display_object : child);
			}
		}
	}
}
