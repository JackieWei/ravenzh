package com.youcity.website.front.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	[Bindable]
	[RemoteClass(alias="com.youcity.website.back.vo.CityVO")]
	public class CityVO implements IValueObject
	{
		public var cityName:String;
		
		public var pictureUrl:String;
		
		public var mapRoot:String;
		
		public var defaultCenterX:int;
		
		public var defaultCenterY:int;
		
		public var defaultZoom:int;

		public function CityVO()
		{
			
		}
		
	}

}
 
