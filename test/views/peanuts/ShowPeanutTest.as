package views.peanuts
{
	import as3spec.*;

	public class ShowPeanutTest extends Spec
	{
		public function run () :void
		{
			describe ('a new ShowPeanut', function () :void
			{
				const showPeanut:ShowPeanut = new ShowPeanut;

				it ('should be a ShowPeanut', function () :void
				{
					so(showPeanut).should.be.a.kind_of(ShowPeanut);
				});

				it ('should contain real code', function () :void
				{
				});
			});
		}
	}
}