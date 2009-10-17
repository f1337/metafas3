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
	import ras3r.HashTest;
	import ras3r.reaction_view.helpers.BoxHelperTest;
	import ras3r.reaction_view.helpers.ComboBoxHelperTest;
	import ras3r.reaction_view.helpers.HelperTest;
	import ras3r.reaction_view.helpers.ImageHelperTest;
	import ras3r.reaction_view.helpers.RadioButtonGroupHelperTest;
	import ras3r.reaction_view.helpers.RadioButtonHelperTest;
	import ras3r.reaction_view.helpers.TextFieldHelperTest;
	import ras3r.reaction_view.helpers.TextInputHelperTest;
	import ras3r.reaction_view.helpers.UIComponentHelperTest;
	import ras3r.ReactionControllerTest;
	import ras3r.ReactionViewTest;
	import ras3r.reactive_resource.ResponseTest;

	public class AllTests extends Suite
	{
		public function AllTests ()
		{
			add(com.gigya.WildfireTest);
			add(ras3r.HashTest);
			add(ras3r.reaction_view.helpers.BoxHelperTest);
			add(ras3r.reaction_view.helpers.ComboBoxHelperTest);
			add(ras3r.reaction_view.helpers.HelperTest);
			add(ras3r.reaction_view.helpers.ImageHelperTest);
			add(ras3r.reaction_view.helpers.RadioButtonGroupHelperTest);
			add(ras3r.reaction_view.helpers.RadioButtonHelperTest);
			add(ras3r.reaction_view.helpers.TextFieldHelperTest);
			add(ras3r.reaction_view.helpers.TextInputHelperTest);
			add(ras3r.reaction_view.helpers.UIComponentHelperTest);
			add(ras3r.ReactionControllerTest);
			add(ras3r.ReactionViewTest);
			add(ras3r.reactive_resource.ResponseTest);
		}
	}
}