package ras3r.controls
{
	import flash.text.*;

	public class Text extends TextField
	{
		// >>> PUBLIC PROPERTIES
		public function set format (hash:Object) :void
		{
			var tf:TextFormat = defaultTextFormat;
			for (var key:String in hash)
			{
				tf[key] = hash[key];
			}
			defaultTextFormat = tf;
			setTextFormat(tf);
		}


		// >>> PUBLIC METHODS
		public function Text ()
		{
			super();
			autoSize = 'left';
			wordWrap = true;
		}
	}
}
