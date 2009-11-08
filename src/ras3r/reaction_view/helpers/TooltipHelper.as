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
			var closure:Function = function (helper:Helper, hoptions:Object) :void
			{
				// per ActionScript 3 Language Reference (TextField#condenseWhite):
				// "Set the condenseWhite property before setting the htmlText property."
				if (hoptions.condenseWhite) helper.condenseWhite = hoptions.remove('condenseWhite');

				// is a custom font defined?
				// if so, set default embedFonts = true
				hoptions.embedFonts = Boolean(hoptions.format && hoptions.format.font && hoptions.embedFonts !== false);

				/*
				Advanced anti-aliasing allows font faces to be rendered
				at very high quality at small sizes. It is best used 
				with applications that have a lot of small text. 
				Advanced anti-aliasing is not recommended for very 
				large fonts (larger than 48 points).
				*/ 
				hoptions.antiAliasType = (hoptions.embedFonts && hoptions.format.size <= 48 && hoptions.antiAliasType != 'normal') ? 'advanced' : 'normal';
			};

			return (Helper.create(TooltipHelper, options, closure) as TooltipHelper);
		}


		// >>> PUBLIC PROPERTIES
		private var arrow:Shape = new Shape;

		/**
		*	fill color
		**/
		public var fill:uint = 0xffffff;

		/**
		*	proxy for display_object.filters
		**/
		public function get filters () :Array
		{
			return display_object.filters;
		}

		public function set filters (f:Array) :void
		{
			display_object.filters = f;
		}

		/**
		*	proxy for display_object.height
		**/
        private var _height:Number;
		public function get height () :Number
		{
			return (_height ? _height : display_object.height);
		}

		public function set height (val:Number) :void
		{
            _height = val;
			draw(0, val);
			update_text_field_position();
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
		public var text_field:TextField = new TextField();

		/**
		*	proxy for display_object.visible
		**/
		public function get visible () :Boolean
		{
			return display_object.visible;
		}

		public function set visible (val:Boolean) :void
		{
			display_object.visible = val;
		}

		/**
		*	proxy for display_object.width
		**/
		public function get width () :Number
		{
			return display_object.width;
		}

		public function set width (val:Number) :void
		{
			draw(val, 0);
			text_field.width = val;
		}

		/**
		*	proxy for display_object.x
		**/
		public function get x () :Number
		{
			return display_object.x;
		}

		public function set x (val:Number) :void
		{
			display_object.x = val;
		}

		/**
		*	proxy for display_object.y
		**/
		public function get y () :Number
		{
			return display_object.y;
		}

		public function set y (val:Number) :void
		{
			display_object.y = val;
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function TooltipHelper ()
		{
			super(text_field);
			display_object = new Sprite();
			display_object.addChild(arrow);
			display_object.addChild(text_field);
			text_field.addEventListener('render', update_text_field_position);
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
		private function update_text_field_position (...args) :void
		{
            //Logger.info('update_text_field_position h: ' + height + )
			text_field.y = Math.ceil((height - text_field.textHeight) / 2);
		}
	}
}