package com.youcity.website.front.view.common
{
	import com.youcity.maps.IMapType;
	import com.youcity.maps.LatLngPoint;
	import com.youcity.maps.Map;
	import com.youcity.maps.MapBound;
	import com.youcity.maps.MapEvent;
	import com.youcity.maps.MapEventDispatcher;
	import com.youcity.maps.MapPoint;
	import com.youcity.maps.MapTypeConstants;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.controls.MiniMapControlContainer;
	import com.youcity.maps.controls.PositionControl;
	import com.youcity.maps.controls.StandardControlContainer;
	import com.youcity.maps.overlays.InfoWindow;
	import com.youcity.maps.overlays.LineDrawer;
	import com.youcity.maps.overlays.OverlayBase;
	import com.youcity.website.front.common.AssetsEmbed;
	import com.youcity.website.front.controller.OtherED;
	import com.youcity.website.front.event.MapManagerEvent;
	import com.youcity.website.front.model.OtherModelLocator;
	import com.youcity.website.front.view.ads.base.AdsManager;
	import com.youcity.website.front.view.building.BuildingProxy;
	import com.youcity.website.front.view.components.MapActionTip;
	import com.youcity.website.front.view.search.SearchProxy;
	import com.youcity.website.front.view.traffic.TrafficProxy;
	import com.youcity.website.front.vo.BuildingVO;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	
	[Event(name="enclosure", 			type="com.youcity.website.front.event.MapManagerEvent")]
	[Event(name="enclosure_end", 		type="com.youcity.website.front.event.MapManagerEvent")]
	[Event(name="end_adding_marker", 	type="com.youcity.website.front.event.MapManagerEvent")]
	[Event(name="end_drawing_line", 	type="com.youcity.website.front.event.MapManagerEvent")]

	[Event(name="pisitionChange", 	type="com.youcity.website.front.event.MapManagerEvent")]
	
	public class MapManager extends EventDispatcher
	{
		private static const TIME_INTERVAL:Number = 0.2;
		private static const HINT_DRAW_LINE_1:String = "click and begin to draw";
		private static const HINT_DRAW_LINE_2:String = "double click to finish drawing";
		private static const HINT_ADD_MARKER:String = "click me and put me down";
		private static const HINT_ENCLOSURE:String = "Drag to draw area";
		
		public static const STATE_SELECTE_ACTIVITY_BUILDING:String = "select_activity_building";
		public static const STATE_SELECTE_BUSINESS_BUILDING:String = "select_business_building";
		public static const STATE_SELECTE_BUSINESS_HOST_BUILDING:String = "state_selecte_business_host_building";
		public static const STATE_SELECTE_BUSINESS_HOST_BUSINESS:String = "state_selecte_business_host_business";
		public static const STATE_NORMAL:String = "state_normal";
		
		private var _mapContainer:UIComponent;
		
		private static var _instance:MapManager;
		
		public function get graphics():Graphics
		{
			return _mapContainer.graphics;
		}
		
		private var _state:String = STATE_NORMAL;
		public function get state():String
		{
			return _state;
		}
		public function set state(value:String):void
		{
			this._state = value;
		}
		
		public function get zoom():uint
		{
			return _map.zoom;
		}
		
		public function get center():MapPoint
		{
			return _map.center;
		}
		
		public function get maptype():IMapType
		{
			return _map.currentMapType;
		}
		
		public function setDirection(value:String):void
		{
			_map.currentMapType.direction = value;
		}
		
		public function changeCity(cityName:String):void
		{
			_map.changedCity(cityName);
		}
		
		private var _positionControl:PositionControl;
		public function get positionControl():PositionControl
		{
			if (!_positionControl) _positionControl = new PositionControl(_map);
			return _positionControl;
		}
		
		public static function getInstance():MapManager
		{
			if (!_instance)
				_instance = new MapManager(new MapKey());
			return _instance;
		}
		
		public function MapManager(key:MapKey)
		{
		}
		
		private var _map:Map;
		private var _center:MapPoint;
		private var _zoom:uint;
		private var _viewContainer:Canvas;
		public function init(mapContainer:UIComponent):void
		{
			_zoom = 1;
			_mapContainer = mapContainer;
		}
		
		public function setInitCenter(center:MapPoint):void
		{
			_center = center;//new MapPoint(43724, 27842);
			if (_map) 
			return;
			_map = new Map();
            _map.addMapType(MapTypeConstants.getManhattan2DMap());
            _map.addMapType(MapTypeConstants.getManhattanMiniMap());
            _map.addMapType(MapTypeConstants.getManattanTransparent3DMap());
            _map.setMapType(MapTypeConstants.getManhattan3DMap());
            _map.addEventListener(MapEvent.MAP_READY, onMapReadyHandler);
            _mapContainer.addChildAt(_map, 0);
            
            _viewContainer =  new Canvas();
            _viewContainer.percentWidth = 100;
            _viewContainer.percentHeight = 100;
            _viewContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            _viewContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            FrontManager.getInstance().viewContainer.addChildAt(_viewContainer, 0);
            
            _map.writePosition = writePositionHandler;
		}
		
		[Bindable]
		public var positionDescription:String;
		
		private function writePositionHandler(position:ScreenPoint):void
		{
			positionDescription = position.toHashKey() + " and the map point is " + position.toMapPoint().toHashKey();
		}
		
		private function onMapReadyHandler(event:MapEvent):void
		{
			_map.setCenter(_center, _zoom);
			trace([_center.x, _center.y]);
			var temp:LatLngPoint;
			temp = _center.toLatLng();
			trace([temp.lng, temp.lat])
			_map.addControl(new StandardControlContainer(_map));
			_map.addControl(new MiniMapControlContainer(_map));
			_map.addEventListener(MapEvent.ZOOM_CHANGED, 	onZoomChanged);
			_map.addEventListener(MapEvent.MEASURE_START, 	onMeasureStart);
			_map.addEventListener(MapEvent.MEASURE_END, 	onMeasureEnd);
			MapEventDispatcher.getInstance().addEventListener(MapEvent.HOTSPOT_CLICKED, handleHotSpotClick);
			MapEventDispatcher.getInstance().addEventListener(MapEvent.SUBWAY_CLICKED, onSubwayClicked);
			MapEventDispatcher.getInstance().addEventListener(MapEvent.ENCLOSURE_START, onMapEnClosureHandler);
			MapEventDispatcher.getInstance().addEventListener(MapEvent.ENCLOSURE_STOP, onMapEnClosureStopHandler);
			
			//add ads
			AdsManager.instance.initialize(_map);
			AdsManager.instance.initAds();
		}
		
		public function get bound():MapBound
		{
			return _map.bound;
		}
		
		public function slideCenter(center:MapPoint, zoom:int = -1):void
		{
			_map.slideCenter(center, zoom);
		}
		
		public function slideScreenCenter(center:ScreenPoint):void
		{
			_map.slideCenter(center.toMapPoint());
		}
		
		public function moveMapByCoordinate(offsetX:int, offsetY:int):void 
		{
			_map.moveMapByCoordinate(offsetX, offsetY);
		}
		
		private function onMapEnClosureHandler(event:MapEvent):void
		{
			startEnclosure();
		}
		
		private function onMapEnClosureStopHandler(event:MapEvent):void
		{
//			stopEnclosure(true);
		}
		
		public function onSubwayClicked(event:MapEvent):void
		{
			if (event.selected)
			{
				TrafficProxy.instance.addSubWay();
			}
			else
			{
				TrafficProxy.instance.removeSubway();
				TrafficProxy.instance.closeRouteView();
			}
		}
		
		public function onZoomChanged(event:Event):void
		{
			dispatchEvent(event);
		}
		
		private function onMeasureStart(event:MapEvent):void
		{
			MapEventDispatcher.getInstance().removeEventListener(MapEvent.HOTSPOT_CLICKED, handleHotSpotClick);
		}
		
		public function onMeasureEnd(event:MapEvent):void
		{
			MapEventDispatcher.getInstance().addEventListener(MapEvent.HOTSPOT_CLICKED, handleHotSpotClick);
			var otherModel:OtherModelLocator = OtherModelLocator.getInstance();
			otherModel.measureResult = String(event.data) + "m";
			ViewManager.getInstance().openView("measureResultView");
		}
		
		public function get size():Point
		{
			if (_mapContainer) return new Point(_mapContainer.width, _mapContainer.height);
			else return new Point(0, 0)
		}
		
		public function setCenter(value:MapPoint):void
		{
			_map.setCenter(value);
		}
		
		public function mapPointToPoint(mapPoint:MapPoint):Point//把mappoint转换为鼠标位置
		{
			return screenPointToPoint(mapPoint.toScreenPoint(zoom));
		}
		
		public function screenPointToPoint(screenPoint:ScreenPoint):Point//把screenpoint转换为point
		{
			var x:Number = screenPoint.x - bound.ltPoint.x;
			var y:Number = screenPoint.y - bound.ltPoint.y;
			return new Point(x,y);
		}
		
		public function pointToMapPoint(position:Point):MapPoint//把地图上的鼠标位置转换为mappoint
		{
			return (pointToScreenPoint(position)).toMapPoint();
		}
		
		public function pointToScreenPoint(position:Point):ScreenPoint//把地图上的鼠标位置转换为ScreenPoint
		{
			var point:ScreenPoint = center.toScreenPoint(zoom);
			return new ScreenPoint(zoom, point.x - size.x / 2 + position.x, point.y  - size.y /2 + position.y);
		}
		
		private function handleHotSpotClick(event:MapEvent):void
		{
			if (state == null || state == "")
				return;
			var e:MapManagerEvent;
			var buillding:BuildingVO = temp_create_buildindVO(event.data);
			e = new MapManagerEvent(MapManagerEvent.HOTSPOT_CLIKED);
			e.data = buillding;
			dispatchEvent(e);
			switch (state)
			{
				case STATE_SELECTE_BUSINESS_BUILDING:
					OtherModelLocator.getInstance().business_host = buillding;
					OtherED.getInstance().dispatchEvent(new Event(OtherED.SELECTE_BUSINESS_BUILDING));
					break;
				case STATE_NORMAL:
					BuildingProxy.instance.openBuilding(buillding.buildingId);
					break;
				case STATE_SELECTE_BUSINESS_HOST_BUILDING: 
					
					break;
				case STATE_SELECTE_BUSINESS_HOST_BUSINESS: 
					
					break;
				default: break;
			}
		}
		
		private function temp_create_buildindVO(data:Object):BuildingVO
		{
			var bv:BuildingVO = new BuildingVO();
			bv.buildingId = data.buildingId;
			bv.buildingName = data.title;
			bv.centerX = data.buildingCenter.x;
			bv.centerY = data.buildingCenter.y;
			return bv;
		}
		
		
		public function addOverlay(overlay:OverlayBase):void
		{
			_map.addOverlay(overlay);
		}
		
		public function removeOverlay(overlay:OverlayBase):void
		{
			_map.removeOverlay(overlay);
		}
		
		public function openInfoWindow(infowin:InfoWindow):void
		{
			_map.openInfoWindow(infowin);
		}
		
		public function closeInfoWindow(infowin:InfoWindow):void
		{
			_map.closeInfoWindow(infowin);
		}
		
		private var enclosure:Enclosure;
		private var _overLayer:Canvas;
		private var _enclosureTip:MapActionTip;
		
		public function startEnclosure():void
		{
			//if there is not tip appearing on the screen , add it.
			if(!_enclosureTip)
			{
				_enclosureTip = new MapActionTip();
				_enclosureTip.tip = HINT_ENCLOSURE;
				_viewContainer.addChild(_enclosureTip);
				_enclosureTip.addEventListener(Event.ENTER_FRAME, handleEnclosureTipEnterFrameEvent);
			}
			
			//if there is not Canvas which we can draw area on, new it.
			if (!_overLayer) 
			{
				_overLayer = new Canvas();
				_overLayer.percentWidth = 100;
				_overLayer.percentHeight = 100;
			}
			
			if (!_mapContainer.contains(_overLayer))
			{
				_mapContainer.addChild(_overLayer);
			}
			
			//if there is Enclosure  instances, new it with given parameters
			if (!enclosure) 
			{
				enclosure = new Enclosure(_overLayer, enclosureCallback);
			}
			
			//start to enclosure
			enclosure.start();
		}
		
		//callback for Enclosure, when enclosureing end, invoke this method to start search
		private function enclosureCallback(start:Point, end:Point):void
		{
			//if the tip exists in the display list, remove its listener and then itself. 
			if (_enclosureTip && _viewContainer.contains(_enclosureTip))
			{
				_enclosureTip.removeEventListener(Event.ENTER_FRAME, handleEnclosureTipEnterFrameEvent);
				_viewContainer.removeChild(_enclosureTip);
				_enclosureTip = null;
			}
			//start to search
			SearchProxy.instance.openAreaSearch(_map.positionToMapPoint(start), _map.positionToMapPoint(end));
		}
		
		//stop enclosure, do some clearing work
		public function stopEnclosure(clear:Boolean = true):void
		{
			//if the tip exists in the display list, remove its listener and then itself. 
			if (_enclosureTip && _viewContainer.contains(_enclosureTip))
			{
				_enclosureTip.removeEventListener(Event.ENTER_FRAME, handleEnclosureTipEnterFrameEvent);
				_viewContainer.removeChild(_enclosureTip);
				_enclosureTip = null;
			}
			
			if (!enclosure) 
			return;
			
			//close enclosure
			enclosure.close();
			if (clear)
			{
				enclosure.clear();
				enclosure = null;
			}
			MapEventDispatcher.getInstance().dispatchEvent(new MapEvent(MapEvent.ENCLOSURE_STOP));
		}
		
		public function drawEnclosure(startPoint:MapPoint, endPoint:MapPoint):void
		{
			var tempSP:Point = _map.mapPointToPoint(startPoint);
			var tempNP:Point = _map.mapPointToPoint(endPoint);
			enclosure.drawArea(tempSP, tempNP);
		}
		
		//Handler for tip EnterFrame Event, the tip should move with the Mouse
		private function handleEnclosureTipEnterFrameEvent(event:Event):void
		{
			_enclosureTip.x = _viewContainer.mouseX + 20;
			_enclosureTip.y = _viewContainer.mouseY;
		}
		
		/*
		 DRAW LINE START
		 The following part is to add map element Marker to the map
		 We have two methods 'startAddMarker()' and 'endAddMarker()', they are all public , 
		 and then some private handlder to handle the mouse event of the marker and 
		 mapcontainer which the MARKERUI was added to.
		*/	
		private var _elemTip:MapActionTip;
		private var isDrawingLine:Boolean = false;
		private var _currentPoint:ScreenPoint;
		private var _currentLine:LineDrawer;
		private var _distanceArray:Array = new Array();
		private var _markerArray:Array = new Array();
		private var _lineArray:Array = new Array();
		private var _pointArray:Array = new Array();
		
		public function startDrawLine():void
		{
			MapEventDispatcher.getInstance().removeEventListener(MapEvent.HOTSPOT_CLICKED, handleHotSpotClick);
			isDrawingLine = true;
			if (!_elemTip || !_viewContainer.contains(_elemTip))
			{
				_elemTip = new MapActionTip();
				_elemTip.tip = HINT_DRAW_LINE_1;
				_viewContainer.addChildAt(_elemTip, 0);
				_elemTip.addEventListener(Event.ENTER_FRAME, handleElemTipEnterFrameEventWhenDrawingLine);
			}
			
			_map.doubleClickEnabled = true;
			_map.addEventListener(MouseEvent.MOUSE_DOWN, handleMapContainerMouseDownWhenDrawingLine);
			_map.addEventListener(MouseEvent.MOUSE_UP, handleMapContainerMouseUpWhenDrawingLine);
			_map.addEventListener(MouseEvent.DOUBLE_CLICK, handleMapContainerDoubleClickWhenDrawingLine);
		}
		
		public function endDrawLine():void
		{
			MapEventDispatcher.getInstance().addEventListener(MapEvent.HOTSPOT_CLICKED, handleHotSpotClick);
			CursorManager.removeAllCursors();
			isDrawingLine = false;
			
			_elemTip.removeEventListener(Event.ENTER_FRAME, handleElemTipEnterFrameEventWhenDrawingLine);
			if (_elemTip && _viewContainer.contains(_elemTip))
			{
				_viewContainer.removeChild(_elemTip);
			}
			
			_map.doubleClickEnabled = false;
			_map.removeEventListener(MouseEvent.MOUSE_DOWN, handleMapContainerMouseDownWhenDrawingLine);
			_map.removeEventListener(MouseEvent.MOUSE_UP, handleMapContainerMouseUpWhenDrawingLine);
			_map.removeEventListener(MouseEvent.MOUSE_MOVE, handleMapContainerMouseMoveWhenDrawingLine);
			_map.removeEventListener(MouseEvent.DOUBLE_CLICK, handleMapContainerDoubleClickWhenDrawingLine);
			
			_currentPoint = null;
			_currentLine = null;
			_distanceArray = new Array();
		}
		
		private function handleElemTipEnterFrameEventWhenDrawingLine(event:Event):void
		{
			_elemTip.x = _mapContainer.mouseX + 40;
			_elemTip.y = _mapContainer.mouseY - 10;
		}

		private var isMouseDown:Boolean = false;
		private var isDragd:Boolean = false;
		
		private function handleMapContainerMouseDownWhenDrawingLine(event:MouseEvent):void
		{
			isMouseDown = true;
		}
		
		private function handleMapContainerMouseUpWhenDrawingLine(event:MouseEvent):void
		{
			if (!isMouseDown) 
			return;
			isMouseDown = false;
			if (isDragd)
			{
				isDragd = false;
				return;
			}
			if (!isDrawingLine)
			{
				_map.removeEventListener(MouseEvent.MOUSE_UP, handleMapContainerMouseUpWhenDrawingLine);
				return;
			}
			
			var temSP:ScreenPoint = _map.mouseToScreen(new Point(event.currentTarget.mouseX, event.currentTarget.mouseY));
			var temMP:MapPoint = temSP.toMapPoint();
			
			doClick(temMP);
		}
		
		private function handleMapContainerMouseMoveWhenDrawingLine(event:MouseEvent):void
		{
			if (isMouseDown) isDragd = true;
			if (!_currentLine) return;
			if (!isDrawingLine)
			{
				_map.removeEventListener(MouseEvent.MOUSE_MOVE, handleMapContainerMouseMoveWhenDrawingLine);
				return;
			}
			
			var temPoint:ScreenPoint = _map.mouseToScreen(new Point(event.currentTarget.mouseX, event.currentTarget.mouseY));
			_currentLine.drawLine(temPoint);
		}
		
		private function handleMapContainerDoubleClickWhenDrawingLine(event:MouseEvent):void
		{
			doDoubleClick();
		}
		
		private function doClick(point:MapPoint):void
		{	
			_map.removeEventListener(MouseEvent.MOUSE_MOVE, handleMapContainerMouseMoveWhenDrawingLine);
			_currentPoint = point.toScreenPoint(zoom);
			_pointArray.push(point);
			_elemTip.tip = HINT_DRAW_LINE_2;
			if (_currentLine && !_currentPoint.equalsTo(_currentLine.position))
			{
				_currentLine.drawLine(_currentPoint);
				_distanceArray.push(this._map.point_measure(_currentLine.position, _currentPoint));
			}
			
			_currentLine = new LineDrawer(_currentPoint);
			addOverlay(_currentLine);
			_lineArray.push(_currentLine);
			
			_map.addEventListener(MouseEvent.MOUSE_MOVE, handleMapContainerMouseMoveWhenDrawingLine);
		}
		
		private function doDoubleClick():void
		{
			endDrawLine();
		}
		
		/* Add markers and lines START
		 * When browse the someone's personal map. add marker and line to the map
		 *Include two public methods. 
		 */		
		private var mapElemDictionary:Dictionary = new Dictionary();
	}
}

