package com.youcity.website.front.controller
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public final class CommonEventDipatcher extends EventDispatcher
	{
		public static const PHOTO_LIST_CHANGED:String = "photo_list_changed";
		public static const VIDEO_LIST_CHANGED:String = "video_list_changed";
		public static const CURRENT_PHOTO_CHANGED:String = "current_photo_changed";
		public static const CURRENT_VIDEO_CHANGED:String = "current_video_changed";
		
		public static const OPEN_ORIGNAL_VIEW:String = "open_original_view";
				
		private static var _instance:CommonEventDipatcher;
		private static var key:Boolean;
		public static function getInstance():CommonEventDipatcher
		{
			if (!_instance)
			{
				key = true;
				_instance = new CommonEventDipatcher();
			}
			return _instance;
		}
		public function CommonEventDipatcher(target:IEventDispatcher=null)
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