package com.youcity.website.front.view.business
{
	import flash.events.EventDispatcher;

	public final class BusinessED extends EventDispatcher
	{
		public static const REHOST:String = "rehost";
		
		private static var _instance:BusinessED;
		private static var key:Boolean;
		public static function get instance():BusinessED
		{
			if (!_instance)
			{
				key = true;
				_instance = new BusinessED();
			}
			return _instance;
		}
		
		public function BusinessED()
		{
			super(null);
			if (!key)
			{
				throw new Error("Singletion");
			}
			key = false;
		}
		
		
		
	}
}