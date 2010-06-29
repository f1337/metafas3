package metafas3
{
	import flash.display.*;
	import flash.net.*;
	import flash.system.*;
	import metafas3.*;

	public class Tracker
	{
		// >>> PUBLIC PROPERTIES
		// Array of GA account IDs. At least ONE account ID required for all requests.
		// ex: UA-2202604-2
		public static var accounts:Array = [];

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
					session_count + ';+' +
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

		// total number of visits/sessions for this visitor to this swf/campaign
		private static var session_count:int = 1;

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

/*
SharedObject.getLocal('analytics', '/')
*/

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
			// build params hash
			var p:Hash = new Hash();

			// inject title, path
			p.utmdt = title;
			p.utmp = path;

			// ping URL
			ping(p);
		}

		public static function purchase (order:Object) :void
		{
			// build params hash
			var p:Hash = new Hash();

			// inject page params
			p.utmdt = order.title;
			p.utmp = order.path;
			// inject order params
			p.utmipc = order.sku;
			p.utmipn = order.product; // tee shirt
			p.utmipr = order.price; // 17100.32
			p.utmiqt = order.quantity;
			p.utmiva = order.options; // red; or 5;33 ct
			p.utmtci = order.city; // San Diego
			p.utmtid = order.id;
			p.utmtrg = order.region; // New Brunswick
			p.utmtsp = order.shipping;
			// Affiliation. Typically used for brick and mortar applications in ecommerce.
			// utmtst=google%20mtv%20store
			p.utmtst = order.affiliation;
			p.utmtto = order.total; // 334.56
			p.utmttx = order.tax; // 29.16
			/*
			Billing Country
			utmtco=United%20Kingdom
			*/

			// ping URL
			ping(p);
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
		private static function params (account:String, options:Hash) :Object
		{
			return options.apply({
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
			});
		}

		private static function ping (options:Hash) :void
		{
			if (! (accounts.length && _hash)) return;

			var p:Object;
			var qs:Array;
			for each (var account:String in accounts)
			{
				p = params(account, options);
				// build/reset querstring
				qs = new Array();
				for (var s:String in p)
				{
					qs.push(s + '=' + encodeURIComponent(p[s]));
				}

				// ping URL
				logger.info('GA ping: ' + url + qs.join('&'));
				loader.load(new URLRequest(url + qs.join('&')));
			}
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