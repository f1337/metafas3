package ras3r.reaction_view.helpers
{
	import as3spec.*;

	public class HelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new Helper', function () :void
			{
				const helper:Helper = new Helper;

				it ('should be a Helper', function () :void
				{
					so(helper).should.be.a.kind_of(Helper);
				});

				it ('should contain real code', function () :void
				{
				});
			});
		}
	}
}