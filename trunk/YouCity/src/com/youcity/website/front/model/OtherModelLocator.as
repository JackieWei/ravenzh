package com.youcity.website.front.model
{
	import com.youcity.website.front.vo.BuildingVO;
	import com.youcity.website.front.vo.BusinessVO;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class OtherModelLocator 
	{
		public var currentBusinessId:String;
		
		public var currentBuildingId:String;
		
		[ArrayElementType("com.youcity.website.front.vo.BusinessVO")]
		public var building_businessList_normal:ArrayCollection;
		
		[ArrayElementType("com.youcity.website.front.vo.BusinessVO")]
		public var building_businessList_added:ArrayCollection;
		
		[ArrayElementType("com.youcity.website.front.vo.BusinessVO")]
		public var building_businessList_relocated:ArrayCollection;
		
		[ArrayElementType("com.youcity.website.front.vo.ActivityVO")]
		public var building_tags:ArrayCollection;
		
		[ArrayElementType("com.youcity.website.front.vo.AdManageVO")]
        public var ads_list:ArrayCollection;
		
		public var business_host:BuildingVO;
		
		public var toUser:Object;
		
		public var userMessages:ArrayCollection;
		
		public var replyMessages:ArrayCollection;
		
		public var systemMessages:ArrayCollection;
		
		public var unreadMessageCount:Array = [0, 0];
		
		[ArrayElementType("com.youcity.website.front.vo.TagVO")]
		public var	business_tags:ArrayCollection;
		
		[ArrayElementType("com.youcity.website.front.vo.BusinessCategoryVO")]
		public var	business_categoryList:ArrayCollection;
		
		public var measureResult:String;
		
		private static var _instance:OtherModelLocator;
		
		public function OtherModelLocator()
		{
			if (_instance)
			{
				throw(new Error("SINGTON ERROR!"));
			}
		}
		
		public static function getInstance():OtherModelLocator
		{
			if (!_instance)
			{
				_instance = new OtherModelLocator();
			}
			return _instance;
		}		 
	}
}


 
