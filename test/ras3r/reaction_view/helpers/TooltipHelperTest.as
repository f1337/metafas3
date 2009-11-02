package ras3r.reaction_view.helpers
{
	import as3spec.*;

	public class TooltipHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new TooltipHelper', function () :void
			{
				const instance:TooltipHelper = new TooltipHelper;

				it ('should be a TooltipHelper', function () :void
				{
					so(instance).should.be.a.kind_of(TooltipHelper);
				});

				it ('should contain real code', function () :void
				{
				});
			});
		}
	}
}