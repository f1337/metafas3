// maybe this should become WildfireHelper?
// or part of a broader GigyaHelper?
package com.gigya
{
	import ras3r.*;

	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;

	dynamic public class Wildfire extends Sprite
	{
		private var config:Object = {
			width 				:	200,
			height				:	250,

			advancedTracking	:	true,
			partner				:	000, // <-- YOUR PARTNER ID GOES HERE
			showCloseButton		:	true,
			UIConfig			:	<config baseTheme="v2"><display showEmail="true" showBookmark="true" codeBoxHeight="auto" showCloseButton="true"></display><body><controls><snbuttons iconsOnly="true"></snbuttons></controls></body></config>,

			// event handlers
			onClose				:	after_close,
			onPostProfile		:	after_post,
			onLoad				:	after_load,

			// content
			contentIsLayout		:	false, // is it a MySpace layout?
			defaultContent		:	markup, // the content to be posted
			// true: Use FB app
			// false: Post to FB news feed
			useFacebookMystuff	:	false
			// You can set different content for each network
			//myspaceContent : '',
			//friendsterContent : '',
			//facebookContent : '',
			//taggedContent : '',
			//bloggerContent : '',
			//hi5Content : '',
			//freewebsContent : '',
			//xangaContent : '',
			//livejurnalContent : '',
			//blackplanetContent : '',
			//piczoContent : '',
			//wordpressContent : '',
			//typepadContent : '',

			//bulletinSubject : '',  // The subject for bulletin messages of your content
			//bulletinHTML : '',   // code for the bulletin, if it is different than the defaultContent

			//facebookURL : '', // If you have your own facebook application you can set it's URL here
		};

		private function get domain () :String
		{
			return ((ssl ? 'cdns' : 'cdn') + '.gigya.com');
		}

		private var loader:Loader = new Loader();
		private var module_id:String = 'PostModule1';
		private var ssl:Boolean = false;
        private var swf:String; // <-- YOUR SWF URL GOES HERE

		private function get url () :String
		{
			return ((ssl ? 'https://' : 'http://') + domain + '/Wildfire/swf/WildfireInAS3.swf?ModuleID=');
		}

		private var wildfire:DisplayObject;

		public function Wildfire (options:Object = null)
		{
			super();

			// hide until requested
			hide();

			// merge options into default config
			// "config" object passed to Gigya may *not* be a Hash
			options = new Hash(options);
            if (options.ssl) ssl = options.remove('ssl');
            if (options.swf) swf = options.remove('swf');
			options.apply(config);

			// allow cross-domain script for Gigya
			Security.allowDomain('cdns.gigya.com');
			Security.allowDomain('cdn.gigya.com');

			// load Wildfire remote .swf
			this[module_id] = config;
			loader.contentLoaderInfo.addEventListener('ioError', after_load_error);
			loader.load(new URLRequest(url + module_id));
			wildfire = loader.content;
			addChild(loader);
		}

		public function hide ()  :void
		{
			visible = false;
		}

		public function show ()  :void
		{
			visible = true;
		}


		// >>> EVENT HANDLERS
		private function after_close (e:Object) :void
		{
			hide();
			wildfire['INIT']();
		}

		private function after_load (e:Object) :void
		{
			Logger.info('Wildfire#after_load! e.type: ' + e.type + ', e.ModuleID=' + e.ModuleID);
		}

		private function after_load_error (e:Event)  :void
		{
			Logger.info('Wildfire#after_load_error: ' + e);
		}

		private function after_post (e:Object) :void
		{
			dispatchEvent(new Event('wildfire_post'));
			Logger.info('Wildfire#after_post! e.type: ' + e.type + ', e.network: ' + e.network + ', e.partnerData: ' + e.partnerData);
		}

		private function markup () :String
		{
			// canvas is Stage or container from another swf
			var canvas:* = (root.parent.parent ? root.parent.parent : root.parent);
			// Stage#width, Stage#height are useless, use stageWidth and stageHeight
			var bounds:Object = {
				height: (canvas.hasOwnProperty('stageHeight') ? canvas.stageHeight : canvas.height),
				width : (canvas.hasOwnProperty('stageWidth') ? canvas.stageWidth : canvas.width)
			};

			var markup:String = (<![CDATA[
			<object 
				type="application/x-shockwave-flash"
				height="{height}" 
				width="{width}"
				data="{swf}">
			  <param name="movie" value="{swf}" />
			  <param name="quality" value="autohigh" />
			</object>
			]]>).toString().replace(/\s+/g, ' ');
			markup = markup.replace('{height}', 426);
			markup = markup.replace('{width}', 420);
			markup = markup.replace(/\{swf\}/g, swf);
			return markup;
		}
	}
}