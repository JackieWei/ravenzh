package com.youcity.website.front.vo
{

	[Bindable]
	[RemoteClass(alias="com.youcity.website.back.vo.BuildingVO")]
	public class BuildingVO 
	{
		public var buildingId:String;
		
		public var buildingName:String;
		
		public var buildingContent:String;
		
		public var phoneNumber:String;
		
		public var address:String;
		
		public var category:String;
		
		public var centerX:int;
		
		public var centerY:int;
	}
}

 
