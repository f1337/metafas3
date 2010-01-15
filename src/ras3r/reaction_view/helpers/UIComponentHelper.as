package ras3r.reaction_view.helpers
{
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	import mx.events.*;
	import ras3r.*;

	dynamic public class UIComponentHelper extends Helper
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
			return (Helper.create(klass, options, create_helper_callback) as UIComponentHelper);
		}

		static private function create_helper_callback (helper:Helper, hoptions:Object) :void
		{
			// is a custom font defined?
			// if so, set default embedFonts = true
			// hoptions.embedFonts = Boolean(hoptions.format && hoptions.format.font && hoptions.embedFonts !== false);

			/**
			*	Advanced anti-aliasing allows font faces to be rendered
			*	at very high quality at small sizes. It is best used
			*	with applications that have a lot of small text.
			*	Advanced anti-aliasing is not recommended for very
			*	large fonts (larger than 48 points).
			**/
			hoptions.antiAliasType = (hoptions.embedFonts && hoptions.format.size <= 48 && hoptions.antiAliasType != 'normal') ? 'advanced' : 'normal';

			// apply textFormat before assigning any text
			// to prevent text rendering errors:
			if (hoptions.format) helper.format = hoptions.remove('format');
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
		*		write-only
		**/
		public function set embedFonts (flag:Boolean) :void
		{
			this.setStyle('embedFonts', flag);
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

		/**
		*	Set up validation binding. Override for data binding.
		*	Use super.bind_to() in subclass to use validation bindings.
		**/
		public function bind_to (object:*, property:String) :void
		{
			// helper responds to object[property] validation events
			// use lower priority, so controllers may use stopImmediatePropagation()
			// to prevent background color changes. -12 is an arbitrary index less than -1.
			object.addEventListener(property + '_invalid', after_property_invalid, false, -12);
			object.addEventListener(property + '_valid', after_property_valid, false, -12);


			// HACK? if required == true, applies an ad-hoc
			//	validates_presence_of constraint to model
			if (required)
			{
				Validates.presence_of(object, property, {
					message: 'Please enter a valid {attr}.'
				});

				// SUPER HACK? manually trigger validation to catch nulls?
				object.validate(property);
			}
		}


		// >>> EVENT HANDLERS
		protected function after_property_invalid (e:ValidationResultEvent) :void
		{
			var newEvent:ValidationResultEvent = new ValidationResultEvent('invalid', false, true);
			newEvent.field = e.field;
			newEvent.results = e.results;
			proxied_object.dispatchEvent(newEvent);

			if (! newEvent.isDefaultPrevented())
			{
				proxied_object.opaqueBackground = 0xff0000;
			}
		}

		protected function after_property_valid (e:ValidationResultEvent) :void
		{
			var newEvent:ValidationResultEvent = new ValidationResultEvent('valid', false, true);
			newEvent.field = e.field;
			proxied_object.dispatchEvent(newEvent);

			if (! newEvent.isDefaultPrevented())
			{
				proxied_object.opaqueBackground = null;
			}
		}
	}
}
