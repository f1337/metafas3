//
//  <%= class_name %>.as
//
//  Created <%= Date.today.to_s(:db) %>.
//  Copyright (c) <%= Date.today.year.to_s %> Ustrive2, Inc. All rights reserved.
//

package <%= package_name %>
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

	public class <%= class_name %> extends ReVue
	{
		// >>> STATIC PUBLIC METHODS
		// >>> STATIC PUBLIC PROPERTIES

		// >>> PUBLIC PROPERTIES
		// >>> PROTECTED PROPERTIES (incl STATIC)
		// >>> PRIVATE PROPERTIES (incl STATIC)

		// >>> PUBLIC METHODS
		override public function build (w:Number, h:Number) :void
		{
			// put your view code here
			// INSTANTIATION HAPPENS HERE
			// properties set AFTER build()
		}


		// >>> PROTECTED METHODS
		// >>> PRIVATE METHODS
		// >>> EVENT HANDLERS
	}
}