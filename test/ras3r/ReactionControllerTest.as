package metafas3
{
	import as3spec.*;

	public class SupervisingControllerTest extends Spec
	{
		public function run () :void
		{
			describe ('a new SupervisingController', function () :void
			{
				const instance:SupervisingController = new SupervisingController;
				SupervisingController.asset_host = 'http://www.example.com'

				it ('should be a SupervisingController', function () :void
				{
					so(instance).should.be.a.kind_of(SupervisingController);
				});

				it ('prepends .asset_host to url_for(relative_url)', function () :void
				{
					var relative_url:String = 'images/background.jpg';
					so(SupervisingController.url_for(relative_url)).should.equal(SupervisingController.asset_host + '/' + relative_url);
				});

				it ('does not apply .asset_host to url_for(absolute_url)', function () :void
				{
					var absolute_url:String = 'http://www.test.com/images/background.jpg';
					so(SupervisingController.url_for(absolute_url)).should.equal(absolute_url);
				});
			});
		}
	}
}