//
//  <%= class_name %>Controller.as
//
//  Created <%= Date.today.to_s(:db) %>.
//  Copyright (c) <%= Date.today.year.to_s %> Ustrive2, Inc. All rights reserved.
//

package controllers
{
	import com.ustrive2.controllers.*;
	import com.ustrive2.utils.*;

	import fl.data.*;
	import fl.events.*;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;

	import controllers.*;
	import resources.*;
	import views.<%= class_name.downcase %>.*;

	public class <%= class_name %>Controller extends ApplicationController
	{
		// >>> PROPERTIES
		static private var <%= class_name.downcase %>:DataProvider;


		// >>> VIEWS (compiler hacks)
		static private var listView:List<%= class_name %>View;
		static private var showView:Show<%= class_name.singularize %>View;


		// >>> METHODS
		public function list (params:Object) :void
		{
			<%= class_name.downcase %> = <%= class_name.singularize %>.find('all');
			render({ template: 'list' }, { <%= class_name.downcase %>: <%= class_name.downcase %> });
		}

		public function show (params:Object) :void
		{
			render({ template: 'show' }, { <%= class_name.downcase.singularize %>: params.<%= class_name.downcase.singularize %>() });
			//render({ template: 'show', layout: 'panel', hide: 'shrink' }, { <%= class_name.downcase.singularize %>: params.<%= class_name.downcase.singularize %>() });
		}
	}
}