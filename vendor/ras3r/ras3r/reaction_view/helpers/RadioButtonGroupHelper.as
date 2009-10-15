package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import fl.data.*;
	import flash.display.*;
	import flash.text.*;
	import ras3r.*;
	import ras3r.utils.*;

	dynamic public class RadioButtonGroupHelper extends Helper
	{
		static public var default_options:Hash = new Hash;

		static public function create (options:Object = null) :RadioButtonGroupHelper
		{
			// create group
			options = new Hash(options);
			var helper:RadioButtonGroupHelper = new RadioButtonGroupHelper(options.remove('name'))
			var radio_options:Hash = new Hash({ group: helper.group });
			helper.selectedData = options.remove('selectedData');

			// create radio buttons
			var dp:DataProvider = options.remove('dataProvider');
			if (dp)
			{
				var children:Array = [];
				for (var i:uint = 0; i < dp.length; i++)
				{
					children.push((Helper.create(RadioButtonHelper, radio_options.update({ 
						label:  dp.getItemAt(i).label
					})) as RadioButtonHelper).display_object);
				}
				helper.display_object.addChild(BoxHelper.vbox(options, children));
			}

			return helper;
		}


		// >>> PUBLIC PROPERTIES
		public var display_object:Sprite = new Sprite();
		public var group:RadioButtonGroup;

		public function get selectedData () :Object
		{
			return group.selectedData;
		}

		public function set selectedData (data:Object) :void
		{
			group.selectedData = data;
		}


		// >>> PUBLIC METHODS
		public function RadioButtonGroupHelper (name:String)
		{
			super(display_object);
			group = new RadioButtonGroup(name);
		}

		public function getRadioButtonAt (i:uint) :RadioButton
		{
			return group.getRadioButtonAt(i);
		}
	}
}

