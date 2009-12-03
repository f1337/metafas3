package ras3r
{
	import as3spec.*;

	public class XMLViewTest extends Spec
	{
		public function run () :void
		{
			describe ('a new XMLView', function () :void
			{
				const xMLView:XMLView = new XMLView;

				it ('should be a XMLView', function () :void
				{
					so(xMLView).should.be.a.kind_of(XMLView);
				});

				it ('should contain real code', function () :void
				{
				});
			});
		}
	}
}