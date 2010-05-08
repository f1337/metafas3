package metafas3.reaction_view.helpers
{
	import as3spec.*;

	public class UIComponentHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new UIComponentHelper', function () :void
			{
				const instance:UIComponentHelper = new UIComponentHelper;

				it ('should be a UIComponentHelper', function () :void
				{
					so(instance).should.be.a.kind_of(UIComponentHelper);
				});
			});
		}
	}
}