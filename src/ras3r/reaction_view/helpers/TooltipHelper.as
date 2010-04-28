package ras3r.reaction_view.helpers
{
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import ras3r.*;

	use namespace flash_proxy;

	dynamic public class TooltipHelper extends TextFieldHelper
	{
		static public var default_options:Hash = TextFieldHelper.default_options;

		static public function create (options:Object = null) :TooltipHelper
		{
			return (Helper.create(TooltipHelper, options, create_helper_callback) as TooltipHelper);
		}


		// >>> PUBLIC PROPERTIES
		private var arrow:Shape = new Shape;

		/**
		*	fill color
		**/
		public var fill:uint = 0xffffff;

		/**
		*	proxy for display_object.height
		**/
		override public function set height (val:Number) :void
		{
			super.height = val;
			draw(0, val);
            // we don't change the textfield height here,
            // so call after_textfield_render to do so
			after_textfield_render({});
		}

		private var _point:Object;
		public function set point (p:Object) :void
		{
			_point = p;
			draw();
		}

		/**
		*	text for tooltip
		**/
/*		public var text_field:TextField = new TextField();*/

		/**
		*	proxy for display_object.width
		**/
		override public function get width () :Number
		{
			return super.width;
		}

		override public function set width (val:Number) :void
		{
			draw(val, 0);
            super.width = val;
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function TooltipHelper ()
		{
			super(text_field);
/*			display_object = new Sprite();*/
			display_object.addChild(arrow);
/*			display_object.addChild(text_field);*/
		}


		// >>> PRIVATE METHODS
		private function draw (w:Number = 0, h:Number = 0) :void
		{
			// first clear arrow shape
			arrow.graphics.clear();

			// next, calculate defaults for w, h
			w ||= width;
			h ||= height;

			// redraw box
			with (display_object.graphics)
			{
				clear();
	            beginFill(fill, 1);
	            drawRect(0, 0, w, h);
	            endFill();
			}

			if (_point)
			{
				var top:Number = ((h - 32) / 2);
				var bottom:Number = (top + 32);

				with (arrow.graphics)
				{
					// arrow
		            beginFill(fill, 1);
		            lineStyle(1, fill, 1);
					// right box edge, (h - 32) / 2
					moveTo(w, top);
					// TODO: replace with data point!
		            lineTo(_point.x, _point.y);
					// right box edge, (h - 32) / 2 + 32
					lineTo(w, bottom);
					// close the box: right box edge, (h - 32) / 2
					lineTo(w, top);
		            endFill();
				}
			}
		}


		// >>> EVENT HANDLERS
		/**
		*	vertically center text field
		**/
		override protected function after_textfield_render (e:Object) :void
		{
			super.after_textfield_render(e);
			text_field.y = Math.ceil((height - text_field.textHeight) / 2);
		}
	}
}