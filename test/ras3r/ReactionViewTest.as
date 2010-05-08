package metafas3
{
	import as3spec.*;
	import flash.display.*;
	import flash.events.*;
	import fl.controls.*;
	import fl.data.*;
	import metafas3.*;
	import metafas3.reaction_view.helpers.*;

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
					const assigns:Object = { x: 12, y: 15, order: (new ReactiveResource({ last_name: 'Smith', state: { label: 'AZ', data: 'AZ' }, states: (new DataProvider([ 'AZ', 'OH', 'SC', 'FL' ])) })) };
					const view:* = ReactionView.create('', assigns);
					view.text_input_for("order", "last_name");
					view.combo_box_for("order", "state", view['order']['states']);
					view.dispatchEvent(new Event('render'));

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
							so(view['order_last_name'].text).should.equal(view['order']['last_name']);
						});

						it ('updates order.last_name when textinput.text changes', function () :void
						{
							view['order_last_name'].text = 'Roberts';
							view['order_last_name'].display_object.dispatchEvent(new Event('change'));
							so(view['order']['last_name']).should.equal(view['order_last_name'].text);
						});
					});

					describe ('using combo_box_for("order", "state", "states")', function () :void
					{
						it ('creates a ComboBox with id "order_state"', function () :void
						{
							so(view['order_state']).should.be.a.kind_of(ComboBoxHelper);
						});

						it ('assigns the combobox a name of "order_state"', function () :void
						{
							so(view['order_state'].name).should.equal('order_state');
						});

						//it ('sets combobox.selectedItem equal to order.state', function () :void
						//{
						//	Logger.info("view['order']: " + view['order']);
						//	Logger.info("view['order']['state']: " + view['order']['state']);
						//	Logger.info("view['order_state']: " + view['order_state']);
						//	Logger.info("view['order_state'].selectedItem: " + view['order_state'].selectedItem);
						//	so(view['order_state'].selectedItem.data).should.equal(view['order']['state'].data);
						//});
						//
						//it ('updates combobox.selectedItem when order.state changes', function () :void
						//{
						//	view['order']['state'] = { label: 'OH', data: 'OH' };
						//	so(view['order_state'].selectedItem.data).should.equal(view['order']['state'].data);
						//});
						//
						//it ('updates order.state when combobox.selectedItem changes', function () :void
						//{
						//	view['order_state'].selectedItem = { label: 'OH', data: 'OH' };
						//	view['order_state'].display_object.dispatchEvent(new Event('change'));
						//	so(view['order']['state'].data).should.equal(view['order_state'].selectedItem.data);
						//});

					});
				});
			});
		}
	}
}