package com.youcity.website.front.view.menu
{
	import com.adobe.cairngorm.vo.IValueObject;
	import com.youcity.maps.MapPoint;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.overlays.Marker;
	import com.youcity.maps.overlays.OverlayBase;
	import com.youcity.website.front.common.AssetsEmbed;
	import com.youcity.website.front.view.common.MapManager;
	
	import flash.utils.Dictionary;
	
	import gs.TweenLite;
	
	public class MarkerManager
	{
		public static const STARBUCKS:String = "starbucks";
		public static const RESTAURANTS:String = "restaurants";
		public static const SHOPPING:String = "shopping";
		public static const HOTELS:String = "hotels";
		public static const MUSEUMS:String = "museums";
		public static const HOT_EVENT:String = "hot_event";		
		
		private static var mapManager:MapManager = MapManager.getInstance();
		private static var _markerDictionary:Dictionary = new Dictionary(true);
		
		private static var index:uint = 0;
		public static function addMarkers(key:String, value:Array):void
		{
//			if (key == HOT_EVENT)
//			{
//				_markerDictionary[key] = value;
//				mapManager.addOverlay(value[index]);
//				index ++;
//				while (index < value.length)
//				{
//					TweenLite.delayedCall(0.5, addMarkers, [key, value]);
//				}
//				return;
//			}
			_markerDictionary[key] = value;
			for each(var marker:OverlayBase in value)
			mapManager.addOverlay(marker);
		}
		
		public static function removeMarkers(key:String):void
		{
			var markers:Array = [];
			if (_markerDictionary[key] is Array)
			{
				markers = _markerDictionary[key];
				for each(var marker:OverlayBase in markers)
				mapManager.removeOverlay(marker);
			}
			delete _markerDictionary[key];
		}
		
		public static function generateMarker(type:String, point:MapPoint, data:IValueObject):OverlayBase
		{
			var marker:OverlayBase;
			var screenPoint:ScreenPoint = point.toScreenPoint(mapManager.zoom);
			switch (type)
			{
				case STARBUCKS:
					marker = new Marker(screenPoint, AssetsEmbed.STARBUCKS);
					break;
				case RESTAURANTS:
					marker = new Marker(screenPoint, AssetsEmbed.BUILDING_ICON);
					break;
				case SHOPPING:
					marker = new Marker(screenPoint, AssetsEmbed.SHOPPING);
					break;
				case HOTELS:
					marker = new Marker(screenPoint, AssetsEmbed.HOTELS);
					break;
				case MUSEUMS:
					marker = new Marker(screenPoint, AssetsEmbed.MUSEUMS);
					break;
			}
			return marker;
		}
	}
}