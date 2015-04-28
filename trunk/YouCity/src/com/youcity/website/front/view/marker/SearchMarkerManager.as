/**
 * Copyright 2009 www.YouCity.com
 * 
 * All right reserved.
 *
 * Create on 2009
 */
package com.youcity.website.front.view.marker
{
	import com.youcity.maps.MapPoint;
	import com.youcity.website.front.view.search.marker.SearchMarker;
	
	public class SearchMarkerManager extends MarkerManager
	{
		private static var _instance:SearchMarkerManager;
		
		private static var flag:Boolean=true;
		
		public static function getInstance():SearchMarkerManager{
			if (!_instance)
	 		{
	 			flag = false;
	 			_instance = new SearchMarkerManager();
	 			flag = true;
	 		}
	 		return _instance;
		}
		
		public function SearchMarkerManager()
		{
	 		if (flag)
	 		{
	 			throw(new Error("SINGTON ERROR!"));
	 		}
		}
		
		override protected function getMarker(item:Object, index:int):FrontMarker
		{
			var center:MapPoint = new MapPoint(item.centerX, item.centerY);
			var marker:SearchMarker = new SearchMarker(center.toScreenPoint(map.zoom), item, index);
			return marker;
		}
	}
}