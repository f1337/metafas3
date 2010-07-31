package
{
	import metafas3.*;
	
	import controllers.*;
	import environments.*;

	public class metafas3 extends Application
	{
		// environments
		private static var development:Development;
		private static var production:Production;
		private static var staging:Staging;
		private static var standalone:Standalone;
		private static var test:Test;
		
		// controllers
		private static var applicationController:ApplicationController;
	}
}
