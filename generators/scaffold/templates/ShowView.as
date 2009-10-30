//
//  Show<%= class_name.singularize %>View.as
//
//  Created <%= Date.today.to_s(:db) %>.
//  Copyright (c) <%= Date.today.year.to_s %> Ustrive2, Inc. All rights reserved.
//

package views.<%= class_name.downcase %>
{
	import com.ustrive2.components.*;
	import com.ustrive2.views.*;

	import fl.controls.*;
	import fl.data.*;
	import fl.events.*;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;

	public class Show<%= class_name.singularize %>View extends ReVue
	{
		// >>> PROPERTIES
		public function set <%= class_name.singularize.downcase %> (value:*) :void
		{
			// apply assignments
			info.htmlText = value;
			//info.htmlText = value.content;
		}


		// >>> DISPLAY OBJECTS
		private var info:TextArea;


		// >>> METHODS
		override public function build (w:Number, h:Number) :void
		{
			// put your view code here
			// INSTANTIATION HAPPENS HERE
			// properties set AFTER build()
			info = sprite(TextArea, { condenseWhite: true, height: h, width: w, wordWrap: true });
		}
	}
}