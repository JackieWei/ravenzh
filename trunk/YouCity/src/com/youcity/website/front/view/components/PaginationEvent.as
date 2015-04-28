package com.youcity.website.front.view.components
{
	import flash.events.Event;

	public class PaginationEvent extends Event
	{
		public static const CHANGE_PAGE:String = "changePage";
		
		public var currentPage:uint = 1;
		public var totalNum:uint = 1;
		
		public function PaginationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}