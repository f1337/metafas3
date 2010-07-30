/**
* 	TODO:
*		form.formvarname	=> lookup form element by name
*		form[formvarename]	=> ditto
**/
package metafas3.reaction_view.helpers
{
	import com.yahoo.astra.fl.containers.*;
	import com.yahoo.astra.fl.containers.layoutClasses.*;
	import com.yahoo.astra.layout.*;
	import metafas3.*;
	import metafas3.reactive_resource.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	use namespace flash_proxy;

	dynamic public class FormHelper extends LayoutHelper
	{
		static public var default_options:Hash = new Hash;

		/**
		*	FormHelper.create:
		*		returns a new instance of LayoutHelper klass,
		*		with options hash merged into default_options hash
		*		and applied as property assignments to the new instance
		**/
		static public function create (options:Object = null) :FormHelper
		{
			// create the helper
			return (LayoutHelper.create(FormHelper, options) as FormHelper);
		}


		// >>> PUBLIC PROPERTIES
		/**
		*	form action property (url)
		**/
		public var action:String;

		/**
		*	look for submit buttons among children
		**/
		override public function set children (a:Array) :void
		{
			_elements = new Array();
			var buttons:Array = submit_buttons_from_children(a);

			for each (var button:ImageButtonHelper in buttons)
			{
				button.buttonMode = true;
				button.display_object.addEventListener('click', function (e:MouseEvent) :void
				{
					submit();
				});
			}

			super.children = a;
		}

		/**
		*	formHelper.display_object
		*	Every Helper is expected to provide a display_object.
		*	This one is a FlowPane
		**/
		public var display_object:FlowPane = new FlowPane;

		/**
		*	formHelper.elements
		*	an array of form input elements ala the DOM
		**/
		private var _elements:Array = new Array;
		public function get elements () :Array
		{
			return _elements;
		}

		/**
		*	form method (GET or POST)
		**/
		public var method:String = 'POST';


		// >>> PUBLIC METHODS
		/**
		*	Constructor. Proxies a display_object.
		**/
		public function FormHelper (proxied_object:Object = null)
		{
			super(proxied_object);
		}

		/**
		*	dispatch the "submit" event
		**/
		public function submit () :void
		{
			var event:NetStatusEvent = new NetStatusEvent('submit', false, true, this);
			display_object.dispatchEvent(event);

			if (! event.isDefaultPrevented())
			{
				// send the form
				var request:Request = new Request(method, action);

				// Set the data property to the dataToSave XML instance to send the XML
				// data to the server
				request.data = new URLVariables();

				for each (var elem:FormItemHelper in elements)
				{
					if (elem.model !== null)
					{
						var root:String = Inflector.demodulize(getQualifiedClassName(elem.model));

						// populate values
						for (var i:String in elem.model.attributes)
						{
			                request.data['data[' + root + '][' + i + ']'] = elem.model[i];
						}
					}
				}

				// When the server response is finished downloading, invoke handleResponse
				request.addEventListener('complete', after_submit);
				request.addEventListener('ioError', after_submit_failed);

				// Finally, send off the XML data to the URL
				request.load();
			}
		}


		// >>> PRIVATE METHODS
		/**
		*	Recursively processes child (display) objects,
		*	adds FormItems to elements collection,
		*	and returns array of child ImageHelpers
		**/
		private function submit_buttons_from_children (children:Array) :Array
		{
			var buttons:Array = [];
			for each (var child:* in children)
			{
				if (child is LayoutHelper)
				{
					buttons.push.apply(buttons, submit_buttons_from_children(child.children));
				}
				else if (child is FormItemHelper)
				{
					// assign reference to this FormHelper
					child.form = this;
					// add to elements collection
					_elements.push(child);
					// wire submit buttons to fire the submit event
					if (child is ImageButtonHelper)
					{
						buttons.push(child);
					}
				}
			}
			return buttons;
		}


		// >>> EVENTS
		private function after_submit (e:Event) :void
		{
			logger.info('after_submit!');
		}

		private function after_submit_failed (e:Event) :void
		{
			logger.info('after_submit_failed!');
			logger.dump(e);
		}
	}
}