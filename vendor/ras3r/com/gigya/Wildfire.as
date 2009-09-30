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

	public class Wildfire extends Sprite
	{
		private var config:Object = {
			defaultContent	:	'', // <-- YOUR EMBED CODE GOES HERE
			height			:	250,
			width 			:	200,
			partner			:	000, // <-- YOUR PARTNER ID GOES HERE
			UIConfig		:	<config baseTheme="v2"><display showDesktop="false" showEmail="true" showBookmark="true" showCloseButton="true"></display><body><controls><snbuttons iconsOnly="true"></snbuttons></controls></body></config>
		};
		private var module_id:String = 'PostModule1';
		private var url:String = 'http://cdn.gigya.com/Wildfire/swf/WildfireInAS3.swf?ModuleID=';
		private var wildfire:MovieClip = new MovieClip();

		public function Wildfire (options:Object = null)
		{
			super();

			// allow cross-domain script for Gigya
			Security.allowDomain('cdn.gigya.com');
			Security.allowInsecureDomain('cdn.gigya.com');

			// merge options into default config
			config = new Hash(config).update(options);

			// add Wildfire container to stage
			addChild(wildfire);

			// load Wildfire remote .swf
			var loader:Loader = new Loader();
			wildfire[module_id] = config;
			loader.load(new URLRequest(url + module_id));
			wildfire.addChild(loader);
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