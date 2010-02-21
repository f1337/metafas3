package ras3r
{
	import flash.display.*;
	import flash.net.*;
	import flash.system.*;

	public class Tracker
	{
		// >>> PUBLIC PROPERTIES
		// Account String. Appears on all requests.
		// ex: UA-2202604-2
		public static var account:String = '';

		// base tracking URL
		public static var base:String = 'www.google-analytics.com/__utm.gif?';

		// character set encoding for the browser.
		// ex: ISO-8859-1, UTF-8
		public static var encoding:String = '';

		// application hostname
		// "games.example.com"
		private static var _hostname:String = '';
		public static function set hostname (s:String) :void
		{
			_hostname = s;
			hash();
		}

		// use SSL?
		public static var ssl:Boolean = false;

		// user-defined segment string
		// "vendor_123"
		// "any_arbitrary_data"
		public static var segment:String = '';


		// >>> PRIVATE PROPERTIES
		private static var _cookie:String;
		private static function get cookie () :String
		{
			if (! _cookie)
			{
				_cookie = (
				'__utma=' +
					_hash + '.' +
					session_id + '.' +
					timestamp_first_visit + '.' +
					timestamp_last_visit + '.' +
					timestamp_this_visit + '.' +
					visit_count + ';+' +
				'__utmz=' +
					_hash + '.' +
					timestamp_first_visit +
					'.1.1.utmcsr=facebook|utmccn=offthewall|utmcmd=wall/;+' +
				'__utmv=' +
					_hash + '.' +
					segment
				);
			}

			return _cookie;
		}

		// 9.0 r48
		private static function get flash_player_version () :String
		{
			return Capabilities.version.replace(/^\w* (\d*),(\d*),(\d*),\d*$/, "$1.$2 r$3");
		}

		// Google Analytics tracking code version
		private static var GA_version:String = '4.5.9';

		private static var loader:Loader = new Loader();

		private static function get screen_resolution () :String
		{
			return (
				Capabilities.screenResolutionX.toString() +
				'x' +
				Capabilities.screenResolutionY.toString()
			);
		}

		// generate a mock session id
		// session-persistent value between 1000000000000000000 and 9999999999999999999
		private static var _session_id:String;
		private static function get session_id () :String
		{
			if (! _session_id)
			{
				_session_id = uid(19);
			}

			return _session_id;
		}

		// UNIX timestamp of FIRST visit to *this* swf/campaign EVER
		private static var timestamp_first_visit:String = '1252000967';

		// UNIX timestamp of MOST RECENT PRIOR ("last") visit to *this* swf/campaign
		private static var timestamp_last_visit:String = '1252000968';

		// UNIX timestamp of the CURRENT visit to *this* swf/campaign
		private static var timestamp_this_visit:String = '1252000969';

		// Google Analytics full url with protocol
		private static function get url () :String
		{
			return ((ssl ? 'https' : 'http') + '://' + base);
		}

		// total number of visits for this visitor to this swf/campaign
		private static var visit_count:int = 1;


		// >>> PUBLIC METHODS
		public static function init (p:Object) :void
		{
			(new Hash(p)).apply(Tracker);
		}

		// path can be determined from root.url if not defined
		// title cannot
		// document/page title:
		// "My Widget Title"
		// "List Cheeses"
		// "About: Gorgonzola"
		//
		// document/page path
		// or pseudo-URL representation of "path"
		// "/controller/view"
		// "/path/to/swf"
		// "/root/sprite39/movieclip2"
		public static function page (title:String, path:String = '') :void
		{
			var qs:Array = [];

			// build params hash
			var p:Object = params();

			// inject title, path
			p.utmdt = title;
			p.utmp = path;

			// build querstring
			for (var s:String in p)
			{
				qs.push(s + '=' + encodeURIComponent(p[s]));
			}

			// ping URL
			loader.load(new URLRequest(url + qs.join('&')));
		}

		public static function purchase () :void
		{
			/*
			utmipc
			Product Code. This is the sku code for a given product.
			utmipc=989898ajssi

			utmipn
			Product Name, which is a URL-encoded string.
			utmipn=tee%20shirt

			utmipr
			Unit Price. Set at the item level. Value is set to numbers only in U.S. currency format.
			utmipr=17100.32

			utmiqt
			Quantity.
			utmiqt=4

			utmiva
			Variations on an item. For example: large, medium, small, pink, white, black, green. String is URL-encoded.
			utmiva=red;

			utmtci
			Billing City
			utmtci=San%20Diego

			utmtco
			Billing Country
			utmtco=United%20Kingdom

			utmtid
			Order ID, URL-encoded string.
			utmtid=a2343898

			utmtrg
			Billing region, URL-encoded string.
			utmtrg=New%20Brunswick

			utmtsp
			Shipping cost. Values as for unit and price.
			utmtsp=23.95

			utmtst
			Affiliation. Typically used for brick and mortar applications in ecommerce.
			utmtst=google%20mtv%20store

			utmtto
			Total. Values as for unit and price.
			utmtto=334.56

			utmttx
			Tax. Values as for unit and price.
			utmttx=29.16
			*/
		}


		// >>> PRIVATE METHODS
		// GA hash algorithm from
		// http://www.google.com/support/forum/p/Google+Analytics/thread?tid=626b0e277aaedc3c&hl=en
		private static var _hash:String;
		private static function hash () :void
		{
			var a:int = 1;

			if (_hostname)
			{
				var c:int = 0;
				var o:int;

				a = 0;
				for (var h:int = _hostname.length - 1; h >= 0; h--)
				{
					o = _hostname.charCodeAt(h);
					a = (a << 6 & 268435455) + o + (o << 14);
					c = a & 266338304;
					a = (c != 0 ? (a ^ c >> 21) : a);
				}
			}

			_hash = String(a);
		}

		// http://code.google.com/apis/analytics/docs/tracking/gaTrackingTroubleshooting.html#GIFVars
		private static function params () :Object
		{
			return {
				utmwv:		GA_version,
				utmn:		request_id(),
				utmhn:		_hostname,
				utmcs:		encoding,
				utmsr:		screen_resolution,
				utmsc:		'', // screen color depth, no means to detect (yet)
				utmul:		Capabilities.language,
				utmje:		'', // java-enabled browser? N/A for Flash
				utmfl:		flash_player_version,
				utmdt: 		'', // page title
				utmhid:		'', // visitor's adsense id, not available
				utmr:		'', // referral URL
				utmp:		'', // path
				utmac:		account,
				utmcc:		cookie
			};
		}

		// Random number between 1000000000 and 9999999999
		private static var _request_id:uint;
		private static function request_id () :String
		{
			if (! _request_id)
			{
				_request_id = uint(uid(10));
			}

			_request_id++;

			return _request_id.toString();
		}

		private static function uid (len:int) :String
		{
			// generate a timestamp
			var uid:String = ('00000000' + (new Date().getTime()).toString()).substr(-8);

			// pad the end of the string with random numbers
			var i:int;
			if (uid.length < len)
			{
				for (i = uid.length; i < len; i++)
				{
					uid += Math.floor(Math.random() * 10).toString();
				}
			}
			// chomp the leftmost  digits
			else if (uid.length > len)
			{
				uid = uid.substr(uid.length - len);
			}

			return uid;
		}
	}
}
/*
http://www.google-analytics.com/__utm.gif?utmcc=__utma%3D73423052.243182825886115876.1252000967.1252000968.1252000969.1%3B%2B__utmz%3D73423052.1252000967.1.1.utmcsr%3Dfacebook%7Cutmccn%3Doffthewall%7Cutmcmd%3Dwall%253B%3B%2B__utmv%3D73423052.otwtest_123&utmdt=OTWTest%20-%20123%20-%20Loaded&utmul=en&utmje=&utmr=&utmn=126671888530066247.42411077023&utmfl=10.0%20r42&utmsr=1440x900&utmhid=&utmsc=&utmcs=&utmhn=offthewall.resource.com&utmp=%2Fotwtest%2F123%2Floaded&utmac=UA-2777587-8&utmwv=4.5.9
http://www.google-analytics.com/__utm.gif?utmwv=4.5.9&utmn=986816892&utmhn=offthewall.resource.com&utmcs=&utmsr=&utmsc=&utmul=&utmje=&utmfl=10.0%20r32&utmdt=Estore%20-%20Pilot%20-%20Buy%20Now%20Click&utmhid=&utmr=&utmp=%2Festore%2Fpilot%2Fbuynowclick&utmac=UA-2777587-8&utmcc=__utma%3D73423052.3.82651903293296E+018.1252000967.1252000968.1252000969.1%3B%2B__utmz%3D73423052.1252000967.1.1.utmcsr%3Dfacebook%7Cutmccn%3Doffthewall%7Cutmcmd%3Dwall%3B%3B%2B__utmv%3D73423052.estore_campaignpilot%3B
http://www.google-analytics.com/__utm.gif?utmwv=4.5.9&utmn=<dynamic>&utmhn=offthewall.resource.com&utmcs=&utmsr=&utmsc=&utmul=&utmje=&utmfl=&utmdt=<Update>&utmhid=&utmr=&utmp=<Update>&utmac=UA-2777587-6&utmcc=__utma%3D73423052.<dynamic>.1252000967.1252000968.1252000969.1%3B%2B__utmz%3D73423052.1252000967.1.1.utmcsr%3D(direct)%7Cutmccn%3D(direct)%7Cutmcmd%3D(none)%3B%3B%2B__utmv%3D73423052.%3B
http://www.google-analytics.com/__utm.gif?
*/