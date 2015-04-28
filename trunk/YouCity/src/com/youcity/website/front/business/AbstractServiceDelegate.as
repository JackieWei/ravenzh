package com.youcity.website.front.business
{
	import mx.rpc.IResponder;
	
	public class AbstractServiceDelegate implements IServiceDelegate, IServiceAware, IResponserAware
	{
		private var _responder:IResponder;
		/**
		 * Read_Only property, return the value of responder.
		 * @return 
		 */	
		public function get responder():IResponder
		{
			return this._responder;
		}
		
		private var _service:String;
		/**
		 * Read_Only property, return the service name
		 * @return 
		 * 
		 */		
		public function get service():String
		{
			return this._service;
		}
		
		public function AbstractServiceDelegate(responder:IResponder, service:String)
		{
			this._responder = responder;
			this._service = service;
		}

		public function call(methodName:String, args:Array):void
		{
			//to do
		}
		
	}
}