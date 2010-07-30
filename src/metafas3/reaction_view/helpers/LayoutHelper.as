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

	dynamic public class LayoutHelper extends UIComponentHelper
	{
		static public var default_options:Hash = new Hash({
			direction:		'vertical',
			horizontalGap: 	0,
			verticalGap: 	0
		});

		/**
		*	LayoutHelper.create:
		*		returns a new instance of LayoutHelper klass,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static protected function create (klass:Class, options:Object = null) :LayoutHelper
		{
			options = default_options.merge(klass.default_options).update(options);

			// setup custom layout config for Astra layout containers
			options.configuration = [];
			for each (var child:* in options.children)
			{
				options.configuration.push({ target: child.display_object, includeInLayout: (child.position != 'absolute') })
			}

			return (Helper.create(klass, options) as LayoutHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	LayoutHelper.background: alias for backgroundImage
		*	for CSS compatibility
		**/
		override public function set background (url:Object) :void
		{
			backgroundImage = url.toString();
		}

		private var _background:*;
		public function set backgroundColor (c:String) :void
		{
			// draw fill
			_background = new Shape();
            _background.graphics.beginFill(uint(c.replace('#', '0x')), 1);
            _background.graphics.drawRect(0, 0, 100, 100);
            _background.graphics.endFill();
			this.setStyle('skin', _background);
		}

		/**
		*	LayoutHelper.backgroundImage: attaches an ImageHelper, loads url
		*	for CSS compatibility
		**/
		public function set backgroundImage (url:String) :void
		{
			// strip URL from CSS syntax
			url = url.replace(/[^\(]+\(([^\)]+)\)/, '$1');
			// set the image source
			_background = ImageHelper.create({ source: url });
			this.setStyle('skin', _background.display_object);
		}

		/**
		*	draw border
		**/
		private var _border:*;
		public function set border (s:String) :void
		{
			var ar:Array = s.split(' ');
			var border_options:Hash = new Hash;
			border_options.width = parseInt(ar[0]);
			border_options.style = ar[1];
			border_options.color = uint(ar[2].replace('#', '0x'));


			_border = new Shape();
/*            _border.graphics.beginFill(uint(ar[2].replace('#', '0x')), 1);
            _border.graphics.drawRect(0, 0, 100, 100);
            _border.graphics.endFill();
*/


			var gr:* = _border.graphics;
			gr.clear();

			gr.lineStyle(border_options.width, border_options.color);
			gr.moveTo(0, 0);
			gr.lineTo(100, 0);
			gr.lineTo(100, 100);
			gr.lineTo(0, 100);
			gr.lineTo(0, 0);

/*			gr.beginFill(border_options.color, 1);
			// draw top edge
			gr.drawRect(0, 0, 100, border_options.width);
			// draw bottom edge
			gr.drawRect(border_options.width, 100, 100, border_options.width);
			// draw left edge
			gr.drawRect(0, border_options.width, border_options.width, 100);
			// draw right edge
			gr.drawRect(100, 0, border_options.width, 100);
			gr.endFill();
*/
			this.padding = border_options.width;
/*			this.setStyle('contentPadding', border_options.width);*/
			this.setStyle('skin', _border);
		}

		// adds an array of DisplayObjects and/or Helpers to the stage
		private var _children:Array;
		public function set children (a:Array) :void
		{
			_children = a;
			var target:*;
			for each (var child:* in a)
			{
				target = (child is Helper) ? child.display_object : child;
				this.addChild(target);
			}
		}

		public function get children () :Array
		{
			return _children;
		}

		/**
		*	imageHelper.padding
		*	shortcut to set all 4 padding values at once
		**/
		public function set padding (p:Number) :void
		{
			this.paddingBottom = p;
			this.paddingLeft = p;
			this.paddingRight = p;
			this.paddingTop = p;
		}

		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function LayoutHelper (proxied_object:Object = null)
		{
			super(proxied_object);
		}
	}
}