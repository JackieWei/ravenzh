package com.youcity.website.front.event
{
	public class SearchEvent extends EventBase
	{
		public static const SEARCH_ACTIVITY:String = "search_activity";
		public static const SEARCH_BUSINESS:String = "search_business";
		public static const SEARCH_BUILDING:String = "search_building";
		
		public function SearchEvent(type:String, callbackFunc:Function=null)
		{
			super(type, callbackFunc);
		}
		
	}
}