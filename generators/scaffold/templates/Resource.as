//
//  <%= class_name.singularize %>.as
//
//  Created <%= Date.today.to_s(:db) %>.
//  Copyright (c) <%= Date.today.year.to_s %> Ustrive2, Inc. All rights reserved.
//

package resources
{
	import com.ustrive2.resources.*;
	import com.ustrive2.utils.*;
	import flash.utils.*;

	use namespace flash_proxy;

	// required if you want to use BindingUtils or ChangeWatcher on dynamic properties!
	// curly braces bindings in MXML cause this directive to be created at compile-time,
	// however AS3 runtime bindings do NOT.
	[Bindable("propertyChange")]

	dynamic public class <%= class_name.singularize %> extends ReactiveResource
	{
		// mixin classes during static init
		Mixin.mixinResource(prototype.constructor);
		static public var find:Function; // = ReactiveResource.find;


		// >>> PROPERTIES
		// >>> METHODS
		public function <%= class_name.singularize %> (xml:XML = null) 
		{
			super(xml);
		}
	}
}