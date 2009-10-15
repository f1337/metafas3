package
{
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import as3spec.*;
	import com.gigya.WildfireTest;
	import controllers.ApplicationControllerTest;
	import controllers.OrdersControllerTest;
	import controllers.ProductsControllerTest;
	import models.domain.OrderTest;
	import models.domain.ProductTest;
	import ras3r.HashTest;
	import ras3r.reaction_view.helpers.BoxHelperTest;
	import ras3r.reaction_view.helpers.ComboBoxHelperTest;
	import ras3r.reaction_view.helpers.HelperTest;
	import ras3r.reaction_view.helpers.ImageHelperTest;
	import ras3r.reaction_view.helpers.RadioButtonGroupHelperTest;
	import ras3r.reaction_view.helpers.RadioButtonHelperTest;
	import ras3r.reaction_view.helpers.TextFieldHelperTest;
	import ras3r.reaction_view.helpers.TextInputHelperTest;
	import ras3r.ReactionControllerTest;
	import ras3r.ReactionViewTest;
	import ras3r.reactive_resource.ResponseTest;
	import views.layouts.ApplicationLayoutTest;
	import views.orders.NewOrderTest;
	import views.orders.PayOrderTest;
	import views.orders.ReviewOrderTest;
	import views.orders.ShowOrderTest;
	import views.orders.SubtotalOrderTest;
	import views.products.ShowProductTest;

	public class AllTests extends Suite
	{
		public function AllTests ()
		{
			add(com.gigya.WildfireTest);
			add(controllers.ApplicationControllerTest);
			add(controllers.OrdersControllerTest);
			add(controllers.ProductsControllerTest);
			add(models.domain.OrderTest);
			add(models.domain.ProductTest);
			add(ras3r.HashTest);
			add(ras3r.reaction_view.helpers.BoxHelperTest);
			add(ras3r.reaction_view.helpers.ComboBoxHelperTest);
			add(ras3r.reaction_view.helpers.HelperTest);
			add(ras3r.reaction_view.helpers.ImageHelperTest);
			add(ras3r.reaction_view.helpers.RadioButtonGroupHelperTest);
			add(ras3r.reaction_view.helpers.RadioButtonHelperTest);
			add(ras3r.reaction_view.helpers.TextFieldHelperTest);
			add(ras3r.reaction_view.helpers.TextInputHelperTest);
			add(ras3r.ReactionControllerTest);
			add(ras3r.ReactionViewTest);
			add(ras3r.reactive_resource.ResponseTest);
			add(views.layouts.ApplicationLayoutTest);
			add(views.orders.NewOrderTest);
			add(views.orders.PayOrderTest);
			add(views.orders.ReviewOrderTest);
			add(views.orders.ShowOrderTest);
			add(views.orders.SubtotalOrderTest);
			add(views.products.ShowProductTest);
		}
	}
}