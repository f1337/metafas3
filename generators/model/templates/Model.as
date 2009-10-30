//
//  <%= class_name %>.as
//
//  Created <%= Date.today.to_s(:db) %>.
//

package models
{
	import ras3r.*;
	import flash.utils.*;

	use namespace flash_proxy;

	// required if you want to use BindingUtils or ChangeWatcher on dynamic properties!
	// curly braces bindings in MXML cause this directive to be created at compile-time,
	// however AS3 runtime bindings do NOT.
	[Bindable("propertyChange")]

	dynamic public class <%= class_name %> extends ReactiveResource
	{
		// <%= class_name %>.site = 'http://www.example.com';
		static public var site:String;

		// mixin static methods, properties during static init
		extend(prototype.constructor);
		static public var find:Function; // = ReactiveResource.find;

		// >>> PUBLIC PROPERTIES
		// >>> PUBLIC METHODS
		public function <%= class_name %> (attributes:* = null) 
		{
			super(attributes);
		}
	}
}