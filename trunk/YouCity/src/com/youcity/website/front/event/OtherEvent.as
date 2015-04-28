package com.youcity.website.front.event
{
	public class OtherEvent extends EventBase
	{
		public static const GET_BUSINESS_PHOTOLIST:String 		= "get_business_photolist";
		public static const GET_BUSINESS_VIDEOLIST:String 		= "get_business_videolist";
		public static const GET_BUSINESS_NOTE_LIST:String 		= "get_business_note_list";
		public static const GET_BUSINESS_DETAILINFO:String 	= "get_business_detailinfo";
		public static const GET_BUSINESS_COMMNETLIST:String 	= "get_business_commnetlist";
		public static const GET_BUSINESS_CATEGORYLIST:String 	= "get_business_categorylist";
		public static const GET_BUSINESS_RELOCATE_HOSTORY_LIST:String = "get_business_relocate_hostory_list";
		
		public static const GET_BUILDING_DETAILINFO:String 	= "get_building_detailinfo";
		public static const GET_BUILDING_BUSINESSLIST:String 	= "get_building_businesslist";
		
		public static const GET_SYSTEM_MESSAGELIST:String 		= "get_system_messagelist";
		public static const GET_USER_MESSAGELIST:String 		= "get_user_messagelist";
		public static const GET_USER_REPLY_MESSAGELIST:String = "get_user_reply_messagelist";
		public static const GET_POLYGON_BY_REFID:String 		= "get_polygon_by_refId";
		public static const GET_AD_MANAGE_LIST:String 			= "get_ad_manage_list";
		
		public static const DO_SETTLE_DOWN:String 				= "do_settle_down";
		public static const DO_UPLOAD_PHOTO_ON_BUSINESS:String= "do_upload_photo_on_business";
		public static const DO_UPLOAD_VIDEO_ON_BUSINESS:String	= "do_upload_video_on_business";
		public static const DO_UPLOAD_PHOTO_ON_BUILDING:String	= "do_upload_photo_on_building";
		public static const DO_UPLOAD_VIDEO_ON_BUILDING:String	= "do_upload_video_on_building";
		public static const DO_COMMENT_ON_BUSINESS:String 		= "do_comment_on_business";
		public static const DO_COMMENT_ON_BUILDING:String 		= "do_comment_on_building";
		public static const DO_RELOCATE_BUSINESS:String 		= "do_relocate_business";
		public static const DO_ADD_BUSINESS:String 			= "do_add_business";
		public static const DO_NOTE_BUSINESS:String 			= "do_note_business";
		public static const DO_SEND_USER_MESSAGE:String 		= "do_send_user_message";
		public static const DO_DELETE_MESSAGE:String 			= "do_delete_message";

		public function OtherEvent(type:String, callbackFunc:Function=null)
		{
			super(type, callbackFunc);
		}
		
	}
}