package ras3r
{
	import as3spec.*;

	public class ValidatesTest extends Spec
	{
		public function run () :void
		{
			describe ('a new Validates', function () :void
			{
				const validates:Validates = new Validates;

				it ('should be a Validates', function () :void
				{
					so(validates).should.be.a.kind_of(Validates);
				});

				it ('should contain real code', function () :void
				{
				});
			});
		}
	}
}