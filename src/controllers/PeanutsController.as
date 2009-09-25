//
//  PeanutsController.as
//
//  Created 2009-09-24.
//  Copyright (c) 2009 Ustrive2, Inc. All rights reserved.
//

package controllers
{
	import com.ustrive2.controllers.*;
	import com.ustrive2.resources.*;
	import com.ustrive2.utils.*;
	import com.ustrive2.views.*;

	import fl.data.*;
	import fl.events.*;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;

	import controllers.*;

	public class PeanutsController extends ApplicationController
	{
		// >>> STATIC PUBLIC METHODS
		// >>> STATIC PUBLIC PROPERTIES

		// >>> PUBLIC PROPERTIES
		// >>> PROTECTED PROPERTIES (incl STATIC)
		// >>> PRIVATE PROPERTIES (incl STATIC)

		// >>> PUBLIC METHODS
		public function create (...args) :void
		{
			render({ template: 'create' });
		}

		public function destroy (...args) :void
		{
			render({ template: 'destroy' });
		}

		public function list (...args) :void
		{
			render({ template: 'list' });
		}

		public function show (...args) :void
		{
			render({ template: 'show' });
		}

		public function update (...args) :void
		{
			render({ template: 'update' });
		}

		// >>> PROTECTED METHODS
		// >>> PRIVATE METHODS
		// >>> EVENT HANDLERS
	}
}