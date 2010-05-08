/**********************************************************************
*	Custom Ras3r UILoader control
*	- applies LoaderContext to all load()s
**********************************************************************/
package metafas3.controls
{
	import flash.net.*;
	import flash.system.*;
	import fl.containers.*;

	public class ReUILoader extends UILoader
	{
		override public function load (request:URLRequest = null, context:LoaderContext = null) :void
		{
			if (request && (! context))
			{
				context = new LoaderContext(true);
			}

			super.load(request, context);

			// HACK: to allow re-using Image#load
			// if this isn't set here, UILoader#drawLayout() will throw an error
			// b/c UILoader#load set contentInited=true if a DisplayObject exists!
			contentInited = false;
		}
	}
}