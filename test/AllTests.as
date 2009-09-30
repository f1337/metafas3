package
{
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import as3spec.*;
	import com.gigya.WildfireTest;
	import ras3r.controls.TextTest;
	import ras3r.reaction_view.helpers.ImageHelperTest;
	import ras3r.reaction_view.helpers.TextFieldHelperTest;

	public class AllTests extends Suite
	{
		public function AllTests ()
		{
			add(com.gigya.WildfireTest);
			add(ras3r.controls.TextTest);
			add(ras3r.reaction_view.helpers.ImageHelperTest);
			add(ras3r.reaction_view.helpers.TextFieldHelperTest);
		}
	}
}