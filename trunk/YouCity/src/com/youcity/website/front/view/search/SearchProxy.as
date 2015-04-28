package com.youcity.website.front.view.search
{
	import com.youcity.maps.MapPoint;
	import com.youcity.website.front.common.Constants;
	import com.youcity.website.front.model.SearchModelLocator;
	import com.youcity.website.front.view.common.MapManager;
	import com.youcity.website.front.view.common.ViewManager;
	
	import flash.geom.Point;
	
	public class SearchProxy
	{
		private static var _instance:SearchProxy;
		private static var key:Boolean;
		public static function get instance():SearchProxy
		{
			if (!_instance)
			{
				key = true;
				_instance = new SearchProxy();
			}
			return _instance;
		}
		public function SearchProxy()
		{
			if (!key)
			{
				throw new Error("Singleton");
				return;
			}
			key = false;
		}
		
		private var searchModel:SearchModelLocator = SearchModelLocator.getInstance();
		
		public function openNearBySearch(center:MapPoint, building:String):void
		{
			searchModel.centerPoint = center;
			searchModel.buildingName = building;
			searchModel.isNearBySearch = true;
			searchModel.area_start = new MapPoint(0, 0);
			searchModel.area_start.x = center.x - Constants.NEARBY_SEARCH_OFFSET_X;
			searchModel.area_start.y = center.y - Constants.NEARBY_SEARCH_OFFSET_Y;
			searchModel.area_end = new MapPoint(0, 0);
			searchModel.area_end.x = center.x + Constants.NEARBY_SEARCH_OFFSET_X;
			searchModel.area_end.y = center.y + Constants.NEARBY_SEARCH_OFFSET_Y;
			MapManager.getInstance().startEnclosure();
			MapManager.getInstance().drawEnclosure(searchModel.area_start, searchModel.area_end);
			ViewManager.getInstance().openView("searchView", new Point(200, 100));
		}
		
		public function openAreaSearch(start:MapPoint, end:MapPoint):void
		{
			searchModel.isAreaSearch = true;
			searchModel.area_start = start;
			searchModel.area_end = end;
			ViewManager.getInstance().openView("searchView", new Point(200, 100));
		}
		
		public function openSearch(param:Object = null):void
		{
			if (param != null)
			{
				if (param.keyword != undefined)
				searchModel.keyword = param.keyword;
				if (param.searchType != undefined)
				searchModel.searchType = param.searchType;
			}
			ViewManager.getInstance().openView("searchView", new Point(200, 100));
		}
		
		public function finishSearch():void
		{
			searchModel.area_start = null;
			searchModel.area_end = null;
			searchModel.centerPoint = null;
			searchModel.buildingName = "";
			searchModel.category = 0;
			searchModel.keyword = "";
			searchModel.isNearBySearch = false;
			searchModel.isAreaSearch = false;
		}
		
		
	}
}