import flash.geom.Point;
import com.youcity.maps.Map;
import mx.core.Container;
import flash.events.MouseEvent;
import com.youcity.maps.ScreenPoint;
import flash.display.Graphics;
import mx.core.UIComponent;
import flash.utils.Endian;
import com.youcity.maps.MapEvent;
import com.youcity.website.front.view.common.MapManager;
import com.youcity.website.front.event.MapManagerEvent;

class Enclosure
{
	private var _start:Point
	private var _end:Point;
	private var _container:UIComponent;
	private var _enclosureing:Boolean;
	private var _callback:Function;
	private var _map:Map;
	public function Enclosure(container:UIComponent, callback:Function, map:Map = null)
	{
		_container = container;
		_callback = callback;
	}
	
	public function start():void
	{
		_container.addEventListener(MouseEvent.MOUSE_DOWN, onStartHandler);
		_container.addEventListener(MouseEvent.MOUSE_MOVE, onDrawHandler);
		_container.addEventListener(MouseEvent.MOUSE_UP, onEndHandler);
	}
	
	public function clear():void
	{
		_container.graphics.clear();
		if (_container.parent)
		{
			_container.parent.removeChild(_container);
		}
		_container  = null;
		_map = null;
		_enclosureing = false;
	}
	
	public function close():void
	{
		_container.removeEventListener(MouseEvent.MOUSE_DOWN, onStartHandler);
		_container.removeEventListener(MouseEvent.MOUSE_MOVE, onDrawHandler);
		_container.removeEventListener(MouseEvent.MOUSE_UP, onEndHandler);
		_container.graphics.clear();
	}
	
