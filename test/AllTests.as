package
{
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import as3spec.*;
	import controllers.PeanutControllerTest;
	import controllers.PeanutsControllerTest;
	import models.domain.PeanutTest;
	import views.peanuts.ShowPeanutTest;

	public class AllTests extends Suite
	{
		public function AllTests ()
		{
			add(controllers.PeanutControllerTest);
			add(controllers.PeanutsControllerTest);
			add(models.domain.PeanutTest);
			add(views.peanuts.ShowPeanutTest);
		}
	}
}