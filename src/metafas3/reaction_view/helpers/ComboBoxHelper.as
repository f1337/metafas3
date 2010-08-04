package metafas3.reaction_view.helpers
{
	import fl.controls.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import mx.events.*;
	import metafas3.*;
	import metafas3.controls.*;

	use namespace flash_proxy;

	dynamic public class ComboBoxHelper extends FormItemHelper
	{
		/**
		*	ComboBoxHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of ComboBoxHelper
		**/
		static public var default_options:Hash = new Hash;

		/**
		*	ComboBoxHelper.create:
		*		returns a new instance of ComboBoxHelper,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :ComboBoxHelper
		{
			options = UIComponentHelper.default_options.merge(FormItemHelper.default_options).update(default_options).update(options);
			return (Helper.create(ComboBoxHelper, options, create_helper_callback) as ComboBoxHelper);
		}

		static protected function create_helper_callback (helper:Helper, hoptions:Object) :void
		{
			// apply dataProvider before all other attributes
			helper.dataProvider = hoptions.remove('dataProvider');
			FormattableHelper.create_helper_callback(helper, hoptions);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	comboBoxHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a ComboBox
		**/
		public var display_object:ComboBox = new ReComboBox();

		/**
		*	sets up label clicks to trigger focus
		**/
		public function set label (helper:TextFieldHelper) :void
		{
			helper.display_object.addEventListener('click', function (e:Event) :void
			{
				proxied_object.setFocus();
			});
			
		}

		/**
		*	override "selectedItem" property setter to juggle objects/string interchangeably
		**/
		public function set selectedItem (value:String) :void
		{
			var index:uint = 0;

			if (value)
			{
				// manually lookup item in dataProvider
				var data:Array = this.dataProvider.toArray();

				for (var i:uint = 0; i < data.length; i++)
				{
					if (data[i].data == value)
					{
						setProperty('selectedItem', this.getItemAt(i));
						break;
					}
				}
			}
		}

		public function get selectedItem () :String
		{
			return ((proxied_object.selectedItem && proxied_object.selectedItem.data) ? proxied_object.selectedItem.data.toString() : proxied_object.selectedItem);
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function ComboBoxHelper ()
		{
			super(display_object);
		}

		/**
		*	Set up data binding
		**/
		override public function bind_to (object:*, selection:String) :void
		{
			// infer collection name from selection
			var collection:String = Inflector.pluralize(selection);

			// initialize object[selection] w/ selectedItem, if defined:
			if (selectedItem) 
			{
				object[selection] = selectedItem;
			}
			// set selectedItem w/ current value of object[selection]:
			else if (object[selection] !== null)
			{
				selectedItem = object[selection];
			}

			// helper responds to changes to object[selection]
			object.addEventListener(selection + '_change', after_selection_change);

			// object[selection] responds to changes to display_object.selectedItem
			// "change" fires when value changes by:
			//		* mouse click
			//		* ENTER key (SPACE will not "change", even though the UX appears to change)
			display_object.addEventListener('change', function (e:Object) :void
			{
				// prevent superfluous event firing
				if (object[selection] == selectedItem) return;
				object[selection] = selectedItem;
			});

			// helper responds to changes to object[collection]
			object.addEventListener(collection + '_change', after_collection_change);

			// setup validation handlers
			super.bind_to(object, selection);
		}

		/**
		*	comboBoxHelper.getStyle('textFormat');
		*	returns 'textFormat', 'embedFonts' styles from ComboBox label textField
		*	all other styles are returned from ComboBox itself
		**/
		override public function getStyle (key:String) :Object
		{
			return (key == 'textFormat' ? this.textField : display_object).getStyle(key);
		}

		/**
		*	comboBoxHelper.setStyle('textFormat', textFormat);
		*	applies 'textFormat' and 'embedFonts' styles to both
		*	the ComboBox's label textField and its listItemRenderer
		*	ref: blogs.adobe.com/pdehaan/2008-03/using_embedded_fonts_with_the_3.html
		*	all other styles are applied only to the ComboBox itself
		**/
		override public function setStyle (key:String, value:Object) :void
		{
			if (key == 'textFormat' || key == 'embedFonts')
			{
				display_object.textField.setStyle(key, value);
				display_object.dropdown.setRendererStyle(key, value);
			}
			else
			{
				display_object.setStyle(key, value);
			}
		}


		// >>> EVENT HANDLERS
		/**
		*	update combobox dataProvider
		*	force redraw
		**/
		private function after_collection_change (e:Object) :void
		{
			this.dataProvider = e.newValue;
			display_object.drawNow();
		}

		/**
		*	update combobox selectedItem
		*	force redraw
		**/
		private function after_selection_change (e:Object) :void
		{
			// prevent superfluous event firing
			if (e.newValue == selectedItem) return;

			// update display object
			selectedItem = e.newValue;
			display_object.drawNow();
		}
	}
}




