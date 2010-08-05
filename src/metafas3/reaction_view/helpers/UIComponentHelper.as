package metafas3.reaction_view.helpers
{
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	import metafas3.*;

	dynamic public class UIComponentHelper extends FormattableHelper
	{
		/**
		*	UIComponentHelper.default_options:
		*		a Hash of properties to be used as default assigns
		*		to new instances of UIComponentHelper
		**/
		static public var default_options:Hash = new Hash;

		/**
		*	UIComponentHelper.create:
		*		returns a new instance of UIComponentHelper klass,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static protected function create (klass:Class, options:Object = null) :UIComponentHelper
		{
			options = default_options.merge(klass.default_options).update(options);
			return (Helper.create(klass, options, FormattableHelper.create_helper_callback) as UIComponentHelper);
		}



		// >>> PUBLIC PROPERTIES
		/**
		*	helper.antiAliasType = 'advanced' or 'normal'
		*		applies value to proxied_object's textField (if present)
		*		write-only
		**/
		public function set antiAliasType (type:String) :void
		{
			if (hasOwnProperty('textField'))
			{
				try
				{
					this.textField.antiAliasType = type;
				}
				// TextInput chokes when antiAliasType is set
				catch (exception:Object)
				{
					// do nothing
				}
			}
		}

		/**
		*	helper.background: applied to "upSkin" style of UIComponent
		**/
		public function set background (skin:Object) :void
		{
			if (! (skin is Class)) skin = getClassByAlias(skin.toString());
			this.setStyle('upSkin', skin);
		}

		/**
		*	helper.embedFonts = true
		*		applies value to "embedFonts" style on proxied_object
		**/
		public function set embedFonts (flag:Boolean) :void
		{
			this.setStyle('embedFonts', flag);
		}

		/**
		*	helper.embedFonts => getStyle('embedFonts')
		*		retruns proxied_object.getStyle('embedFonts')
		**/
		public function get embedFonts () :Boolean
		{
			return this.getStyle('embedFonts');
		}

		/**
		*	helper.format = textFormat
		*		applies textFormat to "textFormat" style on proxied_object
		*		write-only
		**/
		public function set format (fmt:Object) :void
		{
			// use Hash object for hash.apply
			fmt = new Hash(fmt);
			// get default text format
			var tf:Object = this.getStyle('textFormat');
			tf ||= new TextFormat();
			// update text format
			fmt.apply(tf);
			// apply new textFormat
			this.setStyle('textFormat', tf);
		}

		/**
		*	helper.format => getStyle('textFormat')
		*		returns display_object.defaultTextFormat
		**/
		public function get format () :Object
		{
			return this.getStyle('textFormat');
		}


		/**
		*	helper.invalid = function validation event listener
		**/
		public function set invalid (listener:Function) :void
		{
			proxied_object.addEventListener('invalid', listener);
		}

		/**
		*	helper.required = true/false
		*	hack? used by bind_to to create ad-hoc validation
		*	see bind_to below
		**/
		public var required:Boolean = false;

		/**
		*	helper.sharpness = -400 to 400
		*		applies value to proxied_object's textField (if present)
		*		write-only
		**/
		public function set sharpness (value:Number) :void
		{
			if (hasOwnProperty('textField'))
			{
				try
				{
					this.textField.sharpness = value;
				}
				// TextInput chokes when antiAliasType is set
				catch (exception:Object)
				{
					// do nothing
				}
			}
		}


		/**
		*	helper.skin: applies skins to UIComponents
		**/
		public function set skin (skin:Object) :void
		{
			if (skin is String) skin = getDefinitionByName(skin.toString());
            var accessors:XMLList = describeType(skin).accessor.(@name != 'prototype');
            for each (var a:XML in accessors)
            {
                this.setStyle(a.@name, skin[a.@name]);
            }
		}

		/**
		*	helper.thickness = -200 to 200
		*		applies value to proxied_object's textField (if present)
		*		write-only
		**/
		public function set thickness (value:Number) :void
		{
			if (hasOwnProperty('textField'))
			{
				try
				{
					this.textField.thickness = value;
				}
				// TextInput chokes when antiAliasType is set
				catch (exception:Object)
				{
					// do nothing
				}
			}
		}

		/**
		*	helper.valid = function validation event listener
		**/
		public function set valid (listener:Function) :void
		{
			proxied_object.addEventListener('valid', listener);
		}


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a UI compontent.
		**/
		public function UIComponentHelper (proxied_object:Object = null)
		{
			super(proxied_object);
		}

		public function getStyle (key:String) :Object
		{
			return (proxied_object.hasOwnProperty('getStyle') ? proxied_object.getStyle(key) : null);
		}

		public function setStyle (key:String, value:Object) :void
		{
			if (proxied_object.hasOwnProperty('setStyle'))
			{
				proxied_object.setStyle(key, value);
			}
		}
	}
}
