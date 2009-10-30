//
//  List<%= class_name %>View.as
//
//  Created <%= Date.today.to_s(:db) %>.
//  Copyright (c) <%= Date.today.year.to_s %> Ustrive2, Inc. All rights reserved.
//

package views.<%= class_name.downcase %>
{
	import com.ustrive2.components.*;
	import com.ustrive2.views.*;

	import fl.controls.*;
	import fl.data.*;
	import fl.events.*;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;

	public class List<%= class_name %>View extends ReVue
	{
		// >>> PROPERTIES
		public function set <%= class_name.downcase %> (value:DataProvider) :void
		{
			// apply assignments
			list.dataProvider = value;
		}


		// >>> DISPLAY OBJECTS
		private var list:List;


		// >>> METHODS
		override public function build (w:Number, h:Number) :void
		{
			// put your view code here
			// INSTANTIATION HAPPENS HERE
			// properties set AFTER build()
			list = sprite(List, { height: h, width: w });
			//list = sprite(List, { labelField: 'title', height: h, width: w });
			link_to(list, { action: 'show', <%= class_name.singularize.downcase %>: selected_<%= class_name.singularize.downcase %> });
		}

		private function selected_<%= class_name.singularize.downcase %> () :*
		{
			return list.selectedItem;
		}
	}
}