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
			advancedTracking	:	true,
			defaultContent		:	'',
			height				:	250,
			onClose				:	after_close,
			partner				:	000, // <-- YOUR PARTNER ID GOES HERE
			UIConfig			:	<config baseTheme="v2"><display showDesktop="false" showEmail="true" showBookmark="true" showCloseButton="true"></display><body><controls><snbuttons iconsOnly="true"></snbuttons></controls></body></config>,
			// true: Use FB app
			// false: Post to FB news feed
			useFacebookMystuff	:	false,
			width 				:	200
		};
		private var module_id:String = 'PostModule1';
		private var url:String = 'http://cdn.gigya.com/Wildfire/swf/WildfireInAS3.swf?ModuleID=';
		private var wildfire:DisplayObject;

		public function Wildfire (options:Object = null)
		{
			super();

			// allow cross-domain script for Gigya
			Security.allowDomain('cdn.gigya.com');
			Security.allowInsecureDomain('cdn.gigya.com');

			// merge options into default config
			config = new Hash(config).update(options);

			// load Wildfire remote .swf
			var loader:Loader = new Loader();
			this[module_id] = config;
			loader.contentLoaderInfo.addEventListener('ioError', after_load_error);
			loader.load(new URLRequest(url + module_id));
			wildfire = loader.content;
			addChild(loader);

			addEventListener('addedToStage', after_added_to_stage);
		}

		// >>> PRIVATE METHODS
		private function after_added_to_stage (e:Event) :void
		{
			// generate markup
			config.defaultContent = markup();
		}

		private function after_close (e:Object) :void
		{
			visible = false;
			wildfire['INIT']();
		}

		private function after_load_error (e:Event)  :void
		{
			Logger.info('Wildfire#after_load_error: ' + e);
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
			markup = markup.replace('{height}', bounds.height);
			markup = markup.replace('{width}', bounds.width);
			markup = markup.replace(/\{swf\}/g, Application.application.url);
			return markup;
		}
	}
}


/*    //This code assigns the configurations you set in our site to the Wildfire configuration object
    cfg['width']='340';
cfg['height']='260';
cfg['widgetTitle']='Thunder Lizard';
cfg['advancedTracking']='true';
cfg['useFacebookMystuff']='false';
cfg['partner']='738331';
cfg['UIConfig']='<config baseTheme="v2"><display showDesktop="false" showEmail="true" showBookmark="true" showCloseButton="true"></display><body><controls><snbuttons iconsOnly="true"></snbuttons></controls></body></config>';;

    // set up an event handler for the onClose event, this is called when the Wildfire UI is closed.
    cfg['onClose']=function(eventObj:Object):void{
        mcWF.visible = false;
        ldr.content['INIT']();
        //you can do additional cleanup here
    }
*/