package metafas3.reaction_view.helpers
{
	import as3spec.*;
	import fl.controls.*;
	import fl.data.*;
	import flash.events.*;
	import metafas3.*;

	public class RadioButtonGroupHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new RadioButtonGroupHelper', function () :void
			{
				it ('provides .create() which returns a new RadioButtonGroupHelper', function () :void
				{
					so(RadioButtonGroupHelper.create()).should.be.a.kind_of(RadioButtonGroupHelper);
				});

				it ('provides .default_options', function () :void
				{
					so(RadioButtonGroupHelper.default_options).should.be.a.kind_of(Object);
				});

				describe ('using radio_buttons_for() with a DataProvider set', function () :void
				{
					const order:Object = {};
					order.shipping_methods = new DataProvider([
						{ data: 'S', label: 'Standard Delivery' },
						{ data: 'G', label: 'Next Business Day Express' },
						{ data: 'F', label: '2nd Business Day Express' }
					]);
					const view:* = ReactionView.create('', { order: order });
					view.radio_buttons_for("order", "shipping_method", order.shipping_methods);
					view.dispatchEvent(new Event('render'));

					it ('provides a RadioButtonGroup for the set', function () :void
					{
						so(view['order_shipping_method']).should.be.a.kind_of(RadioButtonGroupHelper);
					});

					it ('provides a RadioButton for each item in the set', function () :void
					{
						for (var i:uint = 0; i < order.shipping_methods.length; i++)
						{
							so(view['order_shipping_method'].getRadioButtonAt(i)).should.be.a.kind_of(RadioButtonHelper);
							so(view['order_shipping_method'].getRadioButtonAt(i).label).should.match(/Standard|Express/);
							so(view['order_shipping_method'].getRadioButtonAt(i).value).should.match(/[SGF]{1}/);
						}
					});
				});
			});
		}
	}
}