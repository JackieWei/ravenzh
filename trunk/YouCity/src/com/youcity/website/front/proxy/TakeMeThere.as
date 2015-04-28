package com.youcity.website.front.proxy
{
	import com.youcity.maps.MapPoint;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.website.front.view.common.MapManager;
	
	public class TakeMeThere
	{
		private var _offsetX:Number;
		private var _offsetY:Number;
		
		private var _newCenter:MapPoint;
		
		private var map:MapManager = MapManager.getInstance();
		
		private var _delegate:HotspotHoveDelegate;
		
		private var _refId:String;
		public function get refId():String
		{
			return _refId;
		}
		
		public function TakeMeThere(centerX:Number, centerY:Number, width:Number, height:Number, id:String, type:String)
		{
			_refId = id;
			_newCenter = new MapPoint(centerX, centerY);
			_offsetX = width/2;
			_offsetY = height/2;
			_delegate = new HotspotHoveDelegate(id, type);
		}
		
		public function clear():void
		{
			_delegate.remove();
		}
		
		public function locate():void
		{
			var center:ScreenPoint = _newCenter.toScreenPoint(map.zoom);
			center.offset(_offsetX, _offsetY);
			map.slideScreenCenter(center);
		}
	}
}

import mx.core.UIComponent;
import com.youcity.website.front.event.OtherEvent;
import com.youcity.website.front.view.common.CallbackData;
import com.youcity.website.front.vo.PolyGonVO;
import mx.utils.StringUtil;
import flash.geom.Point;
import com.youcity.maps.MapPoint;
import flash.display.Sprite;
import com.youcity.maps.overlays.OverlayBase;
import com.youcity.website.front.view.common.MapManager;
import com.youcity.maps.ScreenPoint;
import com.youcity.maps.MapConstants;
import com.youcity.maps.MapEvent;
import flash.events.Event;
import com.youcity.website.front.proxy.ProxyBase;

class HotspotHoveDelegate
{
	private var map:MapManager = MapManager.getInstance();
	private var _hoverSpot:HoverShape;
	
	private var _polygon:PolyGonVO;
	public function HotspotHoveDelegate(id:String, refType:String)
	{
		new GetPolyGonById(id, int(refType), callbackHandler, null);
	}
	
	private function callbackHandler(callbackData:CallbackData):void
	{
		if (CallbackData.SUCCEED == callbackData.code)
		{
			_polygon = PolyGonVO(callbackData.data);
			draw();
		}
	}
	
	private function draw():void
	{
		var coords:Array = _polygon.polygonList.source;
		var splitCoords:Array = [];
		while(coords.length > 0)
		{
			var element:String = StringUtil.trim(String(coords.pop()));
			var str:String = element.substr(0, element.length - 1);
			var arr:Array = str.split(",");
			var coordArr:Array = [];
			while(arr.length > 0)
			{
				var e_1:Number = Number(arr.pop());
				var e_2:Number = Number(arr.pop());
				coordArr.push(new MapPoint(e_1, e_2));
			}
			splitCoords.push(coordArr);
		}
		var position:MapPoint = MapPoint(splitCoords[0][0]);
		var _position:ScreenPoint = position.toScreenPoint(map.zoom);
		_hoverSpot = new HoverShape(_position, splitCoords);
		add();
	}
	
	public function add():void
	{
		if (_hoverSpot) map.addOverlay(_hoverSpot);
	}
	
	public function remove():void
	{
		if (_hoverSpot) map.removeOverlay(_hoverSpot);
	}
}

class HoverShape extends OverlayBase
{
	private var _position:ScreenPoint;
	private var _coords:Array;
	private var map:MapManager = MapManager.getInstance();
	public function HoverShape(position:ScreenPoint, coords:Array)
	{
		super(this, position);
		_position = position;
		_coords = coords;
		map.addEventListener(MapEvent.ZOOM_CHANGED, onZoomChangeHandler);
		drawShape(_position,_coords);
	}
	
	private function onZoomChangeHandler(event:Event):void
	{
		drawShape(_position,_coords);
	}
	
	private function drawShape(position:ScreenPoint, coords:Array):void
	{
		graphics.clear();
		var item:Array;
		for (var i:uint = 0; i < coords.length; i++)
		{
			item = coords[i] as Array;
			parsePointAndDraw(item, position);
		}
	}
	
	private function parsePointAndDraw(array:Array, ltPoint:ScreenPoint):void
	{
		graphics.lineStyle(MapConstants.HOTSPOT_LINE_WIDTH, MapConstants.HOTSPOT_LINE_COLOR, MapConstants.HOTSPOT_LINE_ALPHA);
		graphics.beginFill(MapConstants.HOTSPOT_FILL_COLOR, MapConstants.HOTSPOT_FILL_ALPHA);
		var item:MapPoint;
		var lt:ScreenPoint = ltPoint.toZoom(map.zoom);
		for (var i:uint = 0; i < array.length; i++)
		{
			item = MapPoint(array[i]);
			var tmpPoint:ScreenPoint = item.toScreenPoint(map.zoom);
			
			var x:Number = (tmpPoint.x - lt.x);
			var y:Number = (tmpPoint.y - lt.y);
			
			if (0 == i) 
			graphics.moveTo(x, y)
			else if (array.length != i)
				graphics.lineTo(x, y);
		}
		graphics.endFill();
	}
}

class GetPolyGonById extends ProxyBase
{
	public function GetPolyGonById(id:String, refType:int, callback:Function, container:UIComponent)
	{
		super(callback, container);
		var event:OtherEvent = new OtherEvent(OtherEvent.GET_POLYGON_BY_REFID);
		event.data = {refId:id, refType:refType};
		dispatchEvent(event);
	}
}
