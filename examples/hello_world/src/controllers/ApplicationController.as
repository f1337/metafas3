package controllers
{
	import controllers.*;
	import metafas3.*;

	dynamic public class ApplicationController extends SupervisingController
	{
		public function load () :void
		{
			render(root.loaderInfo.url.replace(/bin\/[^\/]+$/, 'src/views/hello.html'));
		}
	}
}