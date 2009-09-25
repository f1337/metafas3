//
//  <%= class_name %>.as
//
//  Created <%= Date.today.to_s(:db) %>.
//

package <%= package_name %>
{
	import ras3r.controls.*;
	import ras3r.*;

	import fl.controls.*;
	import fl.data.*;
	import fl.events.*;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;

	dynamic public class <%= class_name %> extends ReactionView
	{
		public function <%= class_name %> () :void
/*		override public function build (w:Number, h:Number) :void*/
		{
			super();
		}
	}
}