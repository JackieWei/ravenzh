package com.youcity.website.front.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.mxml.HTTPService;
	
	public class SearchServiceDelegate extends AbstractServiceDelegate
	{
		/**
		 * Constructor 
		 * @param responder
		 * @param serviceName
		 */ 	
		public function SearchServiceDelegate(responder:IResponder, service:String) 
		{
			super(responder, service);
		}
		
		/**
		 * @param parameter
		 */		
		override public function call(methodName:String,args:Array):void
		{
			var httpService:HTTPService = ServiceLocator.getInstance().getHTTPService(service) as HTTPService;
			var asyncToken:AsyncToken = httpService.send(args[0]);
			asyncToken.addResponder(responder);
		}
	}
}
 
