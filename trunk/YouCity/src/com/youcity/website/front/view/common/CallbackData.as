package com.youcity.website.front.view.common
{
	public class CallbackData
	{
	
		public static const SUCCEED:String = "1";
		public static const FAILED:String = "0";
			
		public var code:String;
		
		public var data:Object;
		
		public function CallbackData(code:String = "1", data:Object = null)
		{
			this.code = code;
			this.data = data;
		}

	}
}