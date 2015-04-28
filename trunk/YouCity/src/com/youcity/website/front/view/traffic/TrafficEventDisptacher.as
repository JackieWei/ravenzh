package com.youcity.website.front.view.traffic
{
	import flash.events.EventDispatcher;

	public class TrafficEventDisptacher extends EventDispatcher
	{
		public static const CURRENT_ROUTE_CHANGE:String = "current_route_change";
		
		private static var _instance:TrafficEventDisptacher;
		private static var key:Boolean;
		public static function get instance():TrafficEventDisptacher
		{
			if (!_instance)
			{
				key = true;
				_instance = new TrafficEventDisptacher();
			}
			return _instance;
		}
		public function TrafficEventDisptacher()
		{
			super(null);
			if (!key)
			{
				throw new Error("Signelton");
			}
			key = false;
		}
		
	}
}