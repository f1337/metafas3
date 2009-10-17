package ras3r.reaction_view.helpers
{
	import as3spec.*;

	public class CheckBoxHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new CheckBoxHelper', function () :void
			{
				const instance:CheckBoxHelper = new CheckBoxHelper;

				it ('should be a CheckBoxHelper', function () :void
				{
					so(instance).should.be.a.kind_of(CheckBoxHelper);
				});

				it ('should contain real code', function () :void
				{
				});
			});
		}
	}
}