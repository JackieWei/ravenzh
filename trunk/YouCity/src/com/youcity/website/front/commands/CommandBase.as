package com.youcity.website.front.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.vo.IValueObject;
	import com.youcity.website.front.business.IServiceDelegate;
	import com.youcity.website.front.business.ServiceDelegate;
	import com.youcity.website.front.event.EventBase;
	import com.youcity.website.front.view.common.CallbackData;
	import com.youcity.website.front.view.common.ErrorCode;
	
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	import mx.messaging.events.ChannelFaultEvent;
	import mx.rpc.IResponder;
	
	public class CommandBase implements ICommand, IResponder
	{
		private static const ERR_INFO:String = "Sorry, the system is temporarily not available. " + 
				"Please check back later. Thanks!";
		
		public var callback:Function;
		public var data:Object;
		protected var delegate:IServiceDelegate;
		protected static var event_mapping:Dictionary = new Dictionary(true);
		
	 	/**
	 	 * Constructor 
	 	 */	 	
	 	public function CommandBase()
	 	{
	 	} 
	 	
	 	public static function init(dic:Dictionary):void
	 	{
	 		event_mapping = dic;
	 	}
	 	
		public function execute(event:CairngormEvent):void
		{
			if (!(event is EventBase))
				throw new Error("Event Type Mismatch, It should be a type of EventBase");
			
			callback = EventBase(event).callback;
			data = EventBase(event).data;
			
			if (event_mapping[event.type] == undefined)
				throw new Error("Event Mapping Not Found, PLS Check");
			
			var mapping:Object = event_mapping[event.type];
			
//			trace("Event " + "\t" + event.type);
//			trace("Service" + "\t" + mapping.service);
//			trace("Method" + "\t" + mapping.method);
//			trace("Parameters Start" + "\n" + "======");
			var args:Array = formatParameters(mapping.params);
			var argLength:uint = args.length;
			var paramsLength:uint = mapping.params.length;
			if(argLength != paramsLength)
			{
				mx.controls.Alert.show("Required " + paramsLength + " parameters, " + "Actually " + argLength + " !");
				return;
			}
//			for (var i:uint = 0; i < paramsLength; i ++)
//			{
//				trace(mapping.params[i].name + "\t" + args[i] + "\t" + mapping.params[i].type);
//			}
//			trace("======" + "\n" + "Parameters End");
//			trace("=============================================================");
			
	 		delegate = new ServiceDelegate(this, mapping.service);	
			delegate.call(mapping.method, args);
		}
		
		protected function formatParameters(arr:Array):Array
		{
			var args:Array = [];
			for each(var param:Object in arr)
			{
				if (!data.hasOwnProperty(param.name))
				{
					mx.controls.Alert.show("Parameter Missing! " + param.name);
					return args;
				}
				args.push(data[param.name]);	
			}
			return args;
		}
		
		public function result(data:Object):void
		{	
			handleResult(data.result);
			invokeCallback(data.result);
		}
		
		protected function handleResult(result:Object):void
		{
			//to do
		}
				
		protected function invokeCallback(result:Object):void
		{
			if (callback != null)
			callback(new CallbackData(CallbackData.SUCCEED, result));
			
			callback = null;
			this.data = null;
		}
		
		public function fault(info:Object):void
		{
			var object:Object = info.fault.rootCause;
			if (object)
			{
				if (object is ChannelFaultEvent)
				{
					mx.controls.Alert.show(ERR_INFO);
					return;
				}
				if (object.hasOwnProperty("systemException"))
				{
					sysFault(info.fault.rootCause.errorCode, info.fault.rootCause);
				}
				else
				{
					appFault("", info.fault.rootCause);
				}
			}
			else
			{
				sysFault(ErrorCode.UNKNOWN_CLIENT_ERROR, info.fault);
			}
		
			if (callback != null)
			{
				callback(new CallbackData(CallbackData.FAILED, info));
			}
		}
		 
		protected function appFault(errorCode:String, serverAppException:Object):void
		{
			//to be implemented by its subclass
		}
		
		protected function sysFault(errorCode:String, serverSysException:Object):void 
		{
			//to be implemented by its subclass
			switch (errorCode)
			{
				case ErrorCode.UNKNOWN_CLIENT_ERROR:
					//to do
//					Alert.show("Unknown Client Error", "Error");
					break;  
				case ErrorCode.UNKNOWN_SERVER_ERROR:
//					Alert.show("Unknown Server Error", "Error");
					break;
				case ErrorCode.DATABASE_ACCESS_ERROR:
					//to do
					break;
			}
		}
		 
	}
	
}
