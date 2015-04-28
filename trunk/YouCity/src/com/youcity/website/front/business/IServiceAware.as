package com.youcity.website.front.business
{
	import mx.rpc.AbstractService;
	
	public interface IServiceAware
	{
		/**
		 * Get service by its name. (Service can be RemoteObject, HttpService or WebService) 
		 * @return 
		 * 
		 */		
		function get service():String;
	}
}