package ras3r
{
	import as3spec.*;
	import flash.display.*;
	import flash.events.*;
	import fl.controls.*;
	import ras3r.*;
	import ras3r.reaction_view.helpers.*;
	import ras3r.utils.*;

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
					const assigns:Object = { x: 12, y: 15, order: (new ObjectProxy({ last_name: 'Smith' })) };
					const view:* = ReactionView.create('', assigns);

					it ('returns a DisplayObject', function () :void
					{
						so(view).should.be.a.kind_of(DisplayObject);
					});

					it ('assigns properties from hash', function () :void
					{
						so(view.x).should.equal(assigns.x);
						so(view.y).should.equal(assigns.y);
					});

					describe ('using some_helper_for("order", "last_name")', function () :void
					{
						// could be *any* helper
						view.text_input_for("order", "last_name");
						view.dispatchEvent(new Event('render'));

						it ('creates a TextInput with id "order_last_name"', function () :void
						{
							so(view['order_last_name']).should.be.a.kind_of(TextInputHelper);
						});

						it ('assigns the textinput a name of "order_last_name"', function () :void
						{
							so(view['order_last_name'].name).should.equal('order_last_name');
						});

						it ('sets textinput.text equal to order.last_name', function () :void
						{
							so(view['order_last_name'].text).should.equal(view['order']['last_name']);
						});

						it ('updates textinput.text when order.last_name changes', function () :void
						{
							view['order']['last_name'] = 'Jones';
							view['order'].dispatchEvent(new Event('last_name_change'));
							so(view['order_last_name'].text).should.equal(view['order']['last_name']);
						});

						it ('updates order.last_name when textinput.text changes', function () :void
						{
							view['order_last_name'].text = 'Roberts';
							view['order_last_name'].display_object.dispatchEvent(new Event('change'));
							so(view['order']['last_name']).should.equal(view['order_last_name'].text);
						});
					});
				});
			});
		}
	}
}