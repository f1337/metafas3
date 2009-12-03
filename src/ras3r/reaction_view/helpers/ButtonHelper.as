package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import ras3r.*;

	use namespace flash_proxy;

	dynamic public class ButtonHelper extends UIComponentHelper
	{
		/**
		*	ButtonHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of ButtonHelper
		**/
		static public var default_options:Hash = new Hash({
            useHandCursor: true
        });

		/**
		*	ButtonHelper.create:
		*		returns a new instance of ButtonHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :ButtonHelper
		{
			return (UIComponentHelper.create(ButtonHelper, options) as ButtonHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	buttonHelper.disabledFormat = textFormat
		*	applies textFormat to "disabledTextFormat" style on button
		*	write-only
		**/
		public function set disabledFormat (fmt:Object) :void
		{
			// use Hash object for hash.apply
			fmt = new Hash(fmt);
			// get default text format
			var tf:Object = this.getStyle('disabledTextFormat');
			tf ||= new TextFormat();
			// update text format
			fmt.apply(tf);
			// apply new textFormat
			this.setStyle('disabledTextFormat', tf);
		}

		/**
		*	buttonHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a Button
		**/
		public var display_object:Button = new MyButton();

		/**
		*	buttonHelper.icon = Class
		*	applies Class to "icon" style on button
		*	write-only
		**/
		public function set icon (icon:Object) :void
		{
			this.setStyle('icon', icon);
		}

		/**
		*	buttonHelper.skin: applies skins to Button
		**/
		public function set skin (skin:Object) :void
		{
			if (skin is String) skin = getDefinitionByName('skins.' + skin.toString());
            var accessors:XMLList = describeType(skin).accessor.(@name != 'prototype');
            for each (var a:XML in accessors)
            {
                this.setStyle(a.@name, skin[a.@name]);
            }
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function ButtonHelper ()
		{
			super(display_object);
		}

		/**
		*	Set up data binding
		**/
		override public function bind_to (object:*, property:String) :void
		{
			// helper responds to changes to object[property]
			object.addEventListener(property + '_change', after_property_change);
		}


		// >>> EVENT HANDLERS
		/**
		*	update text
		**/
		private function after_property_change (e:Object) :void
		{
			// prevent superfluous event firing
			if (e.newValue == this.label) return;
			// update display object
			this.label = e.newValue;
		}
	}
}

import ras3r.*;
class MyButton extends fl.controls.Button
{
	override protected function drawLayout () :void
	{
		super.drawLayout();
		// 8 >> 4 TEXT
		// 12 >> 12 TEXT
		// 8 TEXT
/*		if (icon) icon.x = 8;*/
/*		textField.x = ((icon ? icon.x : 0) + 8);*/

		// vertically center:
		// SEE TextLineMetrics docs
		// textHeight + 2 pixel gutter
		textField.y = Math.round((height - (textField.textHeight + 2)) / 2);
	}
}