package com.youcity.maps.controls
{
	import com.youcity.maps.AssetsEmbed;
	import com.youcity.maps.Map;
	import com.youcity.maps.MapEvent;
	import com.youcity.maps.MapEventDispatcher;
	import com.youcity.maps.MapTypeConstants;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MapTypeContainer extends ControlContainer
	{
		private var _2D:Bitmap;
		private var _2DContainer:Sprite;
		private var _3D:Bitmap;
		private var _3DContainer:Sprite;
		private var _sat:Bitmap;
		private var _satContainer:Sprite;
		private var _clarity:Bitmap;
		private var _measureContainer:Sprite;
		private var _measure:Bitmap;
		private var _clarityContainer:Sprite;
		private var _controlWidth:Number;
		private var _y:Number = 2;
		private var _right:Number = 20;
		private var _spacer:Number = 3;
		private var _control:MapTypeControl;
		private var _enclosure:EnclosureButton;
		private var _subway:Bitmap;
		private var _subwayContainer:Sprite;
		/* private var _transParent3D:Bitmap;
		private var _transParent3DContainer:Sprite; */
		private var _road:RoadControl;
		
		private var _positionControl:PositionControl;
		
		private var MAPTYPE_2D:Class = AssetsEmbed.MAPTYPE_2D;
		private var MAPTYPE_3D:Class = AssetsEmbed.MAPTYPE_3D;
		private var MAPTYPE_SAT:Class = AssetsEmbed.MAPTYPE_SAT;
		private var MAPTYPE_CLARITY:Class = AssetsEmbed.MAPTYPE_CLARITY;
		private var MEASURE:Class = AssetsEmbed.MEASURE;
		private var SUBWAY:Class = AssetsEmbed.SUBWAY;
		private var TRANSPARENT_3D:Class = AssetsEmbed.MAPTYPE_3D;
		
		private var _measureing:Boolean;
		private var _enclosuring:Boolean;
		
		public function MapTypeContainer(map:Map)
		{
			super(map);
			_positionControl = new PositionControl(map);
			_control = new MapTypeControl(map);
			map.addEventListener(MapEvent.MAP_SIZE_CHANGED, handleMapSizeChangedEvent);
			map.addEventListener(MapEvent.MEASURE_END, onMeaureEndHandler);
			map.addEventListener(MapEvent.MEASURE_START, onMeaureStartHandler);
			MapEventDispatcher.getInstance().addEventListener(MapEvent.ENCLOSURE_STOP, onEnClosureStopHandler);
			_2D = new MAPTYPE_2D();
			_2DContainer = new Sprite();
			_2DContainer.buttonMode = true;
			_3D = new MAPTYPE_3D();
			_3DContainer = new Sprite();
			_3DContainer.buttonMode = true;
			_subway = new SUBWAY();
			_subwayContainer = new Sprite();
			_subwayContainer.buttonMode = true;
//			_transParent3D = new TRANSPARENT_3D();
//			_transParent3DContainer = new Sprite();
//			_transParent3DContainer.buttonMode = true;
			_sat = new MAPTYPE_SAT();
			_satContainer = new Sprite();
			_satContainer.buttonMode = true;
			_measure = new MEASURE();
			_measureContainer = new Sprite();
			_measureContainer.buttonMode = true;
			_clarity = new MAPTYPE_CLARITY();
			_clarityContainer = new Sprite()
			_clarityContainer.buttonMode = true;
			_road = new RoadControl();
			_enclosure = new EnclosureButton();
			_controlWidth = 0;
			drawMapType();
			placeControl();
		}
		
		private function drawMapType():void
		{
			//if (map.mapTypes.indexOf(MapTypeConstants.getManhattan2DMap()))
			if (true)
			{
				_enclosure.x = _controlWidth;
				_enclosure.y = 0;
				addChild(_enclosure);
				_enclosure.addEventListener(MouseEvent.CLICK, enclosureClickHandler);
				_controlWidth += _enclosure.width + _spacer;
			}
			if (true)
			{
				drawMapTypeContainer(_subwayContainer, _subway)
				_subwayContainer.x = _controlWidth;
				_subwayContainer.y = 0;
				addChild(_subwayContainer);
				_subwayContainer.addEventListener(MouseEvent.CLICK, showSubwayHandler);
				_controlWidth += _subway.width + _spacer;
			}
			if (true)
			{
				drawMapTypeContainer(_measureContainer, _measure)
				_measureContainer.x = _controlWidth;
				_measureContainer.y = 0;
				addChild(_measureContainer);
				_controlWidth += _measureContainer.width + _spacer;
			}
			if (true)
			{
				drawMapTypeContainer(_3DContainer, _3D)
				_3DContainer.x = _controlWidth;
				_3DContainer.y = 0;
				addChild(_3DContainer);
				_3DContainer.addEventListener(MouseEvent.CLICK, naviTo3DHandler);
				_3DContainer.addEventListener(MouseEvent.MOUSE_OVER, showRoadHandler);
				_3DContainer.addEventListener(MouseEvent.MOUSE_OUT, hideRoadHandler);
				_controlWidth += _3D.width + _spacer;
			}
/* 			if (true)
			{
				_road = new RoadControl();
				_road.x = _controlWidth;
				_road.y = 0;
				addChild(_road);
				_road.addEventListener(MouseEvent.CLICK, naviToTransParentHandler);
				_controlWidth += _road.width + _spacer;
			} */
//			if (true)
//			{
//				drawMapTypeContainer(_transParent3DContainer, _transParent3D);
//				_transParent3DContainer.x = _controlWidth;
//				_transParent3DContainer.y = 0;
//				_transParent3DContainer.addEventListener(MouseEvent.CLICK, naviToTransParentHandler);
//				addChild(_transParent3DContainer);
//				_controlWidth += _transParent3D.width + _spacer;
//			}
			if (true)
			{
				drawMapTypeContainer(_2DContainer, _2D);
				_2DContainer.x = _controlWidth;
				_2DContainer.y = 0;
				addChild(_2DContainer);
				_2DContainer.addEventListener(MouseEvent.CLICK, naviTo2DHandler);
				_controlWidth += _2D.width + _spacer;
			}
			if (false)
			{
				drawMapTypeContainer(_satContainer, _sat)
				_satContainer.x = _controlWidth;
				_satContainer.y = 0;
				addChild(_satContainer);
				_satContainer.addEventListener(MouseEvent.CLICK, measuareHandler);
				_controlWidth += _sat.width + _spacer;
			}
			
			if (false)
			{
				drawMapTypeContainer(_clarityContainer, _clarity);
				_clarityContainer.x = _controlWidth;
				_clarityContainer.y = 0;
				addChild(_clarityContainer);
				_clarityContainer.addEventListener(MouseEvent.CLICK, naviToClarityHandler);
				_controlWidth += _clarity.width;
			}
			
			_road.x = _3DContainer.x;
			_road.y = _3DContainer.height;
			_road.visible = false;
			_road.addEventListener(MouseEvent.CLICK, naviToTransParentHandler);
			_road.addEventListener(MouseEvent.MOUSE_OVER, showRoadHandler);
			_road.addEventListener(MouseEvent.MOUSE_OUT, hideRoadHandler);
			addChild(_road); 
		}
		
		private function naviToTransParentHandler(event:MouseEvent):void
		{
			var target:RoadControl = RoadControl(event.currentTarget);
			if (target.selected)
				_control.setMapType(MapTypeConstants.getManattanTransparent3DMap().name);
			else
				_control.setMapType(MapTypeConstants.getManhattan3DMap().name);
		}
		
		private var _show:Boolean = false;
		private function showSubwayHandler(event:MouseEvent):void
		{
			_show = !_show;
			var me:MapEvent = new MapEvent(MapEvent.SUBWAY_CLICKED);
			me.selected = _show;
			MapEventDispatcher.getInstance().dispatchEvent(me);
		}
		
		private function enclosureClickHandler(event:MouseEvent):void
		{
			if (_measureing) return;
			_enclosure.selected = !_enclosure.selected;
			if (_enclosure.selected)
			{
				var e_1:MapEvent = new MapEvent(MapEvent.ENCLOSURE_START);
				MapEventDispatcher.getInstance().dispatchEvent(e_1);
			}
			else
			{
				var e_2:MapEvent = new MapEvent(MapEvent.ENCLOSURE_STOP);
				MapEventDispatcher.getInstance().dispatchEvent(e_2);
			}
		}
		
		private function onMeaureEndHandler(event:MapEvent):void
		{
			_measureing = false;
		}
		
		private function onMeaureStartHandler(event:MapEvent):void
		{
			_measureing = true;
		}
		
		private function onEnClosureStopHandler(event:MapEvent):void
		{
			_enclosure.selected = false;
		}
		
		private function naviTo2DHandler(event:MouseEvent):void
		{
			map.setMapType(MapTypeConstants.getManhattan2DMap());
		}
		
		
		private function showRoadHandler(event:MouseEvent):void
		{
			_road.visible = true;
		}
		
		public function hideRoadHandler(event:MouseEvent):void
		{
			_road.visible = false;
		}

		private function naviTo3DHandler(event:MouseEvent):void
		{
			_road.selected = false;
			map.setMapType(MapTypeConstants.getManhattan3DMap());
		}
		
		private function naviToSatHandler(event:MouseEvent):void
		{
			map.setMapType(MapTypeConstants.getManhattanSatMap()());
		}
		
		private function naviToClarityHandler(event:MouseEvent):void
		{
			MapEventDispatcher.getInstance().dispatchEvent(new Event(MapEvent.SUBWAY_CLICKED));
		}
		
		private function drawMapTypeContainer(target:Sprite, asset:Bitmap):void
		{
			if (!asset || !asset.bitmapData) return;
			target.graphics.clear();
			target.graphics.beginBitmapFill(asset.bitmapData, null, true, true);
			target.graphics.drawRect(0, 0, asset.width, asset.height);
			target.graphics.endFill();
		}
		
		private function handleMapSizeChangedEvent(event:MapEvent):void
		{
			this.placeControl();
		}
		
		/**
		 *set x and y value of the control 
		 * 
		 */		
		override protected function placeControl():void {
			x = map.mapWidth - _controlWidth - _right;
			y = _y;
		}
		
	}
}