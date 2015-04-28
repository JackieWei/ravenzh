package com.youcity.website.front.view.common.event
{
	import com.youcity.website.front.controller.CommonEventDipatcher;
	
	import flash.events.Event;

	public class ViewManagerEvent extends Event
	{
		//data should be passed
		public var data.*;
		
		//Constructor
		public function ViewManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		//Dispatch a viewManager event
		public function dispatch():Boolean
		{
			return CommonEventDipatcher.getInstance().dispatchEvent(this);
		}
		
	}
}