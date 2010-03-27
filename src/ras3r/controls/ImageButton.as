/**********************************************************************
*	ImageButton
*	- adds "source" property (proxied for UILoader)
*	- Embedded UILoader is applied as: upSkin, downSkin, overSkin
**********************************************************************/
package ras3r.controls
{
	import fl.containers.*;
	import fl.controls.*;

	public class ImageButton extends LabelButton
	{
		// >>> PUBLIC PROPERTIES
		/**
		* proxy loader height
		* imageButton.height = 12.0;
		* imageButton.height => 12.0
		**/
		override public function get height () :Number
		{
			return super.height;
		}

		override public function set height (h:Number) :void
		{
			loader.height = h;
			super.height = h;
		}

		/**
		* proxy loader source
		* imageButton.source = 'http://www.example.com/image.png';
		* imageButton.source => 'http://www.example.com/image.png'
		**/
		public function get source () :Object
		{
			return loader.source;
		}

		public function set source (s:Object) :void
		{
			loader.source = s;
		}

		/**
		* proxy loader width
		* imageButton.width = 12.0;
		* imageButton.width => 12.0
		**/
		override public function get width () :Number
		{
			return super.width;
		}

		override public function set width (w:Number) :void
		{
			loader.width = w;
			super.width = w;
		}


		// >>> PRIVATE PROPERTIES
		private var loader:UILoader = new ReUILoader;


		// >>> PUBLIC METHODS
		public function ImageButton ()
		{
			super();

			// assign loader to all skins
			setStyle('downSkin', loader);
			setStyle('overSkin', loader);
			setStyle('upSkin', loader);
		}
	}
}