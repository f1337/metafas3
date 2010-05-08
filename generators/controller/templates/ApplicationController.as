//
//  ApplicationController.as
//
//  Created <%= Date.today.to_s(:db) %>.
//

package <%= package_name %>
{
	import metafas3.*;

	import fl.data.*;
	import fl.events.*;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;

	import controllers.*;<% model_classes.each do |model| %>
	import <%= model %>;<% end %>


	public class ApplicationController extends SupervisingController
	{
		// >>> FILTERS
		extend(prototype.constructor);
		public static var before_filter:Function;
	}
}