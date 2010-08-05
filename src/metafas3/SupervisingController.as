package metafas3
{
	import com.greensock.TweenLite;
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import metafas3.reaction_view.helpers.*;
	import ru.etcs.utils.FontLoader;

	public class SupervisingController extends Sprite
	{
		// >>> STATIC PROPERTIES
		static public var asset_host:String = '';
		static public var container:DisplayObjectContainer; // ONLY for addChild
		static public var view_path:String = './';

		static private var before_filters:Array = new Array;


		// >>> PROTECTED PROPERTIES
		protected var content:*;
		protected var _layout:*;
		protected var params:Hash;


		// >>> PRIVATE PROPERTIES
		private var _bounds:Rectangle;
		public function get bounds () :Rectangle
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

		public function set bounds (r:Rectangle) :void
		{
			_bounds = r;
		}


		// >>> STATIC PUBLIC METHODS
		static public function append_before_filter (c:Class, name:String) :void
		{
			before_filters.push({ klass: c, name: name });
		}

		static public function prepend_before_filter (c:Class, name:String) :void
		{
			before_filters.unshift({ klass: c, name: name });
		}

		/**
		*	Factory method:
		*	Creates a Controller, adds it to container (swf root), returns ref
		**/
		static protected function controller (name:String) :*
		{
			var className:String = 'controllers.' + Inflector.camelize(name) + 'Controller';
			var klass:Class = getDefinitionByName(className) as Class;
			var c:SupervisingController = new klass();
			container.addChild(c);
			return c;
		}

		// For use ONLY in SupervisingController subclasses for static init:
		// extend(prototype.constructor)
		static public function extend (c:Class) :void
		{
			// define before_filter method
			c['before_filter'] = function (...args) :*
			{
				args.unshift(c);
				return SupervisingController.append_before_filter.apply(null, args);
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
		public function SupervisingController ()
		{
			super();

			// Open security sandbox
			var baseUrl:String = url_for('');

			// NEVER allow Insecure Domain: bad dog!!
			Security.allowDomain(baseUrl);

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

		public function load_fonts (s:*, after_load:Function = null) :void
		{
			var loader:FontLoader = new FontLoader();
			if (s is String) s = SupervisingController.url_request_for(s.toString());
			if (after_load != null) loader.addEventListener('complete', after_load);
			loader.load(s);
		}

		public function map_event_listeners (view:ReactionView) :void
		{
			// for each public controller method named
			// "on_some_element_event" or "after_some_element_event",
			// add event listener some_element
			var element:String;
			var event:String;
			var parts:Array;

			var method:String;
			var methods:XMLList = describeType(this).method.(@name.match(/^(after_|on_)/) != null);
            for (var n:String in methods)
			{
				method = methods.@name[n];
				parts = method.split('_');
				parts.shift(); // drop on_
				event = parts.pop(); // grab _event
				element = parts.join('_');

				// attach on_instance_event and after_instance_event listeners
				if (! element)
				{
					addEventListener(event, this[method], true);
				}
				// attach on_instance_event and after_instance_event listeners
				else if (view.hasOwnProperty(element))
				{
					(((view[element] is Helper) && view[element].display_object) ? view[element].display_object : view[element]).addEventListener(event, this[method]);
				}
			}
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


		/*
		*	_blank MUST be default or sites with allowNetworking=internal
		*	will cause error to be thrown on navigateToURL()
		*/
		public static function redirect_to_url (url:String, target:String = '_blank', count:uint = 0) :void
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
		protected function appear (target:Object, options:Object = null) :void
		{
			options = new Hash(options).update({ alpha: 1 });
			target.alpha = 0;
			tween(target, options);
		}

		private function fade (target:Object, options:Hash) :void
		{
			options.update({ alpha: 0 });
			target.alpha = 1;
			tween(target, options);
		}

		public function hide (target:Object, effect:String = null, options:Object = null) :void
		{
			// hide(target)
			if (! effect) return after_hide(target);
			// hide(target, effect)
			options = new Hash(options).update({ onComplete: after_hide, onCompleteParams: [ target ] });
			this[effect](target, options);
		}

		public function tween (target:Object, options:Object = null) :void
		{
			options = new Hash({ duration: 1 }).update(options);
			TweenLite.to(target, options.remove('duration'), options);
		}

		private function after_hide (target:Object) :void
		{
			target.visible = false;

			// EXPERIMENTAL!!!
			// remove this controller and its children from the display list
			// in *theory*, should schedule this mess for garbage collection?
			if (target.parent) target.parent.removeChild(target);
		}

/*		public function show_view (...args) :void
		{
			visible = true;
		}
*/
		private function slide_in (target:Object, options:Hash) :void
		{
			options.update({ y: target.y });
			target.y = (0 - bounds.height);
			tween(target, options);
		}

		private function slide_out (target:Object, options:Hash) :void
		{
			options.update({ y: bounds.height });
			tween(target, options);
		}


		// >>> PROTECTED METHODS
		private function new_view (template:String, options:Hash) :*
		{
			var view:ReactionView = ReactionView.create(template, options) as ReactionView;
			addChild(view);
			return view;
		}

		// redirect_to({ controller: 'products', action: 'list' });
		public function redirect_to (options:Object) :void
		{
			// default controller name
			if (! options.controller) options.controller = controller_name();
			SupervisingController.redirect_to(options);
			if (_layout) hide(_layout);
			if (content) hide(content);
		}

		// layout('application')
		protected function layout (template:String = '', options:Object = null) :*
		{
			// sanitize input
			options = new Hash(options);

			// update bounds with explicit options
			if (options.height) bounds.height = options.remove('height');
			if (options.width) bounds.width = options.remove('width');

			// update options with reference to this controller
			options.controller = this;

			// render layout
			var layout_template:String = has_layout(template);
/*			var _layout:*;
*/			if (layout_template)
			{
				var layout_options:Hash = options.merge({ scrollRect: bounds });
				_layout = new_view(('layouts/' + layout_template), layout_options);
			}

			return _layout;
		}

		// render('robots/show', { layout: false, width: 100, height: 100 })
		// render('show', { layout: 'monkeys' })
		// render('list')
		// render('http://www.example.com/robots/show/1.html')
		protected function render (template:String, options:Object = null) :*
		{
			// allow _show() to pass layout via params:
			if ((! _layout) && params.layout) layout(params.layout);

			// sanitize input
			if (template.indexOf('/') == -1) template = (controller_name() + '/' + template);
			options = new Hash(options);

			// update bounds with explicit options
			if (options.height) bounds.height = options.remove('height');
			if (options.width) bounds.width = options.remove('width');

			// update options with reference to this controller
			options.controller = this;

			// render view/content
			var view_bounds:Rectangle = (_layout ? _layout.bounds : bounds);
			var view_options:Hash = options.merge({
				x: view_bounds.x,
				y: view_bounds.y
			});
			content = new_view(template, view_options);

			// fix depth issues by bringing controller to front
			if (parent) parent.setChildIndex(this, (parent.numChildren - 1));

			// show controller/layout/view stark
			visible = true;
			dispatchEvent(new Event('show_view'));

			// return reference to controller
			return this;
		}

		// content = _show({ controller: 'home', action: 'show' }, 'appear', { duration: 1 });
/*		options = new Hash({ duration: 1 }).update(options).update({ onComplete: after_hide, onCompleteParams: [ target ] });
		this[effect](target, options);
*/		public function _show (render_options:Object, effect:String = null, tween_options:Object = null) :*
		{
			render_options = new Hash({ controller: controller_name() }).update(render_options);
			tween_options = new Hash({ duration: 1 }).update(tween_options);

			// create new controller instance by name
			var content:* = controller(render_options.remove('controller'));
			// invoke controller action via process method
			var action:String = render_options.remove('action');

			if (effect)
			{
				var f:Function = this[effect];
				content.addEventListener('show_view', function (e:Object) :void
				{
					f(content, tween_options);
				});
			}

			content.bounds = (_layout ? _layout.bounds : bounds);
			content.process(action, render_options);

			return content;
		}



		// >>> PRIVATE METHODS
		// replaces default context menu with custom, empty menu
		// add items to menu with new_context_menu_item()
		private function apply_before_filters (f:Function) :Boolean
		{
			var ok:Boolean = true;
			for each (var filter:Object in before_filters)
			{
				var c:* = filter.klass;
				if (! (this is c)) continue;
				ok = this[filter.name](f);
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
			if (layout === false || layout == 'false')
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
	}
}