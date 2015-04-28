package com.youcity.website.front.view.business
{
	import com.youcity.website.front.vo.BuildingVO;
	import com.youcity.website.front.vo.BusinessVO;
	
	import flash.utils.Dictionary;
	
	public final class BusinessModel
	{
		[Bindable]
		public static var currentBusiness:BusinessVO;
		
		public static var categoryDict:Dictionary;
		
		public static var firstIndex:uint;
		
		public static var secondIndex:uint = 1;
		
		
		//for rehost
		[Bindable]
		public static var businessTobeRehost:BusinessVO;
		[Bindable]
		public static var businessNewHost:BuildingVO;
		
		[Bindable]
		public static var avgScore:int;
		
		[Bindable]
		public static var voteUserNum:Number = 0;
		
		public static var clipboard:String;
		
		public function BusinessModel()
		{
		}

	}
}