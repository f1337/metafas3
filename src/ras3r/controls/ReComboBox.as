/**********************************************************************
*	Custom Ras3r ComboBox control
*	- dispatches "change" event on SPACE BAR if ComboBox label changed
**********************************************************************/
package ras3r.controls
{
	import fl.controls.*;
	import flash.events.*;
	import flash.ui.Keyboard;

	public class ReComboBox extends fl.controls.ComboBox
	{
		// dispatch "change" event on SPACE BAR if ComboBox label changed
		override protected function keyDownHandler (event:KeyboardEvent) :void
		{
			// store the current highlighted cell index
			// the super handler overwrites this value
			var highlighted:int = highlightedCell;

			super.keyDownHandler(event);

			// fire "change" event IFF:
			if (
				// control key is NOT down
				(! event.ctrlKey) &&
				// space bar is down
				event.keyCode == Keyboard.SPACE &&
				// combobox list is closed
				(! isOpen) &&
				// stored cell index is valid
				highlighted > -1
			)
			{
				selectedIndex = highlighted;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}