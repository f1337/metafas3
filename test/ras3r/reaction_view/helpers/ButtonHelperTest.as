package metafas3.reaction_view.helpers
{
	import as3spec.*;

	public class ButtonHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new ButtonHelper', function () :void
			{
				const instance:ButtonHelper = new ButtonHelper;

				it ('should be a ButtonHelper', function () :void
				{
					so(instance).should.be.a.kind_of(ButtonHelper);
				});

				it ('should contain real code', function () :void
				{
				});
			});
		}
	}
}