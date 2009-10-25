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
		// >>> STATIC PROPERTIES
		static public var asset_host:String = '';
		static public var container:DisplayObjectContainer; // ONLY for addChild

		static private var before_filters:Dictionary = new Dictionary;


		// >>> PROTECTED PROPERTIES
		protected var content:*;
		protected var layout:*;
		protected var params:Hash;


		// >>> PRIVATE PROPERTIES
		private var _bounds:Rectangle;
		private function get bounds () :Rectangle
		{
			// calculate bounds once, cache to _bounds
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


		// >>> STATIC PUBLIC METHODS
		static public function append_before_filter (c:Class, name:String) :void
		{
/*			Logger.info('append_before_filter: ' + c + '#' + name);*/
			before_filters[c] ||= new Array;
			before_filters[c].push(name);
		}

		static public function controller (name:String) :*
		{
			var className:String = 'controllers.' + Inflector.camelize(name) + 'Controller';
			var klass:Class = getDefinitionByName(className) as Class;
			var c:ReactionController = new klass();
			container.addChild(c);
			return c;
		}

		// For use ONLY in ReactionController subclasses for static init:
		// extend(prototype.constructor)
		static public function extend (c:Class) :void
		{
			// define before_filter method
			c['before_filter'] = function (...args) :*
			{
				args.unshift(c);
				return ReactionController.append_before_filter.apply(null, args);
			};
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

		// takes path, returns String url (proto://asset_host/path)
		static public function url_for (path:String, subdomain:String = null) :String
		{
			var url:String = '';
			if (path.match(/^\w+:\/\/./) == null)
			{
				url += asset_host;
				if (path.substr(0, 1) != '/') url += '/';
			}
			url += path;

			if (subdomain && subdomain.length > 0)
			{
				// for production domains
				url = url.replace('://www.', '://' + subdomain + '.');
				// for local sandboxes
				url = url.replace('://localhost:3000', '://localhost:3000/' + subdomain);
			}

			return url;
		}

		// takes path, returns URLRequest for url
		static public function url_request_for (path:String, subdomain:String = null) :URLRequest
		{
			return (new URLRequest(url_for(path, subdomain)));
		}


		// >>> PUBLIC METHODS
		public function ReactionController ()
		{
			super();

			// Open security sandbox
			var baseUrl:String = url_for('');
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

			if (apply_before_filters(action))
			{
				action();
			}
		}

		// EXPERIMENTAL!!!
		// remove this controller and its children from the display list
		public function remove_from_display_list () :void
		{
			if (parent) parent.removeChild(this);
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
		private function new_view (template:String, options:Hash) :*
		{
			var after_hide:String = (options.hide ? options.remove('hide') : 'hide_view');
			var after_show:String = (options.show ? options.remove('show') : 'show_view');

			var view:ReactionView = ReactionView.create(template, options) as ReactionView;

			view.addEventListener('hide_view', this[after_hide]);
			view.addEventListener('show_view', this[after_show]);

			addChild(view);

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
			// sanitize input
			if (template.indexOf('/') == -1) template = (controller_name() + '/' + template);
			options = new Hash(options);

			// update bounds with explicit options
			if (options.height) bounds.height = options.remove('height');
			if (options.width) bounds.width = options.remove('width');

			// update options with reference to this controller
			options.controller = this;

			// render layout
			var layout_template:String = has_layout(options.remove('layout'));
			if (layout_template)
			{
				var layout_options:Hash = options.merge({ scrollRect: bounds });
				layout = new_view(('layouts/' + layout_template), layout_options);
			}

			// render view/content
			var view_bounds:Rectangle = (layout ? layout.bounds : bounds);
			var view_options:Hash = options.merge({
				x: view_bounds.x,
				y: view_bounds.y,
				scrollRect: (new Rectangle(0, 0, view_bounds.width, view_bounds.height))
			});
			content = new_view(template, view_options);

			// fix depth issues by bringing controller to front
			if (parent) parent.setChildIndex(this, (parent.numChildren - 1));

			// show controller/layout/view stark
			content.show();

			// return reference to controller
			return this;
		}


		// >>> PRIVATE METHODS
		// replaces default context menu with custom, empty menu
		// add items to menu with new_context_menu_item()
		private function apply_before_filters (f:Function) :Boolean
		{
			var ok:Boolean = true;
			for (var c:* in before_filters)
			{
				if (! (this is c)) continue;
				for (var i:uint = 0; i < before_filters[c].length; i++)
				{
					ok = this[before_filters[c][i]](f);
					if (! ok) break;
				}
				if (! ok) break;
			}
			return ok;
		}

		private function create_context_menu () :void
		{
			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			var menuItems:Array = new Array();
			contextMenu.customItems = menuItems;
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