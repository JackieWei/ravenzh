package com.youcity.website.front.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	[Bindable]
	[RemoteClass(alias="com.youcity.website.back.vo.BusinessNoteVO")]
	public class BusinessNoteVO implements IValueObject
	{
		public var id:String;
	
		public var businessId:String;
	
		public var userId:String;
	
		public var userName:String;
	
		public var businessName:String;
		
		public var phoneNumber:String;
	
		public var address:String;
	
		public var content:String;
	
		public var website:String;
	
		public var category:String;
	
		public var createTime:String;
		
		public var agreeCount:String;
	
		public var disAgreeCount:String;
		
		public function BusinessNoteVO()
		{
		}

	}
}