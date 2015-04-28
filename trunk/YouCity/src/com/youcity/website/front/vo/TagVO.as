package com.youcity.website.front.vo
{

	[Bindable]
	[RemoteClass(alias="com.youcity.website.back.vo.TagVO")]
	public class TagVO 
	{
		public var tagId:String;
		
		public var refId:String;
		
		public var refType:String;
		
		public var tagName:String;
		
		public var count:int;
		
		public var createTime:Date;
	}
}

 
