package ras3r.reactive_resource
{
	import ras3r.*;
	import ras3r.reactive_resource.*;

	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	public class Request extends EventDispatcher
	{
		public var contentType:String;
		public var data:Object;
		public var method:String;
		public var path:String;
		public var response:Response;

		private var loader:URLLoader;

		public function Request (_method:String, _path:String)
		{
			method = _method;
			path = _path;

			loader = new URLLoader();
			loader.addEventListener('complete', complete);
			loader.addEventListener('httpStatus', status);
			loader.addEventListener('ioError', io_error);
			loader.addEventListener('progress', progress);
			loader.addEventListener('securityError', security_error);
		}

		public function load () :void
		{
			// DO NOT FORCE TIMESTAMPS HERE!!!
			// DOING SO BREAKS SOME 3rd PARTY FEEDS!!
			// the condition that follows supports "cache-breaking" upon request
/*			var url:String = ((timestamp > 0) ? (path + '?ievil=' + timestamp) : path);*/
			var url:String = path;

			// translate PUT and DELETE
			method = method.toUpperCase();

			var request:URLRequest = new URLRequest(url);
			request.contentType = contentType;
			request.data = data;

			request.method = (method == 'GET') ? 'GET' : 'POST';
			if (method != 'GET' && method != 'POST') request.requestHeaders.push(new URLRequestHeader('X_HTTP_METHOD_OVERRIDE', method));

			loader.load(request);
		}


		// >>> PROTECTED METHODS
		// HACK! parse intended HTTP status from XML response
		// until we get XML sockets working with real status codes! (or AMF)
		protected function status_from_event (e:Event) :int
		{
			var data:XML = (e.target.data as XML);
			var code:Number = ((data && data.@status) ? parseInt(data.@status) : NaN);
			// if no status supplied, assume 200 OK
			if (isNaN(code)) code = 200;

			switch (code)
			{
				// ignore 200 OK b/c 'complete' event has data!
				case 200:
					break;
				// custom progress event
				case 202:
					// dispatch progress event
					progress(new ProgressEvent('progress', false, false, data.percent_complete, 100));
					break;
				// all else: error!
				default:
					io_error(new IOErrorEvent('ioError', false, false, (code + ': ' + data.error)));
					break;
			}

			status(new HTTPStatusEvent('httpStatus', false, false, code));
			return code;
		}


		// >>> EVENT HANDLERS
		private function complete (e:Event) :void
		{
			try
			{
				response = new Response(e.target.data);
				data = response.body;
				// fire 'complete' if 200 (status_from_event defaults to 200)
				if (status_from_event(e) == 200) dispatchEvent(e);
			}
			catch (err:Object)
			{
				Logger.debug('Request#complete: Unable to parse response from ' + path + '. Error: ' + err);
/*				Logger.debug('Request#complete, unable to parse response. Error: ' + err + '. Data dump: ');
				Logger.dump(e.target.data);
				Logger.dump(e);
*/			}
		}

		private function io_error (e:Event) :void
		{
			dispatchEvent(e);
		}

		private function progress (e:Event) :void
		{
			dispatchEvent(e);
		}

		private function security_error (e:Object) :void
		{
			io_error(new IOErrorEvent('ioError', false, false, e.text));
		}

		private function status (e:HTTPStatusEvent) :void
		{
			dispatchEvent(e);
		}
	}
}