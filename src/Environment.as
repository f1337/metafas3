package
{
	import flash.system.*;
	import flash.utils.*;
	import metafas3.*;

	dynamic public class Environment
	{
		public static function load (env:String) :void
		{
			if (env !== 'test')
			{
				// override env if StandAlone player
				if (Capabilities.playerType == 'StandAlone')
				{
					env = 'standalone';
				}
				// development: DEFAULT if env undefined
				else if (! env)
				{
					env = 'development';
				}
			}

			// lookup environment class
			var klass:Class = (getDefinitionByName('environments.' + Inflector.camelize(env)) as Class);
		}

		public static function get params () :Object
		{
			var p:Object;
			try
			{
				p = ApplicationDomain.currentDomain.getDefinition('mx.core.Application').application.parameters;
			}
			catch (exception:*)
			{
				// run the finally block
/*				Logger.info('Environment.params mx.core.Application undefined: ' + exception);*/
			}

			try
			{
				if (! p) p = ApplicationDomain.currentDomain.getDefinition('Application').application.parameters;
			}
			catch (exception:*)
			{
				// run the finally block
/*				Logger.info('Environment.params Application undefined: ' + exception);*/
			}

			p ||= {};
			return p;
		}
	}
}