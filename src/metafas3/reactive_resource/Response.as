package metafas3.reactive_resource
{
	import com.adobe.serialization.json.JSON;
	import flash.utils.*;
	import metafas3.*;

	public class Response
	{
		// >>> PROPERTIES
		private var _body:Object;

		public function get body () :Object
		{
			return _body;
		}

		public function set body (response:Object) :void
		{
			raw = response;

			// parse as JSON if it begins with '{' or '[{'
			if ((response is String) && (response.match(/^[\[\{]/)))
			{
				_body = decode_json(response);
			}
			// <html>?
			else if (response.toString().indexOf('<!DOCTYPE html>') > -1)
			{
				var ignoreWhitespace:Boolean = XML.ignoreWhitespace;
				XML.ignoreWhitespace = false;

				head = XML(response.match(/<head>.*<\/head>/s).toString());
				_body = XML(response.match(/<body>.*<\/body>/s).toString());

				XML.ignoreWhitespace = ignoreWhitespace;
			}
			// default parse as XML
			else
			{
                // embedded XML is passed as a ByteArray
                if (response is ByteArray) response = (new XML(response.readUTFBytes(response.length)));

				// process response as XML
				var result:XML = XML(response);

				// is this RSS or plain-ole XML?
				_body = (result.name() == 'rss') ? decode_rss(result) : decode_xml(result);
			}
		}

		// html <head>, if exists
		public var head:XML;

		// raw response
		public var raw:Object;


		// >>> PUBLIC METHODS
		public function Response (response:Object = null)
		{
			super();
			body = response;
		} 


		// >>> PROTECTED METHODS
		public function decode_json (response:Object) :Object
		{
			//get the raw JSON data and cast to String
			var rawData:String = String(response);

			// decode the data to ActionScript using the JSON API
			var data:Object = (JSON.decode(rawData) as Object);

			return data;
		}

		protected function decode_rss (result:XML) :Object
		{
			// parse <channel>
			return decode_xml_children(result.channel.children(), true).item;
		}

		protected function decode_xml (result:XML) :Object
		{
			// ignore root node, parse child nodes
			var data:Hash = decode_xml_children(result.children());

			var len:int = data.length;
			// empty hash? return null
			if (len == 0) return null;
			// if hash contains a single child of type Array,
			// return the Array instead of { key: [] }
			if (len == 1)
			{
				// values will be null if data.values.shift() does not return Array
				var values:Array = (data.values.shift() as Array);
				if (values) return values;
			}
			// default: return data as-is
			return data;
		}

		protected function decode_xml_children (attrs:XMLList, parse_attributes:Boolean = false) :Hash
		{
			var data:Hash = new Hash();

			var attr:XML;
			for each (attr in attrs)
			{
				var children:XMLList = attr.children();
				var pname:String = attr.localName();

				// don't set null node names!
				if (pname && children.length())
				{
					pname = pname.toLowerCase();
					var pval:Object;
					if (parse_attributes && attr.attributes().length())
					{
						pval = {};
						for each (var attribute:XML in attr.attributes())
						{
							pval[attribute.localName()] = attribute;
/*							pval[attribute.name().toString().replace('@', '')] = attribute;*/
						}
						pval.text = attr.toString();
					}
					else
					{
						pval = (attr.hasSimpleContent() ? children.toString() : decode_xml_children(children, parse_attributes));
					}

					// assign value
					// if keys collide, create an array of values
					if (data[pname])
					{
						// if hash[key] exists, but not yet an array, create the array
						if (! (data[pname] is Array)) data[pname] = [ data[pname] ];
						// append value to hash[key] array
						data[pname].push(pval);
					}
					else
					{
						// first-time assignment
						data[pname] = pval;
					}
				}
			}

			return data;
		}
	}
}