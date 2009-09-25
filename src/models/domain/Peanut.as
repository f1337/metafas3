//
//  Peanut.as
//
//  Created 2009-09-24.
//

package models.domain
{
	import ras3r.*;
	import flash.utils.*;

	use namespace flash_proxy;

	// required if you want to use BindingUtils or ChangeWatcher on dynamic properties!
	// curly braces bindings in MXML cause this directive to be created at compile-time,
	// however AS3 runtime bindings do NOT.
	[Bindable("propertyChange")]

	dynamic public class Peanut extends ReactiveResource
	{
		// Peanut.site = 'http://www.example.com';
		static public var site:String;

		// mixin static methods, properties during static init
		ReactiveResource.extend(prototype.constructor);
		static public var find:Function; // = ReactiveResource.find;

		// >>> PROPERTIES
		// >>> METHODS
	}
}