package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import flash.text.*;
	import mx.events.*;
	import ras3r.*;
	import ras3r.controls.*;

	dynamic public class ComboBoxHelper extends UIComponentHelper
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
			return (UIComponentHelper.create(ComboBoxHelper, options) as ComboBoxHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	comboBoxHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a ComboBox
		**/
		public var display_object:ComboBox = new ReComboBox();


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

			// helper responds to changes to object[selection]
			object.addEventListener(selection + '_change', after_selection_change);

			// initialize selectedItem with object[selection], if defined
			if (object[selection])
			{
				this.selectedItem = object[selection];
			}

			// object[selection] responds to changes to display_object.selectedItem
			// "change" fires when value changes by:
			//		* mouse click
			//		* ENTER key (SPACE will not "change", even though the UX appears to change)
			display_object.addEventListener('change', function (e:Object) :void
			{
				// prevent superfluous event firing
				if (object[selection] && e.target.selectedItem && object[selection].data == e.target.selectedItem.data) return;
				// update data object
				object[selection] = e.target.selectedItem;
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
		public function getStyle (key:String) :Object
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
		public function setStyle (key:String, value:Object) :void
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
			if (
				// e.newValue defined?
				e.newValue &&
				// and this.selectedItem defined?
				this.selectedItem &&
				(
					// and e.newValue equals this.selectedItem
					e.newValue.hasOwnProperty('data') ?
					(e.newValue.data == this.selectedItem.data) : // compare as objects for XML/JSON support
					(e.newValue == this.selectedItem.data) // compare as string for HTML5 hidden input support
				)
			// then return now to prevent superfluous event firing
			) return;

			// update display object
			this.selectedItem = e.newValue;
			display_object.drawNow();
		}
	}
}




