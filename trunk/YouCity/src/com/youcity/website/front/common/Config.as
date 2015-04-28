package com.youcity.website.front.common
{
	import flash.utils.Dictionary;
	
	public class Config
	{
		public static var AVATAR_PREFIX:String = "";
		
		public static var PHOTO_PREFIX:String = "";
		
		public static var FILE_UPLOAD:String = "";
		
		[Bindable]
		public static var SERVICE_URL:String = "";
		
		[Bindable]
		public static var SERACH_SERVICE_URL:String = "";
		
		[Bindable]
		public static var HOME_URL:String = "";
		
		public static var BLOG_URL:String = "";
		
		public static var TWITTER_URL:String = "";
		
		public static var event_mapping:Dictionary = new Dictionary(true);
		
		//这个变量标识当前是否是处于有参数状态，一旦在load完成之后也可以设为flase
		public static var NEED_LOCATE_NEW_CENTER:Boolean = false;
	}
}