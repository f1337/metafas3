package metafas3.reaction_view.helpers
{
	import as3spec.*;
	import flash.display.*;

	public class BoxHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new BoxHelper', function () :void
			{
				const boxHelper:BoxHelper = new BoxHelper;
				const children:Array = [ (new Sprite) ];
				const options:Object = { padding: 24 };

				it ('should be a BoxHelper', function () :void
				{
					so(boxHelper).should.be.a.kind_of(BoxHelper);
				});

				it ('assigns properties from an options hash passed to constructor', function () :void
				{
					var boxHelper:BoxHelper = new BoxHelper(options, children);
					// test each option for assignment
					for (var p:String in options)
					{
						so(boxHelper[p]).should.equal(options[p]);
					}
				});

				it ('returns a DisplayObject via BoxHelper.hbox()', function () :void
				{
					so(BoxHelper.hbox(options, children)).should.be.a.kind_of(DisplayObject);
				});

				it ('returns a DisplayObject via BoxHelper.vbox()', function () :void
				{
					so(BoxHelper.vbox(options, children)).should.be.a.kind_of(DisplayObject);
				});
			});
		}
	}
}