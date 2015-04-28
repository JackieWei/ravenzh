package com.youcity.website.front.controller
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * OtherEventDispatcher short as OtherED
	 * */
	
	public final class OtherED extends EventDispatcher
	{
		public static const CURRENT_BUILDING_CHANGED:String = "current_building_changed";
		public static const CURRENT_BUSINESS_CHANGED:String = "current_business_changed";
		
		
		public static const BUILDING_RESIDENT_CHANGED:String = "building_resident_changed";
		public static const BUILDING_BUSINESS_CHANGED:String = "building_business_changed";
		
		public static const SELECTE_BUSINESS_BUILDING:String = "select_business_building";
		
		private static var _instance:OtherED;
		private static var key:Boolean;
		public static function getInstance():OtherED
		{
			if (!_instance)
			{
				key = true;
				_instance = new OtherED();
			}
			return _instance;
		}
		public function OtherED(target:IEventDispatcher=null)
		{
			super(target);
			if (!key)
			{
				throw new Error("Singleton Class pls use getInstance to get the instance");
				return;
			}
			key = false;
		}
		
	}
}