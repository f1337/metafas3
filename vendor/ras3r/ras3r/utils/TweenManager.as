package ras3r.utils
{
	import ras3r.*;

	import flash.display.*;
	import flash.geom.*;
	import fl.transitions.easing.*;
	import com.greensock.TweenLite;

	public class TweenManager 
	{

		// >>> STATIC PROPERTIES
		// >>> STATIC METHODS
		
		// >>> PUBLIC PROPERTIES
		static public var duration:Number = 0.3;

		// >>> PRIVATE PROPERTIES
		static private var completeHandler:Function;
		
		
		// >>> PUBLIC METHODS
		static public function applyPropsFromTo(from:Object, to:Object) :void
		{
			// loop through the properties of the source object (from) and apply them to the destination object (to)
			for (var prop:* in from)
			{
				if (to.hasOwnProperty(prop)) to[prop] = from[prop];
			}
		}
		
		static public function from (target:Sprite, options:Object) :void
		{
			Logger.info('DEPRECATE TweenManager usage. The "implied magic logic" breaks when you double-click "About Seller" or "Share" or "Cart".');
			// take a snapshot of target
			//var bmp:Bitmap = spriteToBitmap(target, options);

			// swap the onComplete handler that was passed in via the tween options
			// options.onComplete = TweenManager.onTweenFromComplete;
			TweenLite.from(target, options.duration, options);
		}

		static public function appear (target:Sprite, options:Object = null) :void
		{
			from(target, fade_options(target, options));
		}

		static public function fade (target:Sprite, options:Object = null) :void
		{
			to(target, fade_options(target, options));
		}
		
		static public function grow (target:Sprite, options:Object = null) :void
		{
			from(target, grow_options(target, options));
		}

		static public function shrink (target:Sprite, options:Object = null) :void
		{
			to(target, grow_options(target, options));
		}
		
		static public function dropIn (target:Sprite, options:Object = null) :void
		{
			from(target, dropIn_options(target, options));
		}

		static public function riseOut (target:Sprite, options:Object = null) :void
		{
			to(target, dropIn_options(target, options));
		}
		
		static public function riseIn (target:Sprite, options:Object = null) :void
		{
			from(target, riseIn_options(target, options));
		}

		static public function dropOut (target:Sprite, options:Object = null) :void
		{
			to(target, riseIn_options(target, options));
		}		

		static public function translate (target:Sprite, options:Object = null) :void
		{
			to(target, grow_options(target, options));
			TweenManager.applyPropsFromTo(options, target);
		}

		static public function to (target:Sprite, options:Object) :void
		{
			Logger.info('DEPRECATE TweenManager usage. The "implied magic logic" breaks when you double-click "About Seller" or "Share" or "Cart".');
			// take a snapshot of target
			//var bmp:Bitmap = spriteToBitmap(target, options);

			// swap the onComplete handler that was passed in via the tween options
			// options.onComplete = TweenManager.onTweenToComplete;
			TweenLite.to(target, options.duration, options);
		}
		
		// >>> PRIVATE METHODS
		static private function fade_options (target:Sprite, options:Object) :Object
		{
			if (! options) options = {};
			if (! options.duration) options.duration = duration;
			if (! options.alpha) options.alpha = 0;
			return options;
		}

		static private function grow_options (target:Sprite, options:Object) :Object
		{
			if (! options) options = {};
			if (! options.duration) options.duration = duration;
			if (! options.height) options.height = 10;
			if (! options.width) options.width = 10;
			if (! options.x) options.x = (target.x + (target.width / 2) - options.width);
			if (! options.y) options.y = (target.y + (target.height / 2) - options.height);
			return options;
		}
		
		static private function dropIn_options (target:Sprite, options:Object) :Object
		{
			if (! options) options = {};
			if (! options.duration) options.duration = duration;
			if (! options.y) options.y = target.height * -1;
			return options;
		}
		
		static private function riseIn_options (target:Sprite, options:Object) :Object
		{
			if (! options) options = {};
			if (! options.duration) options.duration = duration;
			if (! options.y) options.y = target.height;
			return options;
		}

		static private function onTweenFromComplete (options:Object) :void
		{
//			options.target.visible = true;
			onTweenToComplete(options);
		}

		static private function onTweenToComplete (options:Object) :void
		{
			//options.target.visible = true;
			//options.target.parent.removeChild(options.ghost);
			//options.ghost.bitmapData.dispose();
			options.callback.apply(null, options.params);
		}
		
		static private function on_complete_for (sprite:Sprite, options:Object) :Object
		{
			// swap the onComplete handler that was passed in via the tween options
			var params:Array = (options.onCompleteParams ? options.onCompleteParams.valueOf() : null);
			options.onCompleteParams = [ {
				target: sprite,
				callback: options.onComplete.valueOf(),
				params: params
			}
			];

			return options;
		}
		
		// >>> PROTECTED METHODS
		// >>> EVENT HANDLERS
	}
}