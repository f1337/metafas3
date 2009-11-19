package com.adobe.fps
{
/**
* ...
* @author Eyal Peleg (Gigya.com)
* Gigya API bootstrap class for Flex & Actionscript 3.0
* Last modified on Aug 8th 2009
*/

//import flash.system.SecurityDomain;

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;

import flash.display.MovieClip;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;

import flash.system.Security;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ErrorEvent;

import flash.errors.IOError;
import flash.utils.*;

public dynamic class distribution
{
		public static var doReq:Boolean = false;
		public static function getLoader():URLLoader {
			var ldr:URLLoader = new URLLoader();
			return ldr;
		}
		public static function getURLRequest(url:String):URLRequest {
			var urlRequest:URLRequest = new URLRequest(''+url);
			return urlRequest;
		}

		public static function loadRequest(loader:URLLoader, urlRequest:URLRequest):void {
			setTimeout(
				function (loader:URLLoader, urlRequest:URLRequest):void {
					loader.load(urlRequest);
				},
			10,
			loader,
			urlRequest
			);

		}

		public static var services:Object = { instanceData: { },
			_LoaderProxy: {
				getLoader:distribution.getLoader,
				getURLRequest:distribution.getURLRequest,
				loadRequest:distribution.loadRequest
			}
		};

		//private static var _ServiceURLTemplate:String = 'http://cdn.gigya.com/wildfire/swf/as3/{svc}.swf' // if adding any const params then url must end with &
		private static var _ServiceURLTemplate:String = 'http://cdn.gigya.com/wildfire/WFApi.ashx?f=gs&asver=as3&service={svc}';

		public function distribution() {
		}

		private static function wait4Stage(conf:Object, params:Object, mcRoot:Sprite, sServices:String, callback:Function, attemptNumber:Number):void {
			try {
				if ( 0 == attemptNumber ) {
					if ( null == mcRoot || null == mcRoot.stage ) {
						flash.utils.setTimeout(distribution.wait4Stage, 500, conf, params, mcRoot,sServices,callback,attemptNumber + 1);
						return;
					}
				}
				else {
					if ( 1 == attemptNumber ) {
						if ( null == mcRoot || null == mcRoot.stage ) {
							if ( null!=params.callback && typeof params.callback == 'function' ) {
								params.callback(
									{ hadError:true,
									  requestParams:params,
									  context:params.context,
									  errorCode:1,
									  errorMessage:'Cannot find stage- Aborting',
									  errorData: { failedServices:'All services'  , detailedErrors:'All services are unavailable due to a stage absence'}
									});
							}
							return;
						}
					}
				}

				distribution.loadWithStage(conf, params, mcRoot, sServices, callback);
			}
			catch (e:Error) {
				trace('distribution.as: wait4Stage attemptNumber=' + attemptNumber + ' err=' + e.message);
				flash.utils.setTimeout(distribution.wait4Stage, 500, conf, params, mcRoot,sServices,callback,attemptNumber + 1);
			}
		}

		public static function load(conf:Object, params:Object):void {
			Security.allowDomain('cdn.gigya.com', 'wildfire.gigya.com', 'office.distribution.com');
			Security.allowInsecureDomain('cdn.gigya.com','wildfire.gigya.com','office.distribution.com');

			var mcRoot:Sprite = conf.mcRoot;
			var sServices:String = params.services;
			var callback:Function = params.callback;

			distribution.wait4Stage(conf,params,mcRoot,sServices,callback,0);
		}

		private static function loadWithStage(conf:Object, params:Object,mcRoot:Sprite,sServices:String,callback:Function):void {

			var arrServices:Array = sServices.toLowerCase().split(',');

			var commonlistener:Object = {
				sServices:sServices,
				params:params,
				pending:arrServices.length,
				failedServices:new Array(),
				errors:new Array(),
				onService:function(blnFailed:Boolean, serviceName:String,errorString:String):void {
					if (blnFailed) {
						this.failedServices.push(serviceName);
						this.errors.push(serviceName+':'+errorString)
					}
					this.pending--;
					if (this.pending == 0) {
						var hadError:Boolean = this.failedServices.length > 0;
						this.callback(
							{ hadError:hadError,
							  requestParams:this.params,
							  context:this.params.context,
							  errorCode:(hadError?1:0),
							  errorMessage:hadError?'Failed to load some services':'',
							  errorData: { failedServices:this.failedServices.join(',')  , detailedErrors:this.errors.join()}
							});
					}
				},
				callback:callback
			}

			var tasks:Array = [];
				tasks.onInit = callback;
				tasks.pending = arrServices.length;

			var task:Object;

			var i:Number;
			for (i= 0; i < arrServices.length; i++) {
				var sService:String = arrServices[i];
				tasks.push(CreateServiceLoader(mcRoot, sService, commonlistener,tasks));
			}

			for (i= 0; i < tasks.length; i++) {
				task = tasks[i];

				var serviceURL:String = task.serviceURL;
				if (serviceURL.indexOf('?') == -1) {
					serviceURL += '?';
				}
				else {
					if (serviceURL.charAt(serviceURL.length - 1) != '&') {
						serviceURL += '&';
					}
				}

				var variables:URLVariables = new URLVariables();
				var p:String;
				for (p in conf) {
					if ((conf[p] is Number) || (conf[p] is String) || (conf[p] is Boolean)) {
						if (p!='context') {
							variables[p] = conf[p];
						}
					}
				}
				for (p in params) {
					if ((params[p] is Number) || (params[p] is String) || (params[p] is Boolean)) {
						if (p!='context') {
							variables[p] = params[p];
						}
					}
				}
				var request:URLRequest = new URLRequest(serviceURL);
				request.data = variables;
				request.method = 'GET';
				task.loader.load(request, task.loaderContext);
			}
		}

		public static function isLoaded(conf:Object,params:Object,serviceName:String):Boolean  {
			var currentServiceObj:* = distribution.services[serviceName];
			return ( undefined != currentServiceObj ) ;
		}

		public static function isReady(conf:Object, params:Object, serviceName:String):Boolean  {
			if ( isLoaded(conf, params, serviceName) ) {
				var currentServiceObj:* = distribution.services[serviceName];
				var isInitialized:*= currentServiceObj['isInitialized'];
				if ( undefined == isInitialized || !(isInitialized is Function)) {
					return true;
				}
				return currentServiceObj['isInitialized'](conf, params);
			}
			return false;
		}

		//based on code from http://livedocs.adobe.com/flex/201/langref/flash/system/ApplicationDomain.html
		private static function CreateServiceLoader( mcRoot:Sprite, sService:String , serviceListener:Object, tasks:Array):Object {

			var loader:Loader = new Loader();

			// loading the service to a new application domain (which is a child of the current Domain)
		     var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);

			var task:Object={}; // The loader itseld can not have expando properties.

			task['loader'] = loader;
			task['serviceListener'] = serviceListener;
			task['loaderContext'] = loaderContext;
			task['serviceName'] = sService;
			task['serviceURL'] = _ServiceURLTemplate.split('{svc}').join(sService);

			task['IO_ERROR'] = function(evt:IOErrorEvent):void {
				trace('distribution.as: IOErrorEvent called while trying to load '+task['serviceName'] );
				task['serviceListener'].onService(true, task['serviceName'], evt.text );
			};

			task['COMPLETE'] = function(event:Event):void {
				var loader:Loader = Loader(event.target.loader);
				var info:LoaderInfo = LoaderInfo(loader.contentLoaderInfo);
				var ithTask:Object;

				ithTask = tasks[0];

				for (var iTask:Number = 0; ((iTask < tasks.length) && (ithTask.loader != loader)) ; ) {
					ithTask = tasks[++iTask];
				}

				var serviceName:String = ithTask['serviceName'];
				var serviceClassName:String = serviceName+'Main';
				var serviceClass:Class;
				serviceClass = info.applicationDomain.getDefinition(serviceClassName)  as  Class;
				var serviceInstance:Object = new serviceClass(); // to trigger allowDomain && allow access from the service to distribution.*
				distribution.services[serviceName] = serviceClass;
				if (serviceClass['setGigyaClassFromParent']) serviceClass['setGigyaClassFromParent'](ApplicationDomain.currentDomain.getDefinition('com.adobe.fps.distribution'));
				task['serviceListener'].onService(false,ithTask['serviceName'],'');
			};

			task['distribution'] = distribution;
			task['services'] = distribution.services;

			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,task['IO_ERROR'] );
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, task['COMPLETE']);

			return task;
		}
	};
}