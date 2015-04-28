package com.youcity.website.front.event
{
	public class CommonEvent extends EventBase
	{
		public static const DO_COMMENT_ON_PHOTO:String 	= "do_comment_on_photo";
		public static const DO_COMMENT_ON_VIDEO:String 	= "do_comment_on_video";
		public static const DO_REPLY_ON_COMMENT:String 	= "do_reply_on_comment";
		public static const DO_REVIEW:String 				= "do_review";
		public static const DO_UPDATE_REVIEW:String 		= "do_update_review";
		public static const DO_DELETE_REVIEW:String 		= "do_delete_review";
		public static const DO_VOTE:String 				= "do_vote";
		public static const DO_VOTE_ON_REVIEW:String 		= "do_vote_on_review";
		public static const DO_LEAVE_MESSAGE:String 		= "do_leave_message";
		public static const GET_PHOTO_COMMENTLIST:String 	= "get_photo_commentlist";
		public static const GET_VIDEO_COMMENTLIST:String 	= "get_video_commentlist";
		public static const GET_TAGS:String 				= "get_tags";
		public static const GET_TAGS_BY_BUSINESS_CATEGORY:String = "get_tags_by_business_category";
		public static const GET_COUNT_OF_REVIEW:String 	= "get_count_of_review";
		public static const GET_REVIEW_LIST:String 		= "get_review_list";
		public static const GET_USER_REVIEW:String 		= "get_user_review";
		public static const GET_USER_REVIEW_DETAIL:String = "get_user_review_detail";
		public static const GET_REVIEW_TAGS:String 		= "get_review_tags";
		public static const GET_VOTE_COUNT:String 			= "get_vote_count";
		public static const GET_USER_REVIEW_COUNT:String 	= "get_user_review_count";
		public static const GET_LEAVE_MESSAGE_COUNT:String = "get_leave_message_count";
		public static const GET_LEAVE_MESSAGE_LIST:String = "get_leave_message_list";
		
		public function CommonEvent(type:String, callbackFunc:Function=null)
		{
			super(type, callbackFunc);
		}
		
	}
}