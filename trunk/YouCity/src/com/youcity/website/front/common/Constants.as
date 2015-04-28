package com.youcity.website.front.common
{
	import mx.collections.ArrayCollection;

	public final class Constants
	{
//		public static const CONFIG_URL:String = "front_usa.xml";
		public static const CONFIG_URL:String = "front.xml";
		
		public static const SUBWAY_DATA:String = "assets/traffic/subway.xml";
		
		public static const ABOUT_HTML_PATH:String 	= "assets/document/about.html";
		public static const TERM_HTML_PATH:String 		= "assets/document/term.html";
		public static const PRIVACY_HTML_PATH:String 	= "assets/document/privacy.html";
		
		public static const ACTIVITY_BROKEN_IMAGE:String 	= "assets/default/no_picture.jpg";
		public static const AVATOR_BROKEN_IMAGE:String 	= "assets/default/default_head.png";
		public static const DEFAULT_BROKEN_IMAGE:String 	= "assets/default/default_image.png";
		
		public static const INPUT_ERROR:String = "Invalid Input, please check";
		
		public static const UPDATE_SUCCEED:String = "Update successfully";

		public static const UPDATE_FAILED:String="Update failed";
		
		public static const NEARBY_SEARCH_OFFSET_X:Number = 1000;
		
		public static const NEARBY_SEARCH_OFFSET_Y:Number = 750;
		
		public static const PRIVACY:Array = [	{label:"Any Person", value:"0"},
												{label:"Friends Only", value:"1"},
												{label:"Myself Only", value:"2"}];
		
		public static const STATES:Array = [{label:"New York", value:"New York"}];
		
		public static const MONTHS:Array = [	{full:"January", short:"Jan."},
												{full:"February", short:"Feb."},
												{full:"March", short:"Mar."},
												{full:"April", short:"Apr."},
												{full:"May", short:"May."},
												{full:"June", short:"Jun."},
												{full:"July", short:"Jul."},
												{full:"August", short:"Aug."},
												{full:"September", short:"Sept."},
												{full:"October", short:"Oct."},
												{full:"November", short:"Nov."},
												{full:"December", short:"Dec."}];

		public static var MENU_ITEMS:Array = [
				{url:"assets/menu/menu_friend.png", name:"friend", title:"my friend", viewName:"friendListView"},
				{url:"assets/menu/menu_public_activity.png", name:"pub activity", title:"public activity", viewName:"activityView"},
				{url:"assets/menu/menu_my_activity.png", name:"my activity", title:"my activity", viewName:"myActivityView"},
				{url:"assets/menu/menu_event.png", name:"friend's feed", title:"friends feed", viewName:"friendsEventView"},
				{url:"assets/menu/menu_personalmap.png", name:"my map", title:"friends map", viewName:"personalMapView"},
				{url:"assets/menu/menu_search.png", name:"invite", title:"invite", viewName:"invietFriendView"},
				{url:"assets/menu/menu_mail_box_empty.png", name:"mail", title:"mail", viewName:"messageView"}
				];
				
		public static const CHANNLES:Array = [	{label:"Other", value:"other"},
												{label:"Friend/Family", value:"friend/family"},
												{label:"Blog", value:"FF"},
												{label:"Google or other search", value:"search engine"},
												{label:"Google ad", value:"google ad"},
												{label:"Facebook ad", value:"facebook ad"},
												{label:"Print ad", value:"print ad"},
												{label:"Media news", value:"media news"},
												{label:"Twitter or other micro-blogging", value:"twitter"}
												];
		public static const ACC_EXISTED:uint = 1;
		public static const ACC_NOT_EXISTED:uint = 0;
		
		public static const ACTIVITED:uint = 1;
		public static const NOT_ACTIVITED:uint = 0;
		
		public static const VOTE_AGREE:String 		= "0";
		public static const VOTE_DISAGREE:String 	= "1";
		
		public static const MY_HOME:String 			= "0";									
		public static const MY_ACTIVITIES:String 		= "1";									
		public static const MY_FRIENDS:String 			= "2";									
		public static const PUBLIC_ACTIVITIES:String 	= "3";			
		public static const WELCOME:String 	= "5";			
		
		public static const COMMENT:String 	= "0";				
		public static const ACTIVITY:String 	= "1";				
		public static const PHOTO:String 		= "2";				
		public static const VIDEO:String 		= "3";				
		public static const USER:String	 	= "4";				
		public static const BUSINESS:String	= "5";				
		public static const BUILDING:String 	= "6";				
		public static const STATUS:String 		= "0";		
		public static const BUSINESS_NOTE:String 	= "7";
		public static const PERSONAL_MAP:String	= "8";		
		
		public static const SEARCHTYPE_ALL:String = "0";
		public static const SEARCHTYPE_BUILDING:String = "1";
		public static const SEARCHTYPE_BUSINESS:String = "2";
		public static const SEARCHTYPE_ACTIVITY:String = "3";
												
		public static const MAPELEMTYPE_MARKER:uint	= 0;
		public static const MAPELEMTYPE_LINE:uint		= 1;
		
		public static const STATE_REGISTER:String 	= "register";
		public static const STATE_NORMAL:String 	= "normal";
		public static const STATE_UPDATE:String 	= "update";
		public static const STATE_BROWSE:String 	= "browse";
		public static const STATE_EDIT:String 		= "edit";
		
		public static const INFOWINTYPE_EDIT_MAPELEM:String 	= "editMapElem";
		public static const INFOWINTYPE_BROWSE_MAPELEM:String = "browseMapElem";
		
		public static const YAHOO:String 	= "1";
		public static const MSN:String 	= "2";
		public static const GMAIL:String 	= "3";
		public static const AOL:String 	= "4";

	}
}