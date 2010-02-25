package ras3r
{
	import flash.system.*;
	import flash.utils.*;

	dynamic public class Environment
	{
		public static function load (env:String) :void
		{
			// override env if StandAlone player
			if (Capabilities.playerType == 'StandAlone')
			{
				// test: test.swf
				if (Application.application.url.search(/test\.swf$/) > -1)
				{
					env = 'test';
				}
				// standalone: DEFAULT if Capabilities.playerType == 'StandAlone'
				else
				{
					env = 'standalone';
				}
			}
			// development: DEFAULT if env undefined
			else if (! env)
			{
				env = 'development';
			}

			include_environment(env);
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

		private static function include_environment (env:String) :void
		{
			switch (env)
			{
				case 'development':
					include "../../../../config/environments/development.as"
					break;
				case 'production':
					include "../../../../config/environments/production.as"
					break;
				case 'staging':
					include "../../../../config/environments/staging.as"
					break;
				case 'standalone':
					include "../../../../config/environments/standalone.as"
					break;
				case 'test':
					include "../../../../config/environments/test.as"
					break;
				default:
					throw new ArgumentError('Environment.include_environment: Invalid environment specified!');
					break;
			}
		}
	}
}