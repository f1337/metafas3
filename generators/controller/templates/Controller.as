//
//  <%= class_name %>.as
//
//  Created <%= Date.today.to_s(:db) %>.
//

package <%= package_name %>
{
	import ras3r.*;
	import ras3r.utils.*;

	import fl.data.*;
	import fl.events.*;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;

	import controllers.*;<% model_classes.each do |model| %>
	import <%= model %>;<% end %>

	public class <%= class_name %> extends ApplicationController
	{
		// >>> FILTERS
		extend(prototype.constructor);
		public static var before_filter:Function;


		// >>> ACTIONS
		public function show () :void
		{
			render('show');
		}


		// >>> EVENT HANDLERS
	}
}