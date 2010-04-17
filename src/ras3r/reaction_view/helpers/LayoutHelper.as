package ras3r.reaction_view.helpers
{
	import com.yahoo.astra.fl.containers.*;
	import com.yahoo.astra.fl.containers.layoutClasses.*;
	import com.yahoo.astra.layout.*;
	import ras3r.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	use namespace flash_proxy;

	dynamic public class LayoutHelper extends UIComponentHelper
	{
		static public var default_options:Hash = new Hash({
			horizontalGap: 0,
			verticalGap: 0
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

		// adds an array of DisplayObjects and/or Helpers to the stage
		public function set children (a:Array) :void
		{
			var target:*;
			for each (var child:* in a)
			{
				target = (child is Helper) ? child.display_object : child;
				this.addChild(target);
			}
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