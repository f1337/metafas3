package metafas3.reaction_view.helpers
{
	import fl.controls.*;
	import fl.data.*;
	import flash.display.*;
	import flash.text.*;
	import metafas3.*;

	dynamic public class RadioButtonGroupHelper extends Helper
	{
		static public var default_options:Hash = new Hash;

		static public function create (options:Object = null) :RadioButtonGroupHelper
		{
			return (new RadioButtonGroupHelper(options));
		}


		// >>> PRIVATE PROPERTIES
		private var children:Array;
		private var options:Hash = new Hash;


		// >>> PUBLIC PROPERTIES
		public function set dataProvider (dp:DataProvider) :void
		{
			// create radio buttons
			if (dp && dp.length)
			{
				// remove any existing radio buttons from stage:
				if (display_object.numChildren) display_object.removeChildAt(0);

				var radio_options:Hash = new Hash({ group: group });

				children = new Array();

				for (var i:uint = 0; i < dp.length; i++)
				{
					children.push((Helper.create(RadioButtonHelper, radio_options.update({ 
						value:  dp.getItemAt(i).data,
						label:  dp.getItemAt(i).label
					})) as RadioButtonHelper));
				}
				options.children = children;
				display_object.addChild(BoxHelper.create(options).display_object);
			}

		}

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
		public function RadioButtonGroupHelper (opt:Object = null)
		{
			super(display_object);
			options.update(opt);
			group = new RadioButtonGroup(options.remove('name'));
			selectedData = options.remove('selectedData');
			dataProvider = options.remove('dataProvider');
		}

		public function getRadioButtonAt (i:uint) :RadioButtonHelper
		{
			return (children[i] as RadioButtonHelper);
/*			return group.getRadioButtonAt(i);*/
		}
	}
}

