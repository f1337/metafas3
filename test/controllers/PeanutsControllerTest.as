package controllers
{
	import as3spec.*;

	public class PeanutsControllerTest extends Spec
	{
		public function run () :void
		{
			describe ('a new PeanutsController', function () :void
			{
				const instance:PeanutsController = new PeanutsController;

				it ('should be a PeanutsController', function () :void
				{
					so(instance).should.be.a.kind_of(PeanutsController);
				});

				it ('should contain real code', function () :void
				{
				});
			});
		}
	}
}