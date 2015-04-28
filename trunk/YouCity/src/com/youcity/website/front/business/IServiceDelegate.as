package com.youcity.website.front.business
{
	import mx.rpc.IResponder;
	
	public interface IServiceDelegate
	{
		//call service		
		function call(methodName:String, args:Array):void
	}
}