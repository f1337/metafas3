/*
MVC overview:

MODEL
+ dispatches change events
- all business logic here

VIEW
+ dispatches user input events
- responds to MODEL change events
- modifies ITSELF (not other views!)
 
CONTROLLER
- responds to VIEW user input events
- modifies VIEW and/or MODEL



*/
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
		static public var canvas:DisplayObjectContainer; // ONLY for getting width + height
		static public var container:DisplayObjectContainer; // ONLY for addChild
		static public var site:String = '';

		// >>> PUBLIC PROPERTIES
		public var content:*;
		public var layout:*;
		public var params:Hash;


		//private var rex:Rex;
		static private var views:Object = new Object();


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
			var url:String;
			//url = (Capabilities.playerType == 'StandAlone') ? 'http://localhost:3000' : site;
			url = (Capabilities.playerType == 'StandAlone') ? 'http://www.cartfly.net' : site;
			url += absolute_path;

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

		public function class_name (template:String) :String
		{
			// template: 'products/list'
			// className: 'views.products.ListProductsView'
			var t:Array = template.split('/');
			var className:String = 'views.';
			if (! t[1])
			{
				t[1] = t[0].toString();
				t[0] = controller_name();
			}
			className += t[0] + '.';
			className += Inflector.camelize(t[1]);
			className += Inflector.camelize((t[1].indexOf('list') == -1 ? Inflector.singularize(t[0]) : t[0]));
			className += 'View';
			return className;
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

		//public function get_url (params:Object) :void
		public function get_url () :void
		{
			if (! params.target) params.target = '_blank';
			redirect_to_url(params.url, params.target);
		}

		public function process (action_name:String, params:Hash) :void
		{
			this.params = params;

			if (before_filter(this[action_name]))
			{
				this[action_name]();
			}
		}


/*

_blank MUST be default or sites with allowNetworking=internal will cause error to be thrown on navigateToURL()

*/
		private function redirect_to_url (url:String, target:String = '_blank', count:uint = 0) :void
		{
			var u:URLRequest = new URLRequest(url);

			try
			{
				if (url.indexOf('mailto:') == 0)
				{
					// mailto shouldn't need a target
					navigateToURL(u, target);
				}
				else
				{
					// open URL in target window
					navigateToURL(u, target);
				}
			}
			catch (e:Error)
			{
				Logger.debug('redirect_to_url target ' + target + ', attempt #' + count + ': ' + e.toString());

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

/*		private function hide (...args) :void
		{
			layout.visible = false;
			content.visible = false;
		}
*/
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

		private static function new_view (controller:ReactionController, className:String, options:Object) :*
		{
			var klass:Class = getDefinitionByName(className) as Class;
			var view:* = new klass();

			if (options.hide) view.addEventListener('hide_view', controller[options.hide]);
			if (options.show) view.addEventListener('show_view', controller[options.show]);

			return view;
		}

		// redirect_to({ controller: 'products', action: 'list' });
		public function redirect_to (options:Object) :void
		{
			// default controller name
			if (! options.controller) options.controller = controller_name();
			remove_from_display_list();
			ReactionController.redirect_to(options);
		}

		//protected function layout (template_name:String) :*
		protected function render (options:Object = null, attr:Object = null) :*
		{
			// TODO?: * root.parent.parent ? root.parent.parent.width : stage.stageWidth

			// width/height specified in the options hash of the call to render take precidence
			// width/height specified in the params hash (directly from query string of swf's url) are second
			// followed by stageWidth and stageHeight
			options.width 	= 	options.width ? options.width :
								Environment.params.width ? Environment.params.width :
							 	canvas.hasOwnProperty('stageWidth') ? canvas['stageWidth'] : canvas.width;
//								stage.stageWidth;
							
			options.height 	= 	options.height ? options.height :
								Environment.params.height ? Environment.params.height :
		 						canvas.hasOwnProperty('stageHeight') ? canvas['stageHeight'] : canvas.height;
/*								root.loaderInfo.loader ? root.loaderInfo.loader.height :
								stage.stageHeight;
*/
			var controller:* = render_with_layout(this, options, attr);
			return controller;
		}

		protected static function render_with_layout (me:ReactionController, options:Object = null, attr:Object = null) :*
		{
			// options.template: 'products/list'
			// className: 'views.products.ListProductsView'
			var className:String = me.class_name(options.update ? options.update : options.template);

			// lookup cached view
			var controller:* = views[className];

			// this will store the bounds of the layout if there is one.
			var content_rect:Rectangle;

			// build new view
			// store reference to view so we can remove it later
			if (! controller) views[className] = controller = me;

			// destroy cached view
			if (controller)
			{
				if (controller.layout)
				{
					controller.removeChild(controller.layout);
					controller.layout = null;
				}
				if (controller.content)
				{
					controller.removeChild(controller.content);
					controller.content = null;
				}
			}

			// build new view
			// store reference to view so we can remove it later
			//if (! controller) views[className] = controller = me;

			// render layout
			if (options.layout)
			{
				var lclassName:String = 'views.layouts.';
				lclassName += Inflector.camelize(options.layout);
				lclassName += 'Layout';

				controller.layout = new_view(controller, lclassName, options);
				controller.layout.addEventListener('rendered', controller.after_layout_rendered);
				controller.addChildAt(controller.layout, 0);
			}

			// render new view
			controller.content = new_view(controller, className, options);
			controller.addChild(controller.content);

			// copy passed attributes to view (new or old)
			for (var p:String in attr)
			{
				if (controller.content.hasOwnProperty(p)) controller.content[p] = attr[p];
				if ((p != 'x') && (p != 'y') && controller.layout && controller.layout.hasOwnProperty(p)) controller.layout[p] = attr[p];
			}

			if (controller.layout)
			{
				controller.layout.build(options.width, options.height);
			}
			else
			{
				controller.build_content({ height: options.height, width: options.width, x: 0, y: 0 });
			}

			// fix depth issues by bringing controller to front
			if (controller.parent) controller.parent.setChildIndex(controller, (controller.parent.numChildren - 1));

			// show controller/layout/view stark
			//Logger.info('if something "WONKY" starts happening with views, revert to the old way: ReactionController');
			// if (options.show) controller[options.show]();
			controller.content.show();

			// fire 'render' event
			// doesn't work:
			//me.dispatchEvent(new Event('render_view'));

			// return reference to controller
			return controller;
		}

		protected function update (options:Object = null, attr:Object = null) :void
		{
			update_content(this, options, attr);
		}

		protected static function update_content (me:ReactionController, options:Object = null, attr:Object = null) :void
		{
			// options.template: 'products/list'
			// className: 'views.products.ListProductsView'
			var className:String = me.class_name(options.update ? options.update : options.template);

			// lookup cached view
			var controller:* = views[className];
			if (! controller) return;

			// update cached view
			// copy passed attributes to view (new or old)
			for (var p:String in attr)
			{
				if (controller.content.hasOwnProperty(p)) controller.content[p] = attr[p];
			}
		}


		// >>> PRIVATE METHODS
		// replaces default context menu with custom, empty menu
		// add items to menu with new_context_menu_item()
		private function create_context_menu () :void
		{
			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			var menuItems:Array = new Array();
			
			var cartflyItem:ContextMenuItem = new ContextMenuItem("Learn More About Cartfly");
			var sellitItem:ContextMenuItem = new ContextMenuItem("Learn More About Sellit");

			cartflyItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, goToCartfly);				
			sellitItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, goToSellit);				

			menuItems.push(cartflyItem);
			menuItems.push(sellitItem);

			contextMenu.customItems = menuItems;
		}
		
		private function goToCartfly(e:Event) :void
		{
			redirect_to_url("http://www.cartfly.com");
		}

		private function goToSellit(e:Event) :void
		{
			redirect_to_url("http://www.sellit.com");
		}

		private function build_content (content_rect:Object) :void
		{
			content.x = content_rect.x;
			content.y = content_rect.y;
			content.build(content_rect.width, content_rect.height);
		}


		// >>> EVENT HANDLERS
		protected function after_show () :void
		{
/*			
			// override in child
			DOES *NOT* work!!!!:
			if (layout) build_content(layout.content_bounds_for_layout());
*/		}

		public function after_layout_rendered (e:Event) :void
		{
			build_content(layout.content_bounds_for_layout());
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