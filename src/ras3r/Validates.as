package ras3r
{
	import mx.events.*;
	import mx.validators.ValidationResult;
	import ras3r.*;

	public class Validates
	{
		// >>> PRIVATE PROPERTIES
		// >>> PUBLIC METHODS
		/**
		* validates_confirmation_of('password', {
		* 	message: 	'should match confirmation',
		* 	iff: 		function,
		*	unless: 	function
		* })
		**/
		static public function confirmation_of (object:Object, ...attr_names) :void
		{
			var options:Hash = new Hash({ message: "{attr} should match confirmation" }).update(extract_options(attr_names));

			// validator for email fields
			add_validator(object, attr_names, options, function (e:Object) :Boolean {
				var p:String = e.property.toString();
				return Boolean(object[p] == object[p + '_confirmation']);
			});

			// validator for email_confirmation fields
			var attr_names_confirmation:Array = attr_names.map(function (s:String, index:int, array:Array) :String {
				return s + '_confirmation';
			});
			add_validator(object, attr_names_confirmation, options, function (e:Object) :Boolean {
				var p:String = e.property.toString();
				return Boolean(object[p] == object[p.replace('_confirmation', '')]);
			});
		}

		/**
		* validates_email_format_of('email', {
		* 	message: 	'is invalid',
		*	allow_nil:	false,
		*	allow_blank:false,
		* 	iff: 		function,
		*	unless: 	function
		* })
		*
		* TODO: This method is NOT RFC3696-compliant. It is IMPOSSIBLE
		* 	to validate email addresses with regex and comply most recent RFCs.
		*	Cal Henderson and Dominic Sayers have provided free PHP algorithms
		*	for testing email address validity against RFC3696. I (mf) prefer the
		*	readability of Cal's method, but either may be translated to AS3.
		*	See the following sites for in-depth analysis and arguments:
		*		+ http://code.iamcal.com/php/rfc822/
		*		+ http://www.dominicsayers.com/isemail/
		**/
		static public function email_format_of (...args) :void
		{
			var options:Object = extract_options(args);
			options.using = /^[^@]{2,}@([^\.]+\.)+\w{2,}$/;
			args.push(options);
			format_of.apply(null, args);
		}

		/**
		* validates_format_of('email', {
		* 	with:		/regex/,
		* 	message: 	'is invalid',
		*	allow_nil:	false,
		*	allow_blank:false,
		* 	iff: 		function,
		*	unless: 	function
		* })
		**/
		static public function format_of (object:Object, ...attr_names) :void
		{
			var options:Hash = new Hash({ message: "{attr} is invalid" }).update(extract_options(attr_names));
			add_validator(object, attr_names, options, function (e:Object) :Boolean {
				return Boolean(e.newValue.match(options.using) != null);
			});
		}

		/**
		* validates_presence_of('first_name', {
		* 	message: 	'can\'t be blank',
		* 	iff: 		function,
		*	unless: 	function
		* })
		**/
		static public function presence_of (object:Object, ...attr_names) :void
		{
			var options:Hash = new Hash({ message: "{attr} can't be blank" }).update(extract_options(attr_names));
			add_validator(object, attr_names, options, function (e:Object) :Boolean {
				return Boolean(e.newValue);
			});
		}


		// >>> PRIVATE METHODS
		static private function add_validator (object:Object, attr_names:Array, options:Hash, validator:Function) :void
		{
			// prepend "{attr}" to message if missing
			if (options.message.indexOf('{attr}') < 0) options.message = '{attr} ' + options.message;

			// add change listeners for validation
			for each (var attr:String in attr_names)
			{
				object.addEventListener((attr + '_validate'), function (e:PropertyChangeEvent) :void {
					// apply optional iff() and unless() conditions
					if (options.iff && (! options.iff())) return;
					if (options.unless && options.unless()) return;

					// perform validation, create result object
					var result:ValidationResult;
					if (! validator(e))
					{
						// INVALID! stop ALL other validators NOW!
						e.stopImmediatePropagation();
						// create the result event:
						result = new ValidationResult(true, '', 'validationError', options.message.replace('{attr}', Inflector.titleize(e.property.toString())));
					}

					// dispatch validation result event
					var event:ValidationResultEvent = new ValidationResultEvent(e.property + (result ? '_invalid' : '_valid'));
					event.field = e.property.toString();
					if (result) event.results = [ result ];
					object.dispatchEvent(event);
				});
			}
		}

		// pop() options from args and return
		static private function extract_options (args:Array) :Object
		{
			return (
				(! (args[(args.length - 1)] is String)) ? args.pop() : {}
			);
		}
	}
}
