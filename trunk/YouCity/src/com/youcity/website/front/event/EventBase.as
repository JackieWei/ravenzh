package com.youcity.website.front.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class EventBase extends CairngormEvent 
	{
	 
		public var callback:Function;
		
		public function EventBase(type:String, callbackFunc:Function = null)
		{
			super(type);
			if (callbackFunc != null)
			{
				callback = callbackFunc;
			}
		}
		 
	}
}


 
