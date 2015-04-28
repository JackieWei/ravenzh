package com.youcity.website.front.model
{
	import com.youcity.maps.MapPoint;
	import com.youcity.website.front.vo.ResultVO;
	
	public class SearchModelLocator 
	{
		
		public var area:Array;
	 	/**
	 	 * search result for activity 
	 	 */		
	 	public var activityResult:ResultVO;
	 	
	 	/**
	 	 * search result for building 
	 	 */	
	 	public var buildingResult:ResultVO;
	 	
	 	/**
	 	 * search result for business 
	 	 */	
	 	public var businessResult:ResultVO;
	 	
		public var isNearBySearch:Boolean = false;
		public var isAreaSearch:Boolean = false;
	 	public var centerPoint:MapPoint;
	 	public var buildingName:String;
	 	
	 	public var area_start:MapPoint;
		public var area_end:MapPoint;
		
		public var keyword:String;
		public var pageSize:uint;
		public var currentPage:uint;
		public var category:uint;
		public var searchType:String;
		
	 
		private static var _instance:SearchModelLocator;
	 	
	 	public function SearchModelLocator()
	 	{
	 		if (_instance)
	 		{
	 			throw(new Error("SINGTON ERROR!"));
	 		}
	 	}
	 	
	 	public static function getInstance():SearchModelLocator
	 	{
	 		if (!_instance)
	 		{
	 			_instance = new SearchModelLocator();
	 		}
	 		return _instance;
	 	}
		 
	}
}


 
