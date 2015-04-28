package com.youcity.website.front.vo
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="com.youcity.website.back.vo.PolyGonVO")]
	public class PolyGonVO 
	{
		public var buildingId:String;
		
		public var buildingName:String;
		
		public var polygon:String;
		
		public var polygonList:ArrayCollection;
		
		public var centerX:int;
		
		public var centerY:int;
	}
}

 
