//
//  <%= class_name %>.as
//
//  Created <%= Date.today.to_s(:db) %>.
//

package models
{
	import metafas3.*;
	import flash.utils.*;

	use namespace flash_proxy;

	// required if you want to use BindingUtils or ChangeWatcher on dynamic properties!
	// curly braces bindings in MXML cause this directive to be created at compile-time,
	// however AS3 runtime bindings do NOT.
	[Bindable("propertyChange")]

	dynamic public class <%= class_name %> extends ReactiveResource
	{
		// mixin static methods, properties during static init
		extend(<%= class_name %>);

		// syntactic sugar for <%= class_name %>.find:
		static public var find:Function;

		/**
		* Blantantly copied from api.rubyonrails.org:
		* Sets the URI of the REST resources to map for this class to the
		* value in the site argument. The site variable is required for
		* ReactiveResource‘s mapping to work.
		*
		* <%= class_name %>.site = 'http://www.example.com';
		**/
		static public var site:String;

		// >>> PUBLIC PROPERTIES
		// >>> PUBLIC METHODS
		public function <%= class_name %> (attributes:* = null) 
		{
			super(attributes);
		}
	}
}