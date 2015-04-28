package com.youcity.website.front.view.building
{
	import flash.events.EventDispatcher;
	
	
	/*********  short for building event dispatcher***************/
	public final class BuildingED extends EventDispatcher
	{
		public static const CORRECT_BUSINESS_HOST:String = "correct_business_host";
		
		private static var _instance:BuildingED;
		private static var key:Boolean;
		public static function get instance():BuildingED
		{
			if (!_instance)
			{
				key = true;
				_instance = new BuildingED();
			}
			return _instance;
		}
		
		
		public function BuildingED()
		{
			super(null);
			if (!key)
			{
				throw new Error("Singleton");
				return;
			}
			key = false;
		}
		
	}
}