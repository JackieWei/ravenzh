package com.youcity.website.front.view.traffic
{
	import com.youcity.maps.MapPoint;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.overlays.OverlayBase;
	import com.youcity.website.front.common.Constants;
	import com.youcity.website.front.view.common.MapManager;
	import com.youcity.website.front.view.common.ViewManager;
	import com.youcity.website.front.vo.StationVO;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	public class TrafficProxy
	{
		private static var _instance:TrafficProxy;
		private static var key:Boolean;
		private var map:MapManager = MapManager.getInstance();
		
		public static function get instance():TrafficProxy
		{
			if (!_instance)
			{
				key = true;
				_instance = new TrafficProxy();
			}
			return _instance;
		}
		public function TrafficProxy()
		{
			if (!key)
			{
				throw new Error("Singleton");
				return;
			}
			key = false;
		}
		
		public function openRouteView(routeId:String):void
		{
			SubwayModel.currentRoute = routeId;
			shinyRoute(routeId);
			TrafficEventDisptacher.instance.dispatchEvent(new Event(TrafficEventDisptacher.CURRENT_ROUTE_CHANGE));
			ViewManager.getInstance().openView("routeView");
			closeWin();
		}
		
		public function closeRouteView():void
		{
			SubwayModel.currentRoute = null;
			extinctRoute();
			ViewManager.getInstance().closeView("routeView");
		}
		
		public function getRouteIcon(routeId:String, type:uint):String
		{
			var name:String;
			if (0 == type)
			{
				name = routeId + routeId + ".png";
			}
			else if (1 == type)
			{
				name = routeId + routeId + routeId + ".png";
			}
			else if (2 == type)
			{
				name = routeId + ".png";
			}
			return name ? SubwayModel.ROUTE_PREFIX + "/" + name : "";
		}
		
		public function getRouteStations(routeId:String, callback:Function, vessel:UIComponent):void
		{
			new GetRouteStations(routeId, callback, vessel);
		}
		
		private var _winOpened:Boolean;
		public function openWin(position:ScreenPoint, data:StationVO):void
		{
			if (_winOpened) return;
			if (!SubwayModel.infoWin)
			{
				SubwayModel.infoWin = new SubwayInfo(position);
			}
			map.openInfoWindow(SubwayModel.infoWin);
			SubwayModel.infoWin.setOverlayPosition(position);
			SubwayModel.subWayInfo = data;
			_winOpened = true;
		}
		
		public function closeWin():void
		{
			if (!_winOpened) return;
			if (!SubwayModel.infoWin) return;
			map.closeInfoWindow(SubwayModel.infoWin);
			_winOpened = false;
		}
		
		
		public function initSubwayData():void
		{
			new SubWayData(Constants.SUBWAY_DATA, onSubWayCallback, setProgress);
		}
		
		private function onSubWayCallback(data:XML):void
		{
			var src:Array = [];
			var length:uint = data["s"].length();
			var item:XMLList;
			var station:StationVO;
			for (var i:uint = 0; i < length; i++)
			{
				station = new StationVO();
				item = XMLList(data["s"][i]);
				station.routeId = item[0].i;
				station.name = item[0].n;
				station.description = item[0].r;
				station.pointX = item[0].x;
				station.pointY = item[0].y;
				src.push(station);
			}
			SubwayModel.subwayStations = src;
		}
		
		private var _stations:Array;
		
		public function addSubWay():void
		{
			if (_stations && _stations.length > 0) removeSubway();
			_stations = [];
			var item:StationVO;
			var station:SubwayStation;
			for (var i:uint = 0; i < SubwayModel.subwayStations.length; i++)
			{
				item = StationVO(SubwayModel.subwayStations[i]);
				var position:MapPoint = new MapPoint(Number(item.pointX), Number(item.pointY));
				station = new SubwayStation(position.toScreenPoint(map.zoom), item);
				map.addOverlay(station);
				_stations.push(station);
			}
		}
		
		public function removeSubway():void
		{
			if (!_stations) return;
			while(_stations.length > 0)
			{
				map.removeOverlay(OverlayBase(_stations.pop()));
			}
		}
		
		public function shinyRoute(routeId:String):void
		{
			if (!SubwayModel.subwayStations || SubwayModel.subwayStations.length <= 0) return;
			var stations:Array = SubwayModel.subwayStations;
			var station:StationVO;
			var station_marker:SubwayStation;
			for (var i:uint = 0; i < stations.length; i++)
			{
				station = StationVO(stations[i]);
				station_marker = SubwayStation(_stations[i]);
				station_marker.shiny = station.routes.indexOf(routeId) >= 0 ? true : false;
			}
		}
		
		public function extinctRoute():void
		{
			if (!SubwayModel.subwayStations || SubwayModel.subwayStations.length <= 0) return;
			var station_marker:SubwayStation;
			for (var i:uint = 0; i < _stations.length; i++)
			{
				SubwayStation(_stations[i]).shiny = false;
			}
		}
		
		
		private function setProgress(loaded:Number, total:Number):void
		{
			
		}
	}
}
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import mx.core.UIComponent;
import com.youcity.website.front.event.CityEvent;
import com.youcity.website.front.proxy.ProxyBase;

class GetRouteStations extends ProxyBase
{
	public function GetRouteStations(routeId:String, callback:Function, vessel:UIComponent)
	{
		super(callback, vessel);
		var e:CityEvent = new CityEvent(CityEvent.GET_ROUTE_STATIONLIST);
		e.data = {routeId:routeId};
		dispatchEvent(e);
	}
}

class SubWayData
{
	private var _loader:URLLoader;
	private var _request:URLRequest;
	private var _callback:Function;
	private var _setProgress:Function;
	
	public function SubWayData(url:String, callback:Function, setProgress:Function = null)
	{
		if (null != callback)
			_callback = callback;
		if (null != setProgress)
			_setProgress = setProgress;
		
		_loader = new URLLoader();
		_request = new URLRequest(url);
		_loader.addEventListener(Event.COMPLETE, onCompleteHandler);
		_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandledr);
		_loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
		_loader.load(_request);
	}
	
	protected function onCompleteHandler(event:Event):void
	{
		if (null != _callback)
		{
			var data:XML = XML(_loader.data);
			_callback(data);
		}
		clear();
	}
	
	protected function onIOErrorHandledr(event:IOErrorEvent):void
	{
		clear();
	}
	
	protected function onProgressHandler(event:ProgressEvent):void
	{
		if (null != _setProgress)
			_setProgress(event.bytesLoaded, event.bytesTotal);
	}
	
	public function clear():void
	{
		_loader = null;
		_request = null;
		_callback = null;
		_setProgress = null;
	}
}