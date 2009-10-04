package ras3r
{
	import as3spec.*;
	import flash.display.*;

	public class ReactionViewTest extends Spec
	{
		public function run () :void
		{
			describe ('a new ReactionView', function () :void
			{
				const instance:ReactionView = new ReactionView;

				it ('should be a ReactionView', function () :void
				{
					so(instance).should.be.a.kind_of(ReactionView);
				});

				describe ('with ReactionView.create(template, assigns)', function () :void
				{
					const assigns:Object = { x: 12, y: 15 };
					const view:DisplayObject = ReactionView.create('', assigns);

					it ('returns a DisplayObject', function () :void
					{
						so(view).should.be.a.kind_of(DisplayObject);
					});

					it ('assigns properties from hash', function () :void
					{
						so(view.x).should.equal(assigns.x);
						so(view.y).should.equal(assigns.y);
					});
				});
			});
		}
	}
}