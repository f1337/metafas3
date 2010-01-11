package ras3r
{
	import flash.system.*;

	public class Logger
	{
		public static var verbose:Boolean = true;

		public static function dump (o:Object, depth:int = 0) :void
		{
			if (! verbose) return;

			// pad output for readability
			var pad:String = '';
			while (pad.length <= depth)
			{
				pad = pad + ' ';
			}

			// trace the string value
			if (depth == 0) log(pad + o, 'dump');

			// process properties
			for (var p:String in o)
			{
				log(pad + ' ' + p + ': ' + o[p], 'dump');
				if ((typeof o[p]) == 'object' || (typeof o[p]) == 'xml')
				{
					dump(o[p], (depth + 1));
				}
			}
		}

		public static function debug (str:String) :void
		{
			if (verbose && Capabilities.playerType == 'StandAlone')
			{
				throw new Error(str);
			}
			else
			{
				log(str, 'debug');
			}
		}

		public static function info (str:String) :void
		{
			log(str);
		}

		private static function log (str:String, level:String = 'info') :void
		{
			if (verbose) trace('[' + level + '] ' + str);
		}
	}
}