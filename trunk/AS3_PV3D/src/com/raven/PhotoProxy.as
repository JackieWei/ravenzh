package com.raven
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;

	dynamic public class PhotoProxy extends Proxy implements IEventDispatcher 
	{

		private static const API_KEY:String = "ea9bb66ff1cf25e6a6c74e9a9bd504ee";
		private static const FLICKR_URL:String = " http://api.flickr.com/services/rest/";
		private var eventDispatcher:EventDispatcher;
		private var pendingArgs:Array;

		public function PhotoProxy() 
		{
			eventDispatcher = new EventDispatcher();
		}

		// The following event handler is called when the
		// reflection call is made to the Flickr API. The results
		// of this call tell us what to name the original request's
		// parameters and allows us to build a query string with
		// name/value pairs
		private function onReflectionComplete(event:Event):void 
		{
			var queryString:String = "";
			var reflection:XML = XML(event.target.data);
			var methodArguments:XMLList = reflection.arguments.argument;
			for(var i:Number = 0; i < pendingArgs.length; i++) 
			{
				if(pendingArgs[i] != null) 
				{
					queryString += "&" + methodArguments[i].@name.toString() + "=" +
					pendingArgs[i];
				}
			}
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(PhotoProxy.FLICKR_URL + "?method=" +
			reflection.method.@name.toString() + queryString);
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(request);
		}

		// This event handler is called when the real result is
		// received from the Flickr API. It simply broadcasts this
		// data as a DataEvent event.
		private function onComplete(event:Event):void 
		{
			dispatchEvent(new DataEvent(Event.COMPLETE, false, false, XML(event.target.data)));
		}
   
		// This is the method that captures the request. It is a
		// part of the flash.utils.Proxy class.
		flash_proxy override function callProperty(methodName:*, ...args):* 
		{
			pendingArgs = args;
			pendingArgs.unshift(PhotoProxy.API_KEY);
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(PhotoProxy.FLICKR_URL +
				"?method=flickr.reflection.getMethodInfo&method_name=flickr.photos." +
				methodName.toString() + "&api_key=" + PhotoProxy.API_KEY);
			loader.addEventListener(Event.COMPLETE, onReflectionComplete);
			loader.load(request);
			return methodName.toString();
		}

		public function addEventListener(type:String, listener:Function,
		     useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false):void 
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
		}

      public function dispatchEvent(event:Event):Boolean {
         return eventDispatcher.dispatchEvent(event);
      }

		public function hasEventListener(type:String):Boolean 
		{
			return eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean 
		{
			return eventDispatcher.willTrigger(type);
		}

	}
}