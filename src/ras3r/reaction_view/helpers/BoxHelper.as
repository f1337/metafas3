package ras3r.reaction_view.helpers
{
	import ras3r.*;
	import flash.display.*;
	import flash.events.*;

	public class BoxHelper
	{
		// >>> STATIC METHODS
		static public function hbox (options:Object, children:Array) :Sprite
		{
			return (new BoxHelper(options, children)).layout();
		}

		static public function vbox (options:Object, children:Array) :Sprite
		{
			options.direction = 'vertical';
			return (new BoxHelper(options, children)).layout();
		}


		// >>> PUBLIC PROPERTIES
		public var direction:String = 'horizontal';
		public var padding:Number = 4;
		public var width:Number;

		public function set id (s:String) :void
		{
			container.name = s;
		}

		public function get id () :String
		{
			return container.name;
		}


		// >>> PRIVATE PROPERTIES
		private var container:Sprite = new Sprite;
		private var children:Array;


		// >>> PUBLIC METHODS
		public function BoxHelper (options:Object = null, _children:Array = null)
		{
			// assign properties from options hash
			for (var p:String in options)
			{
				// logger.info('box ' + p + ': ' + options[p]);
				if (hasOwnProperty(p))
				{
					this[p] = options[p];
				}
				else
				{
					container[p] = options[p];
				}
			}

			// add children to stage, but
			// defer layout
			children = _children;
			for each (var child:* in children)
			{
				((child is Helper) ? child.display_object : child).addEventListener('render', after_render);
				container.addChild((child is Helper) ? child.display_object : child);
			}
		}


		// >>> PROTECTED METHODS
		// layout children
		protected function layout () :Sprite
		{
			var axis:String = (direction == 'horizontal' ? 'x' : 'y');
			var size:String = (direction == 'horizontal' ? 'width' : 'height');

			var pos:Number = 0;
			for each (var child:* in children)
			{
				// nudge if previous child exists
				child[axis] = pos;

				// if box has explicit width, apply to children
				if (width) 
				{
					child.width = width;
				}

				// update position
				pos += child[size] + padding;
			}

			return container;
		}


		// >>> EVENT HANDLERS
		private function after_render (e:Event) :void
		{
			// redraw
			layout();
		}
	}
}
