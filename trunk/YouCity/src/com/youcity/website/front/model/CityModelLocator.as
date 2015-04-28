package com.youcity.website.front.model
{
	import com.youcity.website.front.vo.CityVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class CityModelLocator{
	 	
	 	private static var _instance:CityModelLocator;
	 	
	 	public function CityModelLocator()
	 	{
	 		if (_instance)
	 		{
	 			throw(new Error("ERROR!"));
	 		}
	 	}
	 	
	 	public static function getInstance():CityModelLocator
	 	{
	 		if (!_instance)
	 		{
	 			_instance = new CityModelLocator();
	 		}
	 		return _instance;
	 	}
	 	
		[ArrayElementType("com.youcity.website.front.vo.StationVO")]
		public var routStations:ArrayCollection;
		
		public var currentCity:CityVO;
		
		public var cities:Dictionary = new Dictionary(true);
		 
	}
}


 