	private function onStartHandler(event:MouseEvent):void
	{
		event.stopImmediatePropagation();
		_container.graphics.clear();
		_enclosureing = true;
		_start = new Point(_container.mouseX, _container.mouseY);
	}
	
	private function onDrawHandler(event:MouseEvent):void
	{
		event.stopPropagation();
		if (!_enclosureing) 
		return;
		_end = new Point(_container.mouseX, _container.mouseY);
		drawArea(_start, _end);
	}
	
	private function onEndHandler(event:MouseEvent):void
	{
		event.stopPropagation();
		if (!_enclosureing) 
		return;
		_enclosureing = false;
		if ( _callback && _start && _end)
		_callback(_start, _end);
		MapManager.getInstance().dispatchEvent(new MapManagerEvent(MapManagerEvent.ENCLOSURE_END));
	}
	
	//public method for drawing area
	public function drawArea(startPoint:Point, endPoint:Point):void
	{
		var tempWidth:Number =  endPoint.x - startPoint.x;
		var tempHeight:Number =  endPoint.y - startPoint.y;
		
		var graphic:Graphics = _container.graphics;
		graphic.clear();
		graphic.lineStyle(2, 0x9400D3, .8);
		graphic.beginFill(0x87CEEB, .3);
		graphic.drawRect(startPoint.x, startPoint.y, tempWidth, tempHeight);
		graphic.endFill();
	}
	
	
}
//for internal usage
internal class MapKey
{
	
}