package models.domain
{
	import as3spec.*;

	public class PeanutTest extends Spec
	{
		public function run () :void
		{
			describe ('a new Peanut', function () :void
			{
				const peanut:Peanut = new Peanut;

				it ('should be a Peanut', function () :void
				{
					so(peanut).should.be.a.kind_of(Peanut);
				});

				it ('should contain real code', function () :void
				{
				});
			});
		}
	}
}