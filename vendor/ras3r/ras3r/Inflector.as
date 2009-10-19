//
//  Inflector
//
//  Created by Michael Fleet on 2007-08-31.
//  Inspired by (and in part unabashedly copied from) Ruby on Rails' Inflector class
//

package ras3r
{
	public class Inflector
	{
		// active_record => ActiveRecord
		// active_record/errors => ActiveRecord::Errors
		public static function camelize (lower_case_and_underscored_word:String, first_letter_in_uppercase:Boolean = true) :String
		{
			if (first_letter_in_uppercase)
			{
				var f1:Function = function (...args) :String
				{
					return ('::' + String(args[1]).toUpperCase());
				}
				var f2:Function = function (...args) :String
				{
					return String(args[2]).toUpperCase();
				}
				return lower_case_and_underscored_word.replace(/\/(.?)/g, f1).replace(/(^|_)(.)/g, f2);
			}
			else
			{
				return (lower_case_and_underscored_word.slice(0, 1) + camelize(lower_case_and_underscored_word).slice(1));
			}
		}

		/**
		*	capitalize()
		*	Converts the first character to uppercase and the remainder to lowercase.
		*
		*	Example:
		*		Inflector.capitalize('washington') #=> "Washington"
		**/
		public static function capitalize (word:String) :String
		{
			if (word.length > 0)
			{
				return word.slice(0, 1).toUpperCase() + word.slice(1).toLowerCase();
			}
			else
			{
				return '';
			}
		}

		public static function demodulize (qualifiedClassName:String) :String
		{
			return qualifiedClassName.replace(/^.*::/, '');
		}

		/**
		*	Inflector.humanize(lower_case_and_underscored_word)
		*	Capitalizes the first word and turns underscores into spaces and strips a trailing "_id", if any.
		*	Like titleize, this is meant for creating pretty output.
		*
		*	Examples:
		* 		Inflector.humanize("employee_salary") # => "Employee salary"
 		*		Inflector.humanize("author_id")       # => "Author"
 		**/
		public static function humanize (word:String) :String
		{
			return capitalize(word.replace(/_id$/, '').replace(/_/g, ' '));
		}
		
		// TODO: extend to support exceptions, uncountables like RoR
		public static function pluralize (word:String) :String
		{
			if (word.match(/(.+)ry$/i))
			{
				return word.replace(/(.+)ry$/i, '$1ries');
			}
			else
			{
				return word + 's';
			}
		}

		public static function restify (className:String) :String
		{
			return pluralize(underscore(className));
		}

		// TODO: extend to support exceptions, uncountables like RoR
		public static function singularize (word:String) :String
		{
			return word.replace(/(.+)ries$/i, '$1ry').replace(/(.+)s$/i, '$1');
		}

		/**
		*	titleize(word)
		*	Capitalizes all the words and replaces some characters in the string to create a nicer looking title.
		*	titleize is meant for creating pretty output.
		*	titleize is also aliased as as titlecase.
		*
		*	Examples:
		*		Inflector.titleize("man from the boondocks") # => "Man From The Boondocks"
		*		Inflector.titleize("x-men: the last stand")  # => "X Men: The Last Stand"
		**/
		public static function titleize (word:String) :String
		{
			var f:Function = function (...args) :String
			{
				return String(args[1]).toUpperCase();
			}
			return humanize(underscore(word)).replace(/\b([a-z])/g, f);
		}
		public static var titlecase:Function = titleize;

		public static function underscore (CamelCaseWord:String) :String
		{
			return CamelCaseWord.replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2').replace(/([a-z\d])([A-Z])/g, '$1_$2').replace('-', '_').toLowerCase();
		}
	}
}
