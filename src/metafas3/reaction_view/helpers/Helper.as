package metafas3.reaction_view.helpers
{
	import mx.utils.ObjectProxy;
	import metafas3.*;

	dynamic public class Helper extends ObjectProxy
	{
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

			// parse CSS styles from options
			if (options.style) style_to_options(options);

			// execute parent helper closure if defined
			if (closure is Function) closure(helper, options);

			// assign properties from options hash
			options.apply(helper);

			return helper;
		}



		/**
		*	helper.x => 120
		*	=> helper.left = 120
		*	for CSS compatibility
		**/
		public function get left () :Number
		{
			return this.x;
		}

		/**
		*	helper.left = 120
		*	=> helper.x = 120
		*	for CSS compatibility
		**/
		public function set left (n:Number) :void
		{
			this.x = n;
		}

        /**
        *   placeholder for position: absolute/relative/inline CSS property
        **/
		public var position:String;

        /**
        *   reference to proxied object
        **/
        public var proxied_object:Object;

		/**
		*	helper.style = String
		*	for CSS compatibility
		**/
		static protected function style_to_options (options:Object) :Object
/*		public function set style (s:String) :void*/
		{
			// parse CSS inline syntax
			// left: 290px; top: 400px;
			var styles:Array = options.remove('style').match(/([\w\-]+):\s*([^\;]+)/g);
			// parse each style into params + values
			var args:Array;
			for each (var style:String in styles)
			{
				// split style into name/value pair
				// left: 290px => [ 'left', '290px' ]
				args = style.split(/:\s*/);

				// sanitize key
				// strip "-metafas3-" style prefix
				args[0] = args[0].replace(/\-\w*as3\w*\-/, '');
				// convert dashed-css-syntax to camelizedMethodSyntax
				args[0] = Inflector.camelize(args[0].replace(/\-/g, '_'), false);

				// sanitize value
				// strip 'px', 'pt' units
				args[1] = args[1].replace(/^([\-\d]+)(px|pt)$/, '$1');
				// strip enclosing quotes
				args[1] = args[1].replace(/^[\"\']([^\'\"]+)[\'"]$/, '$1');

				options[args[0]] = (args[1] == 'false' ? false : args[1]);
				//logger.info(args[0] + ' = ' + args[1]);
			}
			return options;
		}

		/**
		*	helper.y => 120
		*	=> helper.top = 120
		*	for CSS compatibility
		**/
		public function get top () :Number
		{
			return this.y;
		}

		/**
		*	helper.top = 120
		*	=> helper.y = 120
		*	for CSS compatibility
		**/
		public function set top (n:Number) :void
		{
			this.y = n;
		}

		/**
		*	helper.visibile = true or false;
		*	=> helper.visibility => 'visible' or 'hidden'
		*	for CSS compatibility
		**/
		public function get visibility () :String
		{
			return (this.visible ? 'visible' : 'hidden');
		}

		/**
		*	helper.visibility = 'visible' or 'hidden'
		*	=> helper.visibile = true or false;
		*	for CSS compatibility
		**/
		public function set visibility (s:String) :void
		{
			this.visible = Boolean(s == 'visible');
		}


		/**
		*	Constructor. Proxies a display_object.
		**/
		public function Helper (proxied_object:Object = null)
		{
			super(proxied_object);
            this.proxied_object = proxied_object;
		}
	}
}
