package metafas3.reaction_view.helpers
{
	import metafas3.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	use namespace flash_proxy;

	dynamic public class FormItemHelper extends UIComponentHelper
	{
		static public var default_options:Hash = new Hash;

		/**
		*	FormItemHelper.create:
		*		returns a new instance of FormItemHelper klass,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static protected function create (klass:Class, options:Object = null) :FormItemHelper
		{
			options = default_options.merge(klass.default_options).update(options);
			return (UIComponentHelper.create(klass, options) as FormItemHelper);
		}


		// >>> PUBLIC PROPERTIES
		public var form:FormHelper;
		public var model:ReactiveResource;
		public var name:String;

		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function FormItemHelper (proxied_object:Object = null)
		{
			super(proxied_object);
		}

		/**
		*	Set up validation binding. Override for data binding.
		*	Use super.bind_to() in subclass to use validation bindings.
		**/
		public function bind_to (object:*, property:String) :void
		{
			// store local reference to the bound model/object
			model = (object as ReactiveResource);

			// store local reference to the bound property
			name = property;

			// helper responds to object[property] validation events
			// use lower priority, so controllers may use stopImmediatePropagation()
			// to prevent background color changes. -12 is an arbitrary index less than -1.
			model.addEventListener(property + '_invalid', after_property_invalid, false, -12);
			model.addEventListener(property + '_valid', after_property_valid, false, -12);


			// HACK? if required == true, applies an ad-hoc
			//	validates_presence_of constraint to model
			if (required)
			{
				Validates.presence_of(object, property, {
					message: 'Please enter a valid {attr}.'
				});

				// SUPER HACK? manually trigger validation to catch nulls?
				model.validate(property);
			}
		}

	}
}