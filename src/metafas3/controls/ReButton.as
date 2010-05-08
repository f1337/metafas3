/**********************************************************************
*	Custom Ras3r Button control
*	- snaps TextField placement to pixels
**********************************************************************/
package metafas3.controls
{
	import fl.controls.*;
	import metafas3.*;

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