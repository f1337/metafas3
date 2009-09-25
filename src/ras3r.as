package {
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import skins.ras3rSkin;
	
	public class ras3r extends Sprite {

		public function ras3r() {
			addChild(new ras3rSkin.ProjectSprouts() as DisplayObject);
			trace("ras3r instantiated!");
		}
	}
}
