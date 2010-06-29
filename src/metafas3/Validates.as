package metafas3
{
	import mx.events.*;
	import mx.validators.ValidationResult;
	import metafas3.*;

	public class Validates
	{
		// >>> PRIVATE PROPERTIES
		// >>> PUBLIC METHODS
		static public function dispatch_result_event_for (e:PropertyChangeEvent, dispatcher:Object, valid:Boolean = true, message:String = '') :void
		{
			// build validation result event
			var event:ValidationResultEvent = new ValidationResultEvent(e.property + (valid ? '_valid' : '_invalid'));
			// track which property
			event.field = e.property.toString();
			// handle validation error
			if (! valid)
			{
				// INVALID! stop ALL other validators NOW!
				e.stopImmediatePropagation();
				// create the result event:
				event.results = [ new ValidationResult(true, '', 'validationError',
					message.replace('{attr}', Inflector.titleize(e.property.toString()))) ];
			}
			// dispatch validation event
			dispatcher.dispatchEvent(event);
		}

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

			// validator for field
			add_validator(object, attr_names, options, function (e:PropertyChangeEvent) :void {
				var p:String = e.property.toString();
				var valid:Boolean = (object[p] == object[p + '_confirmation']);
				// dispatch event for field
				dispatch_result_event_for(e, object, valid, options.message);
				// IFF valid, dispatch second event to clear field_confirmation errors
				if (valid)
				{
					e.property = (p + '_confirmation');
					dispatch_result_event_for(e, object, valid, options.message);
				}
			});

			// validator for field_confirmation
			var attr_names_confirmation:Array = attr_names.map(function (s:String, index:int, array:Array) :String {
				return s + '_confirmation';
			});

			add_validator(object, attr_names_confirmation, options, function (e:PropertyChangeEvent) :void
			{
				var p:String = e.property.toString();
				var valid:Boolean = (object[p] == object[p.replace('_confirmation', '')]);

				// IFF valid, dispatch event to clear field errors
				if (valid)
				{
					e.property = p.replace('_confirmation', '');
					dispatch_result_event_for(e, object, valid, options.message);
				}
			});
		}

		/**
		* validates_each('first_name', 'last_name', {
		* 	message: 	'is invalid',
		*	allow_null:	false,
		*	allow_blank:false,
		* 	iff: 		function,
		*	unless: 	function
		* }, function (e:PropertyChangeEvent) :Boolean {
		* 	return (e.newValue == 'Bob');
		* })
		**/
		static public function each (object:Object, ...attr_names) :void
		{
			var validator:Function = (extract_options(attr_names) as Function);
			var options:Hash = new Hash(extract_options(attr_names));
			add_validator(object, attr_names, options, validator);
		}

		/**
		* validates_email_format_of('email', {
		* 	message: 	'is invalid',
		*	allow_null:	false,
		*	allow_blank:false,
		* 	iff: 		function,
		*	unless: 	function
		* })
		*
		* TODO: This method is NOT RFC3696-compliant. It is IMPOSSIBLE
		* 	to validate email addresses with regex and comply with most recent RFCs.
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
		*	allow_null:	false,
		*	allow_blank:false,
		* 	iff: 		function,
		*	unless: 	function
		* })
		**/
		static public function format_of (object:Object, ...attr_names) :void
		{
			var options:Hash = new Hash({ message: "{attr} is invalid" }).update(extract_options(attr_names));
			add_validator(object, attr_names, options, function (e:PropertyChangeEvent) :void
			{
				dispatch_result_event_for(e, object, Boolean(e.newValue != null && e.newValue.match(options.using) != null), options.message);
			});
		}

		/**
		* validates_length_of('zip', {
		*	minimum:	5,
		* 	message: 	'must be at least {{count}} characters long',
		* 	iff: 		function,
		*	unless: 	function
		* })
		**/
		static public function length_of (object:Object, ...attr_names) :void
		{
			var options:Hash = new Hash({ message: "{attr} is too short" }).update(extract_options(attr_names));
			add_validator(object, attr_names, options, function (e:PropertyChangeEvent) :void
			{
				dispatch_result_event_for(e, object, Boolean(e.newValue && e.newValue.length >= options.minimum), options.message);
			});
		}

		/**
		* Validates.presence_of(model, 'first_name', {
		* 	message: 	'can\'t be blank',
		* 	iff: 		function,
		*	unless: 	function
		* })
		**/
		static public function presence_of (object:Object, ...attr_names) :void
		{
			var options:Hash = new Hash({ message: "{attr} can't be blank" }).update(extract_options(attr_names));
			add_validator(object, attr_names, options, function (e:PropertyChangeEvent) :void
			{
				dispatch_result_event_for(e, object, Boolean(e.newValue), options.message);
			});
		}


		// >>> PRIVATE METHODS
		static private function add_validator (object:Object, attr_names:Array, options:Hash, validator:Function) :void
		{
			// apply default options
			options = new Hash({ allow_null: false, allow_blank: false }).update(options);

			// add change listeners for validation
			for each (var attr:String in attr_names)
			{
				object.addEventListener((attr + '_validate'), function (e:PropertyChangeEvent) :void
				{
					/**
					 *	Skip validation if value is null
					 *	apply allow_null equality (==) condition. per AS3 reference:
					 *		http://help.adobe.com/en_US/AS3LCR/Flash_10.0/statements.html#null
					 *		"Do not confuse undefined with null. When null and undefined
					 *		are compared with the equality (==) operator, they compare
					 *		as equal. However, when null and undefined are compared
					 *		with the strict equality (===) operator, they compare
					 *		as not equal."
					 *	we *want* the equality (==) comparison,
					 * 	NOT the strict equality (===) comparison
					 */
					if (options.allow_null == true && e.newValue == null) return;

					/**
					 *  Skip validation if value is blank
					 *	apply allow_empty equality (==) condition. per AS3 reference:
					 *		http://help.adobe.com/en_US/AS3LCR/Flash_10.0/package.html#Boolean()
					 *	Boolean(0) returns false, but is a valid input value. we must manually
					 * 	check for strict equality (===) with zero (0) to prevent zero from
					 * 	being treated as "blank"
					 */
					if (options.allow_empty == true && Boolean(e.newValue) == false && e.newValue !== 0) return;

					/**
					 * 	apply optional iff() and unless()
					 *  conditional validation-skip
					 **/
					if (options.iff && (! options.iff())) return;
					if (options.unless && options.unless()) return;

					/**
					 * 	lastly, apply the validator method
					 */
					validator(e);
				});
			}
		}

		// pop() hash or closure from last element of args and return
		static private function extract_options (args:Array) :Object
		{
			return (
				(typeof args[(args.length - 1)]).match(/function|object/) ? args.pop() : {}
			);
		}
	}
}
