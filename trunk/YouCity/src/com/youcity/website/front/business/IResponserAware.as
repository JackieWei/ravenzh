package com.youcity.website.front.business
{
	import mx.rpc.IResponder;
	
	public interface IResponserAware
	{
		//Return the responder to handle resultEvent and faultEvent.
		function get responder():IResponder;
	}
}