package ras3r
{
	import flash.system.*;
	import flash.utils.*;

	dynamic public class Environment
	{
		public static function load (url:String) :void
		{
			var env:String;

			// WARNING: DO NOT CHANGE THIS REGEX
			//					WITHOUT WRITTEN APPROVAL FROM Michael Fleet
			// matches: http://blah.blahblah.blahblahblah.com/
			// production: .com domains
			if (url.search(/^https?:\/\/[^\/]+\.com\//) > -1)
			{
				env = 'production';
			}
			// staging: .net domains
			else if (url.search(/^https?:\/\/[^\/]+\.net\//) > -1)
			{
				env = 'staging';
			}
			else if (Capabilities.playerType == 'StandAlone')
			{
				// test: test.swf
				if (url.search(/test\.swf$/) > -1)
				{
					env = 'test';
				}
				// standalone: DEFAULT if Capabilities.playerType == 'StandAlone'
				else if (url != '')
				{
					env = 'standalone';
				}
			}
			// development: now DEFAULT if url =~ http
			else
			// old way: localhost, 192.168.*, etc
			// else if (url.search(/^http:\/\/(localhost|192\.168\.\d+\.\d+)[^\/]*\//) > -1)
			{
				env = 'development';
			}

			// default:
			if (! env) env = url;
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
				Logger.info('Environment.params mx.core.Application undefined: ' + exception);
			}

			try
			{
				if (! p) p = ApplicationDomain.currentDomain.getDefinition('Application').application.parameters;
			}
			catch (exception:*)
			{
				// run the finally block
				Logger.info('Environment.params Application undefined: ' + exception);
			}

			p ||= {};
			return p;
		}

		private static function include_environment (env:String) :void
		{
			switch (env)
			{
				case 'development':
					include "../../../config/environments/development.as"
					break;
				case 'production':
					include "../../../config/environments/production.as"
					break;
				case 'staging':
					include "../../../config/environments/staging.as"
					break;
				case 'standalone':
					include "../../../config/environments/standalone.as"
					break;
				case 'test':
					include "../../../config/environments/test.as"
					break;
				default:
					throw new ArgumentError('Environment.include_environment: Invalid environment specified!');
					break;
			}
		}
	}
}