/**********************************************************************
*	Custom Ras3r Button control
*	- snaps TextField placement to pixels
**********************************************************************/
package ras3r.controls
{
	import fl.controls.*;
	import ras3r.*;

	public class ReButton extends Button
	{
		override protected function drawLayout () :void
		{
			super.drawLayout();

			// adjust vertical center by 1 px:
			if (textField.y != int(textField.y)) Logger.info('*** textField.y: ' + textField.y);
			textField.y++;
		}
	}
}