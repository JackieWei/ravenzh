package com.youcity.website.front.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	[Bindable]
	[RemoteClass(alias="com.youcity.website.back.vo.BusinessVO")]
	public class BusinessVO implements IValueObject 
	{	
		public static const VERIFIED:String = "0";
		public static const ADDED:String = "1";
		public static const RELOCATE:String = "2";
		
		public var logo:String = "assets/business/business_logo.png";
		
		public var id:String;
		
		public var businessName:String;
		
		public var businessContent:String;
		
		public var buildingId:String;
		
		public var buildingName:String;
		
		public var phoneNumber:String;
		
		public var address:String;
		
		public var website:String;
		
		public var category:int;
		
		public var verifyStatus:String;
		
		public var tags:String;
		
		public var centerX:uint;
		
		public var centerY:uint;
		
		public var agreeCount:int;
	
		public var disagreeCount:int;

		public var relocatedListCount:int;
		
		public var userId:String;
	
		public var userName:String;
		
		public var notedListCount:int;
		
		public var refBusinessId:String;
		
		public var createTime:String;
		
		public function BusinessVO()
		{
		
		}
	}

}

 
