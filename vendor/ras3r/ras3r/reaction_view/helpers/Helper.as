package ras3r.reaction_view.helpers
{
	import mx.utils.ObjectProxy;

	dynamic public class Helper extends ObjectProxy
	{
		// >>> STATIC METHODS
		/**
		*	Helper.create:
		*		returns a new instance of Helper klass,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static protected function create (klass:Class, options:Object = null, closure:Function = null) :Helper
		{
			options = klass.default_options.merge(options);
			var helper:Helper = new klass();

			// execute parent helper closure if defined
			if (closure is Function) closure(helper, options);

			// assign properties from options hash
			options.apply(helper);

			return helper;
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function Helper (proxied_object:Object = null)
		{
			super(proxied_object);
		}
	}
}
