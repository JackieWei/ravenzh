package com.youcity.website.front.util
{
	import com.youcity.website.front.event.EventBase;
	
	public class EventUtil
	{
		public static function dispatchEvent(eventType:String, param:Object, callbackFunc:Function = null):void
		{
			var e:EventBase = new EventBase(eventType);
			e.data = param;
			if (callbackFunc != null)
				e.callback = callbackFunc;
			e.dispatch();
		}
		
	}
}