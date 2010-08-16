package metafas3
{
	import fl.data.DataProvider;
	import flash.system.*;

	public class Logger
	{
		public static var debug:Function = err;
		public static var error:Function = err;
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
			if (depth == 0) info(pad + o, 'dump');

			// process properties
			for (var p:String in o)
			{
				info(pad + ' ' + p + ': ' + o[p], 'dump');
				if ((typeof o[p]) == 'object' || (typeof o[p]) == 'xml')
				{
					dump(o[p], (depth + 1));
				}
			}
		}

		public static function err (str:String) :void
		{
			if (verbose && Capabilities.playerType == 'StandAlone')
			{
				throw new Error(str);
			}
			else
			{
				warn(str, 'ERROR');
			}
		}

		public static function info (str:String, level:String = 'info') :void
		{
			log('[' + level + '] ' + str);
		}

		public static function warn (str:String, level:String = 'WARNING') :void
		{
			log('>>> ' + level + ': ' + str);
		}

		private static function log (str:String) :void
		{
			if (verbose) trace(str);
		}
	}
}