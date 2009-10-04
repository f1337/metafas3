package ras3r
{
	import ras3r.utils.*;

	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;

	public class ReactionController extends Sprite
	{
		static public var asset_host:String = '';
		static public var container:DisplayObjectContainer; // ONLY for addChild

		// >>> PROTECTED PROPERTIES
		protected var params:Hash;

		// >>> PRIVATE PROPERTIES
		private var _bounds:Rectangle;
		private function get bounds () :Rectangle
		{
			// determine bounds
			// return _bounds if already computed
			if (_bounds) return _bounds;

			if (! _bounds)
			{
				_bounds = new Rectangle();

				var container:* = (
					root.parent.parent ? root.parent.parent : root.parent
				);

				_bounds.width = (
					// if Stage
					(container is Stage) ? (
						// use explicit querystring width if present
						(Environment.params.width) ? Environment.params.width : 
						// else use stageWidth
						container['stageWidth']) :
					// not Stage, use width
					container.width
				);

				_bounds.height = (
					// if Stage
					(container is Stage) ? (
						// use explicit querystring height if present
						(Environment.params.height) ? Environment.params.height : 
						// else use stageHeight
						container['stageHeight']) :
					// not Stage, use height
					container.height
				);
			}

			return _bounds;
		}

		private var content:*;
		private var layout:*;


		// >>> STATIC PUBLIC METHODS
		static public function controller (name:String) :*
		{
			var className:String = 'controllers.' + Inflector.camelize(name) + 'Controller';
			var klass:Class = getDefinitionByName(className) as Class;
			var c:ReactionController = new klass();
			container.addChild(c);
			return c;
		}

		//static public function redirect_to (o:Object) :void
		static public function redirect_to (...args) :void
		{
			if (args[0] is Event) args.shift();
			var options:Hash = new Hash(args.shift());
			// create new controller instance by name
			var c:* = controller(options.remove('controller'));
			// invoke controller action via process method
			var action:String = options.remove('action');
			c.process(action, options);
		}

		// takes absolute path, returns String url (proto://host.domain.com/absolute_path)
		static public function url_for (absolute_path:String, subdomain:String = null) :String
		{
			var url:String = asset_host + absolute_path;

			if (subdomain && subdomain.length > 0)
			{
				// for production domains
				url = url.replace('://www.', '://' + subdomain + '.');
				// for local sandboxes
				url = url.replace('://localhost:3000', '://localhost:3000/' + subdomain);
			}

			return url;
		}

		// takes absolute path, returns URLRequest for url
		static public function url_request_for (absolute_path:String, subdomain:String = null) :URLRequest
		{
			return (new URLRequest(url_for(absolute_path, subdomain)));
		}


		// >>> STATIC PRIVATE METHODS
		static private function baseUrl () :String
		{
			return url_for('');
		}


		// >>> PUBLIC METHODS
		public function ReactionController ()
		{
			super();

			// Open security sandbox
			var baseUrl:String = baseUrl();
			Security.allowDomain(baseUrl);
//			Security.allowInsecureDomain(baseUrl);

			// load policy file
//			Security.loadPolicyFile(baseUrl + '/crossdomain.xml');

			// define controller/application context menu
			create_context_menu();
		}

		public function controller_name () :String
		{
			return Inflector.underscore(Inflector.demodulize(getQualifiedClassName(this).replace('Controller', '')));
		}

		// EXPERIMENTAL!!!
		// remove this controller and its children from the display list
		public function remove_from_display_list () :void
		{
			if (parent) parent.removeChild(this);
		}

		public function get_url () :void
		{
			if (! params.target) params.target = '_blank';
			redirect_to_url(params.url, params.target);
		}

		public function process (action_name:String, params:Hash) :void
		{
			this.params = params;

			var action:Function;
			// if action method defined
			if (hasOwnProperty(action_name))
			{
				action = this[action_name]
			}
			// else attempt to render view named action_view
			else
			{
				action = function () :void
				{
					render(action_name);
				};
			}

			if (before_filter(action))
			{
				action();
			}
		}


		/*
		*	_blank MUST be default or sites with allowNetworking=internal
		*	will cause error to be thrown on navigateToURL()
		*/
		private function redirect_to_url (url:String, target:String = '_blank', count:uint = 0) :void
		{
			var u:URLRequest = new URLRequest(url);

			try
			{
				if (url.indexOf('mailto:') == 0)
				{
					// mailto shouldn't need a target
					navigateToURL(u);
				}
				else
				{
					// open URL in target window
					navigateToURL(u, target);
				}
			}
			catch (e:Error)
			{
				Logger.info('redirect_to_url target ' + target + ', attempt #' + count + ': ' + e.toString());

				switch (target)
				{
					case '_blank':
						target = '_top';
						break;
					case '_top':
						target = '_self';
						break;
/*					case '_self':
						break;
*/					default:
						target = '_blank';
						break;
				}

				count++;
				if (count < 3) redirect_to_url(url, target, count);
			}
		}



		// >>> VISUAL EFFECTS
		public function appear (event:Event) :void
		{
			var options:Object = { 
//				ease: "easeOutQuint",
				onComplete: after_show
			};
			TweenManager.appear(this, options);
		}

		public function fade (event:Event) :void
		{
			var options:Object = { 
//				ease: "easeOutQuint",
				onComplete: after_hide,
				onCompleteParams: [ event.target.parent ]
			};
			TweenManager.fade(event.target.parent, options);
		}

		public function grow (event:Event) :void
		{
			this.visible = true;
			var options:Object = { 
//				ease: "easeOutQuint",
				onComplete: after_show
			};
			TweenManager.grow(this, options);
		}

		public function hide_view (...args) :void
		{
			visible = false;
		}

		public function show_view (...args) :void
		{
			visible = true;
		}

		public function shrink (event:Event) :void
		{
			var options:Object = { 
//				ease: "easeOutQuint",
				onComplete: after_hide,
				onCompleteParams: [ { x: x , y: y , width: width, height: height, visible: false } ]
			};
			TweenManager.shrink(this, options);
		}



		// >>> PROTECTED METHODS
		protected function before_filter (f:Function) :Boolean
		{
			return true;
		}

		private function new_view (template:String, options:Hash) :*
		{
			var after_hide:String = (options.hide ? options.remove('hide') : 'hide_view');
			var after_show:String = (options.show ? options.remove('show') : 'show_view');

			var view:DisplayObject = ReactionView.create(template);

			view.addEventListener('hide_view', this[after_hide]);
			view.addEventListener('show_view', this[after_show]);

			return view;
		}

		// redirect_to({ controller: 'products', action: 'list' });
		public function redirect_to (options:Object) :void
		{
			// default controller name
			if (! options.controller) options.controller = controller_name();
			ReactionController.redirect_to(options);
			remove_from_display_list();
		}

		// render('robots/show', { layout: false, width: 100, height: 100 })
		// render('show', { layout: 'monkeys' })
		// render('list')
		protected function render (template:String, options:Object = null) :*
		{
			if (template.indexOf('/') == -1) template = (controller_name() + '/' + template);
			return render_with_layout(template, new Hash(options));
		}

		protected function render_with_layout (template:String, options:Hash) :*
		{
			if (options.height) bounds.height = options.remove('height');
			if (options.width) bounds.width = options.remove('width');

			// render layout
			var layout_template:String = has_layout(options.remove('layout'));
			if (layout_template)
			{
				layout = new_view(('layouts/' + layout_template), options);
				layout.addEventListener('creationComplete', after_layout_rendered);
				addChildAt(layout, 0);
			}

			// render new view
			content = new_view(template, options);
			addChild(content);

			// copy public controller properties to view
			assign_view_properties();

			if (layout)
			{
				if (Logger.verbose) layout.opaqueBackground = 0xddddff;
				layout.scrollRect = bounds;
				layout.build();
			}
			else
			{
				build_content(bounds);
			}

			// fix depth issues by bringing controller to front
			if (parent) parent.setChildIndex(this, (parent.numChildren - 1));

			// show controller/layout/view stark
			content.show();

			// return reference to controller
			return this;
		}


		// >>> PRIVATE METHODS
		private function assign_view_properties () :void
		{
            var properties:XMLList = describeType(this).variable;
			var p:String;
            for (var n:String in properties)
			{
				p = properties.@name[n];
				content[p] = this[p];
				if (layout) layout[p] = this[p];
			}
		}

		// replaces default context menu with custom, empty menu
		// add items to menu with new_context_menu_item()
		private function create_context_menu () :void
		{
			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			var menuItems:Array = new Array();
			contextMenu.customItems = menuItems;
		}
		
		private function build_content (content_rect:Object) :void
		{
			content.x = content_rect.x;
			content.y = content_rect.y;
			if (Logger.verbose) content.opaqueBackground = 0xffdddd;
			content.scrollRect = new Rectangle(0, 0, content_rect.width, content_rect.height);
			content.build();
		}

		private function has_layout (layout:String = null) :String
		{
			// explicit layout: false option
			if (layout === false)
			{
				return null;
			}
			// No layout defined:
			else if (! layout)
			{
				//  First, attempt to locate controller-specific layout
				try
				{
					layout = controller_name();
					getDefinitionByName('views.layouts.' + Inflector.camelize(layout) + 'Layout');
					
				}
				//  If controller-specific layout does not exist,
				//  attempt to use ApplicationLayout
				catch (exception:*)
				{
					try
					{
						layout = 'application';
						getDefinitionByName('views.layouts.' + Inflector.camelize(layout) + 'Layout');
					}
					// ApplicationLayout doesn't exist,
					// proceed as if layout: false was passed
					catch (exception2:*)
					{
						return null;
					}
				}
			}

			return layout;
		}

		// >>> EVENT HANDLERS
		protected function after_show () :void
		{
		}

		public function after_layout_rendered (e:Event) :void
		{
			build_content(layout.bounds);
		}

		protected function after_hide (options:Object) :void
		{
			// override in child
			for (var p:String in options)
			{
				this[p] = options[p];
			}
		}
	}
}