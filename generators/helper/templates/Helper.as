package <%= package_name %>
{
	import fl.controls.*;
	import flash.text.*;
	import flash.utils.*;
	import metafas3.*;

	use namespace flash_proxy;

	dynamic public class <%= class_name %> extends UIComponentHelper
	{
		/**
		*	<%= class_name %>.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of <%= class_name %>
		**/
		static public var default_options:Hash = new Hash;

		/**
		*	<%= class_name %>.create:
		*		returns a new instance of <%= class_name %>,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :<%= class_name %>
		{
			return (UIComponentHelper.create(<%= class_name %>, options) as <%= class_name %>);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	<%= class_name.camelize(:lower) %>.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a <%= class_name.sub('Helper', '') %>
		**/
		public var display_object:<%= class_name.sub('Helper', '') %> = new <%= class_name.sub('Helper', '') %>();


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function <%= class_name %> ()
		{
			super(display_object);
		}
	}
}
