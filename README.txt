EARLY ALPHA CODE. INCOMPLETE EXAMPLE BELOW.


package controllers
{
	import ras3r.*;
	import fl.data.*;
	import models.domain.*;

	public class ApplicationController extends ReactionController
	{
		public var skin:Object = {
			background:				'images/background.jpg',
			review_order_button:	'images/review_order_button.png',
			footer_html:			"ras3r &#169; Michael R. Fleet."
		};

		public var order:Order = new Order({
			state:			new DataProvider([ 'AZ', 'OH', 'SC' ]),
		});


		// >>> PUBLIC METHODS
		public function load () :void
		{
			ReactionController.asset_host = Application.application.url.replace(/[^\/\.]+\.swf.*$/, '');
			redirect_to({ controller: 'products', action: 'show' });
		}
	}
}

package controllers
{
	import ras3r.*;
	import fl.events.*;
	import controllers.*;

	public class OrdersController extends ApplicationController
	{
		public function review () :void
		{
			render('review');
		}

		// this method is automatically wired to listen
		// for the "click" event on content.skin_buy_now_button
		public function on_skin_review_order_button_click (e:Event) :void
		{
			var fields:Array = [
				'first_name',
				'last_name', 
				'street',
				'city',
				'state',
				'postal_code',
				'phone',
				'email',
				'card_type',
				'card_number',
				'card_month',
				'card_year'
			];
			// update model properities with values from view
			// TODO: replace with databinding!!!
			for each (var field:String in fields)
			{
				order[field] = content['order_' + field].text;
			}

			redirect_to({ action: 'review' });			
		}

		public function on_skin_tell_friend_button_click (e:Event) :void
		{
			content.gigya.visible = true;
		}
	}
}

package views.layouts
{
	import flash.geom.*;
	import ras3r.*;
	import ras3r.controls.*;

	dynamic public class ApplicationLayout extends ReactionView
	{
		// bounds for rendering view content within the layout
		public var bounds:Rectangle = new Rectangle(24, 24, 372, 369);


		// main layout creation method
		override public function build () :void
		{	
			// background texture
			image_for('skin', 'background', { height: 425, width: 420 });

			text_for('skin', 'footer_html', {
				x: bounds.x,
				y: (this.skin_background.height - 32),
				wordWrap: false,
				format: { 
					color:		0x143970,
					font:		'Glypha',
					size:		10
				}
			});
		}
	}
}

package views.orders
{
	import ras3r.*;
	import ras3r.controls.*;

	dynamic public class NewOrder extends ReactionView
	{
		// main view creation method
		override public function build () :void
		{
			vbox({ padding: 8 },
				label('Billing and Shipping*', { wordWrap: false }),

				vbox({ padding: 2, width: 168 },
					// billing and shipping
					label_for('order', 'first_name', 'First Name'),
					text_input_for('order', 'first_name'),

					label_for('order', 'last_name', 'Last Name'),
					text_input_for('order', 'last_name'),

					label_for('order', 'street', 'Street Address'),
					text_input_for('order', 'street'),

					label_for('order', 'city', 'City'),
					text_input_for('order', 'city'),

					hbox({},
						vbox({ width: 120 },
							label_for('order', 'state', 'State'),
							combo_box_for('order', 'state')
						),
						vbox({ width: 48 },
							label_for('order', 'postal_code', 'ZIP'),
							text_input_for('order', 'postal_code')
						)
					),

					label_for('order', 'phone', 'Phone'),
					text_input_for('order', 'phone'),

					label_for('order', 'email', 'E-Mail Address'),
					text_input_for('order', 'email'),

					label_for('order', 'confirm_email', 'Confirm E-Mail Address'),
					text_input_for('order', 'confirm_email')
				)
			);

			image_for('skin', 'review_order_button', { x: 207, y:324, width: 165, height: 45 });
		}
	}
}