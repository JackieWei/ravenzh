package com.youcity.website.front.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	[Bindable]
	[RemoteClass(alias="com.youcity.website.back.vo.BusinessCategoryVO")]
	public class BusinessCategoryVO implements IValueObject
	{
	
		public var categoryId:int;
		
		public var categoryName:String;
		
		public function  BusinessCategoryVO()
		{
			//to do
		}
	}
}

 
