package com.youcity.website.front.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.Operation;
	
	public class ServiceDelegate extends AbstractServiceDelegate
	{
		/**
		 * Constructor 
		 * @param responder
		 * @param serviceName
		 */ 		
		public function ServiceDelegate(responder:IResponder, service:String) 
		{
			super(responder, service);
		}
		
		/**
		 * Invoke the remote java object's method via Operation. 
		 * @param methodName
		 * @param arguments
		 * 
		 */		
		override public function call(method:String, args:Array):void
		{
			var operation:Operation = ServiceLocator.getInstance().getRemoteObject(service).getOperation(method) as Operation;
			operation.arguments = args;
			var asyncToken:AsyncToken = operation.send();
			asyncToken.addResponder(responder);
		}
	}
}
 
