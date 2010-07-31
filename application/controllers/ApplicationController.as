package controllers
{
	import metafas3.*;
	import metafas3.reaction_view.helpers.*;

	import fl.data.*;
	import fl.events.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	import mx.events.*;

	import controllers.*;
	import flash.printing.*;

	dynamic public class ApplicationController extends SupervisingController
	{
		// >>> PUBLIC PROPERTIES
		// >>> PROTECTED PROPERTIES
        protected var errors:Hash = new Hash;
        
		// popup panel
		static protected var _popup:*;

		// loading indicator
		static protected var _waiting:Sprite;
		protected function set waiting (wait:Boolean) :void
		{
			if (! _waiting)
			{
				// missing waiting image error trap
				if (! content['campaign_waiting']) return;

				_waiting = new Sprite();
				_waiting.addChild(content['campaign_waiting_bg'].display_object);
				_waiting.addChild(content['campaign_waiting'].display_object);
				content['campaign_waiting_bg'].visible = true;
				content['campaign_waiting'].visible = true;
			}

			if (wait) addChild(_waiting);

			_waiting.visible = wait;
		}

		public function find_fonts (callback:Function) :Boolean
		{
			// load template-specific runtime fonts
			load_fonts(SupervisingController.view_path.replace('/views/', '/fonts/fonts.swf?dt=' + (new Date()).getTime()), function (e:Event) :void
			{
				callback();
			});

			// wait to render until runtime fonts are loaded
			return false;
		}

		public function load () :void
		{
			// load environment
			Environment.load('');

			// if command-line path, update ENV
			if (params.path) ENV['PATH'] = params.path;
			if (! ENV['PATH']) throw(new Error('You must provide a path!'));
			
			// build base url
			ENV['BASE_URL'] = ENV['HOST'] + ENV['PATH'];

			// >>> set base rendering options for debug mode
			if (params.debug && params.debug_layout !== 'false')
			{
				LayoutHelper.default_options.update({
					debugMode: true
				});
			}
			
			// set the asset host for images, etc
			SupervisingController.asset_host = ENV['HOST'] + ENV['ASSET_HOST'];
			SupervisingController.view_path = SupervisingController.asset_host + '/views/'
			
			// load fonts
			find_fonts(function(e:Event = null) :void{
				// nothing to do here!
			});
		
			// render the url
			render(ENV['BASE_URL']);
		}


		// >>> PROTECTED METHODS
		protected function popup (view:String) :*
		{
			// hide existing popup
			if (_popup) hide(_popup);
			// show waiting indicator
			waiting = true;
			// show the popup
			_popup = _show({ controller: 'popup', action: view });
			return _popup;
		}

		// >>> EVENT HANDLERS
		// generic event listener: MUST BE PUBLIC!
		protected function after_invalid (e:ValidationResultEvent) :void
		{
			errors[e.field] = e.results[0].errorMessage;
			logger.info('after_invalid: ' + e.field + ', message: ' + errors[e.field] + ', errors.length: ' + errors.length);

			// TODO: use custom highlight color instead of default red highlight:
			e.preventDefault();
			// content['order_' + e.field].opaqueBackground = skin.pink;
		}

		protected function after_valid (e:ValidationResultEvent) :void
		{
			errors.remove(e.field);
			logger.info('after_valid: ' + e.field + ', errors.length: ' + errors.length);
		}

		public function on_link (e:TextEvent) :void
		{
			// ignore empty links
			if (! e.text) return;

			// ignore popups
			if (e.text.indexOf('/views/') >= 0) return;

			// render relative URLs in-Flash
			if (e.text.indexOf('http://') == -1)
			{
				waiting = true;
				hide(content);
				logger.info(e.text);
				render(ENV['HOST'] + e.text);
			}
			// open absolute URLs externally
			else
			{
				redirect_to_url(e.text);
			}
		}
		
		public function on_print_btn_click (e:Object) :void
		{
			e.preventDefault();
			var myPrintJob:PrintJob = new PrintJob();
	
			myPrintJob.start();
			myPrintJob.addPage(this); 
			myPrintJob.send();
			
		}

		public function on_submit (e:NetStatusEvent) :void
		{
			logger.info('on_submit!');

			if (errors.values.length)
			{
				// STOP the form submission!!
				e.preventDefault();
				logger.dump(errors.values);
			}

			logger.info('validated!');
			waiting = true;
		}


		// >>> EVENTS
		private function after_send_form (e:Event) :void
		{
			waiting = false;
			logger.info('after_send_form!');
		}
	}
}