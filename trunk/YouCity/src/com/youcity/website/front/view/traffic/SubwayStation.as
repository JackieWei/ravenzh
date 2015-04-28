package com.youcity.website.front.view.traffic
{
	import com.youcity.maps.MapEvent;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.overlays.OverlayBase;
	import com.youcity.maps.util.MapUtil;
	import com.youcity.website.front.view.common.MapManager;
	import com.youcity.website.front.vo.StationVO;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;

	public class SubwayStation extends OverlayBase
	{
		[Embed(source="assets/traffic/subway_station_normal.png")]
		[Bindable]
		private static var NORMAL:Class;
		
		[Embed(source="assets/traffic/subway_station_over.png")]
		[Bindable]
		private static var OVER:Class;
		
		[Embed(source="assets/traffic/subway_station_selected_normal.png")]
		[Bindable]
		private static var SELECTED_NORMAL:Class;
		
		[Embed(source="assets/traffic/subway_station_selected_over.png")]
		[Bindable]
		private static var SELECTED_OVER:Class;
		
		private var _over:Bitmap;
		private var _selected_normal:Bitmap;
		private var _selected_over:Bitmap;
		private var _normal:Bitmap;
		private static var _maxWidth:uint = 43;
		private static var _maxHeihgt:uint = 81;
		private function contructSkins():void
		{
			_normal = new NORMAL();
			setSkinPosition(_normal);
			_over = new OVER();
			setSkinPosition(_over);
			_selected_normal = new SELECTED_NORMAL();
			setSkinPosition(_selected_normal);
			_selected_over = new SELECTED_OVER();
			setSkinPosition(_selected_over);
		}
		private function setSkinPosition(target:Bitmap):void
		{
			target.x = (_maxWidth - target.width)/2;
			target.y = (_maxHeihgt - target.height)/2;
		}
		
		private var _SkinContainer:Sprite = new Sprite();
		private function setSkinSize(width:uint, height:uint):void
		{
			_over.width = width;
			_selected_normal.width = width;
			_selected_over.width = width;
			_normal.width = width;
			_over.height = height;
			_selected_normal.height = height;
			_selected_over.height = height;
			_normal.height = height;
		}
		private function getSkinSize():Point
		{
			var bm:Bitmap = Bitmap(_SkinContainer.getChildAt(0));
			return new Point(bm.width, bm.height);
		}
		private function setSkin(target:Bitmap):void
		{
			MapUtil.removeAllChildren(_SkinContainer);
			_SkinContainer.addChild(target);
		}
		
		
		private var map:MapManager = MapManager.getInstance();
		
		private var origW:uint;
		private var origH:uint;
		
		private var _data:StationVO;
		
		private var _tip:UIComponent;
		private function constructTip():void
		{
			_tip = new StationTip();
		}
		
		public function SubwayStation(position:ScreenPoint, data:StationVO)
		{
			super(this, position);
			_data = data;
			buttonMode = true;
			contructSkins();
			constructTip();
			addChild(_SkinContainer);
			map.addEventListener(MapEvent.ZOOM_CHANGED, onZoomChangedHandler);
			addEventListener(MouseEvent.CLICK, onClickHandler);
			init();
			setSize();
		}
		
		private function init():void
		{
			origW = _maxWidth;
			origH = _maxHeihgt;
			setSkin(_normal);
			addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		
		private function onClickHandler(event:MouseEvent):void
		{
			TrafficProxy.instance.openWin(amendPosition(position), _data);
		}
		
		private function amendPosition(position:ScreenPoint):ScreenPoint
		{
			return new ScreenPoint(position.zoom, position.x + width / 2, position.y - height);
		}
		
		private function onZoomChangedHandler(event:Event):void
		{
			setSize();
		}
		
		private function setSize():void
		{
			if (0 == map.zoom || 1 == map.zoom)
			{
				offsetX = origW/2;
				offsetY = origH;
			}
			else
			{
				offsetX = origW/4;
				offsetY = origH/2;
			}
			setSkinSize(offsetX * 2, offsetY);
			if (_tip)
				_tip.x = getSkinSize().x + 3;
			setOverlayPosition(position);
		}
		
		private function onOverHandler(event:MouseEvent):void
		{
			if (_shiny)
			{
				setSkin(_selected_over);
			}
			else
			{
				setSkin(_over);
			}
		}
		
		private function onOutHandler(event:MouseEvent):void
		{
			if (_shiny)
			{
				setSkin(_selected_normal);
			}
			else
			{
				setSkin(_normal);
			}
		}
		
		private var _shiny:Boolean;
		public function set shiny(value:Boolean):void
		{
			if (_shiny == value) return;
			_shiny = value;
			if (_shiny)
			{
				addChild(_tip);
				_tip.name = _data.name;
				setSkin(_selected_normal);
			}
			else
			{
				removeChild(_tip);
				setSkin(_normal);
			}
		}
	}
}