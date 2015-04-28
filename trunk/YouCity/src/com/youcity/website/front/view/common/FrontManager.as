package com.youcity.website.front.view.common
{
	import com.youcity.maps.MapPoint;
	import com.youcity.maps.overlays.OverlayBase;
	import com.youcity.website.front.common.Config;
	import com.youcity.website.front.view.business.BusinessProxy;
	import com.youcity.website.front.view.menu.MarkerManager;
	import com.youcity.website.front.view.traffic.TrafficProxy;
	
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.UIComponent;
	
	public final class FrontManager extends EventDispatcher
	{
		private static var _instance:FrontManager;
		public static function getInstance():FrontManager
		{
			if (!_instance)
			_instance = new FrontManager();
			return _instance;
		}
		
		public function FrontManager()
		{   
			if (_instance)
			throw new Error("Singleton class pls use getInstance");
		}
		
		private var _mapContainer:UIComponent;
		private var _viewContainer:UIComponent;
		public function get viewContainer():UIComponent
		{
			return _viewContainer;
		}
		
		private var _systemContainer:UIComponent;
		public function get systemContainer():UIComponent
		{
			return _systemContainer;
		}
		
		public function init(mapContainer:UIComponent, viewContainer:UIComponent, systemContainer:UIComponent):void
		{
			_mapContainer = mapContainer;
			_viewContainer = viewContainer;
			_systemContainer = systemContainer;
			
			initMap();
			initView();
			QueryManager.instance.init();
			preloadData();
		}
		
		//初始化ViewContainer
		private function initView():void {
			ViewManager.getInstance().init(_viewContainer);
		}
		
		//初始化Map
		public function initMap():void {
			MapManager.getInstance().init(_mapContainer);
			if (!Config.NEED_LOCATE_NEW_CENTER) {
				var center:MapPoint = new MapPoint(43724,27842);
				MapManager.getInstance().setInitCenter(center);
			}
		}
		
		//预加载相关数据， 包括activity，business的Category和tags；地图上的地萜数据
		private function preloadData():void {
			BusinessProxy.instance.getCategory(null);
			BusinessProxy.instance.getTags(null);
			TrafficProxy.instance.initSubwayData();
		}
		
	}
	
}
