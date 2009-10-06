package com.gigya
{
	import as3spec.*;

	public class WildfireTest extends Spec
	{
		public function run () :void
		{
			describe ('a new Wildfire', function () :void
			{
				const wildfire:Wildfire = new Wildfire;

				it ('should be a Wildfire', function () :void
				{
					so(wildfire).should.be.a.kind_of(Wildfire);
				});

				it ('should contain real code', function () :void
				{
				});
			});
		}
	}
}