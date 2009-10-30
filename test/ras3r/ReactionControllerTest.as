package ras3r
{
	import as3spec.*;

	public class ReactionControllerTest extends Spec
	{
		public function run () :void
		{
			describe ('a new ReactionController', function () :void
			{
				const instance:ReactionController = new ReactionController;
				ReactionController.asset_host = 'http://www.example.com'

				it ('should be a ReactionController', function () :void
				{
					so(instance).should.be.a.kind_of(ReactionController);
				});

				it ('prepends .asset_host to url_for(relative_url)', function () :void
				{
					var relative_url:String = 'images/background.jpg';
					so(ReactionController.url_for(relative_url)).should.equal(ReactionController.asset_host + '/' + relative_url);
				});

				it ('does not apply .asset_host to url_for(absolute_url)', function () :void
				{
					var absolute_url:String = 'http://www.test.com/images/background.jpg';
					so(ReactionController.url_for(absolute_url)).should.equal(absolute_url);
				});
			});
		}
	}
}