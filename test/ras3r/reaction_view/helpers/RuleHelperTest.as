package metafas3.reaction_view.helpers
{
	import as3spec.*;

	public class RuleHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new RuleHelper', function () :void
			{
				const ruleHelper:RuleHelper = new RuleHelper;

				it ('should be a RuleHelper', function () :void
				{
					so(ruleHelper).should.be.a.kind_of(RuleHelper);
				});

				it ('should contain real code', function () :void
				{
				});
			});
		}
	}
}