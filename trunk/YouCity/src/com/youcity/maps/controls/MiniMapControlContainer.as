package com.youcity.maps.controls
{
	import com.youcity.maps.AssetsEmbed;
	import com.youcity.maps.Map;
	import com.youcity.maps.MapConstants;
	import com.youcity.maps.MapEvent;
	import com.youcity.maps.MapPoint;
	import com.youcity.maps.MapTypeConstants;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;

	/**
	 * Draw minimap control.
	 * @author Administrator
	 * MiniMap的主要复杂在于那个定位以及效果，至于效果部分代码其实可以用TweenLite代替。定位主要是根据四个位置算出当前应当在那个位置
	 * 画图部分不详细描述，因为没有多少逻辑性在里面
	 */
	public class MiniMapControlContainer extends ControlContainer
	{	
		public var HIDEBUTTON_UP:Class = AssetsEmbed.MINIMAP_HIDEBUTTON_UP;
		public var HIDEBUTTON_DOWN:Class = AssetsEmbed.MINIMAP_HIDEBUTTON_DOWN;
		
		public static const POSITION_NORTHWEST:String = "north west";
		public static const POSITION_NORTHEAST:String  = "north east";
		public static const POSITION_SOUTHWEST:String = "south west";
		public static const POSITION_SOUTHEAST:String  = "south east";
		
		public static const INNER_COLOR:uint = 0xffc000;
		public static const BORDER_COLOR:uint = 0x00779c;
		
		//private var map:Map;
		
		private var _miniMap:Map;
		
		private var _control:MiniMapControl;
		
		private var _hideButton:Sprite;
		
		private var _left2rightBar:Shape;
		
		private var _top2bottomBar:Shape;
		
		private var _effectTimer:Timer;
		
		private var _effectDelay:uint = 25;
		
		private var _effectTime:Number = 0.5;
		
		private var _isHide:Boolean;
		private function set isHide(value:Boolean):void
		{
			if (value == _isHide) return;
			_isHide = value;
			drawHideButton(_isHide);
		}
		
		private var _mapContainer:UIComponent;
		
		private var _content:UIComponent;
		
		private var _sideWidth:Number = 10;
		
		private var _sideHeight:Number = 10;
		
		private var _position:String;
		
		private var _x_range:Object;
		
		private var _y_range:Object;
		
		private var _slideX:Number;
		
		private var _slideY:Number;
		
		public function setPosition(value:String):void
		{
			if (value != _position)
			{
				_position = value;
				setAllPostion();
			}
		}
		public function get position():String
		{
			return _position;
		}
		
		private var _show:Boolean;
		public function get show():Boolean
		{
			return _show;
		}
		
		public function set show(value:Boolean):void
		{
			if (value == _show) return;
			_show = value;
			if (_show) showMiniMap();
			else hideMiniMap();
		}
		
		
		/**
		 * Constructor
		 * 
		 * @param map
		 * 
		 */		
		public function MiniMapControlContainer(map:Map, width:Number = 210, height:Number = 210, pos:String = POSITION_SOUTHWEST)
		{
			super(map);
			_show = true;
			//this.map = map;
			map.addEventListener(MapEvent.ZOOM_CHANGED, handleMapZoomChangedEvent);
			map.addEventListener(MapEvent.MAP_MOVE, handleMapDragEndEvent);
			map.addEventListener(MapEvent.MAP_SIZE_CHANGED, handleMapSizeChangedEvent);
			map.addEventListener(MapEvent.CITY_CHANGED, handleCityChangedEvent);
			this.width = width;
			this.height = height;
			
			_content = new UIComponent();
			_content.width = width;
			_content.height = height;
			addChild(_content);
			drawSideBars();
			
			_isHide = false;
			_control = new MiniMapControl(map);
			
			_effectTimer = new Timer(_effectDelay);
			_effectTimer.addEventListener(TimerEvent.TIMER, doEffectHandler);
			
			//initSideBar();
			initMiniMap(map);
			initHideControl();
			
			
			setPosition(pos);
			
			var count:uint = _effectTime * 1000 / _effectDelay;
			_slideX = (_x_range.end - _x_range.start) / count;
			_slideY = (_y_range.end - _y_range.start) / count;
			mapHideHandler();
			addEventListener(MouseEvent.MOUSE_WHEEL, onWheelHandler);
		}
		
		private function onWheelHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		/**
		 * Initialize minimap with big map
		 * 
		 * @param map
		 * 初始化地图并且添加监听器
		 */		
		private function initMiniMap(map:Map):void
		{
			_mapContainer = new UIComponent();
			_mapContainer.width = width - _sideWidth;
			_mapContainer.height = height - _sideHeight;
			
			_mapContainer.x = _sideWidth / 2;
			_mapContainer.y = _sideHeight / 2;
			
			_miniMap = new Map();
//			_miniMap.zoom = _control.mapping(map.zoom);
			_miniMap.x = 0;
			_miniMap.y = 0;
			_mapContainer.addChild(_miniMap);
            
			_miniMap.setMapType(MapTypeConstants.getManhattanMiniMap());
			_miniMap.addEventListener(MapEvent.MAP_READY, handleMapReady);
			_miniMap.addEventListener(MapEvent.MAP_MOVE, handleMiniMapDragEndEvent);
			_content.addChild(_mapContainer);
		}
				
		private function initHideControl():void
		{
			_hideButton = new Sprite();
			drawHideButton(_isHide);
			_hideButton.buttonMode = true;
			_hideButton.addEventListener(MouseEvent.CLICK, mapHideHandler);
			addChild(_hideButton);
		}
		
		private function drawHideButton(_isHide:Boolean):void
		{
			var up:Bitmap = new HIDEBUTTON_UP();
			var down:Bitmap = new HIDEBUTTON_DOWN();
			_hideButton.graphics.clear();
			if (!_isHide)
				_hideButton.graphics.beginBitmapFill(up.bitmapData, null, true, true);
			else
				_hideButton.graphics.beginBitmapFill(down.bitmapData, null, true, true);
			_hideButton.graphics.drawRect(0, 0, down.width, down.height);
			_hideButton.graphics.endFill()
		}
		
		private function initSideBar():void
		{
			_left2rightBar = new Shape();
			_content.addChild(_left2rightBar);
			_top2bottomBar = new Shape();
			_content.addChild(_top2bottomBar);
			drawSideBar();
		}
		
		private function drawSideBar():void
		{
			_left2rightBar.graphics.beginFill(BORDER_COLOR, 0.8);
			_left2rightBar.graphics.drawRect(0, 0, width, _sideHeight);
			_left2rightBar.graphics.endFill();
			
			_top2bottomBar.graphics.beginFill(BORDER_COLOR, 0.8);
			_top2bottomBar.graphics.drawRect(0, 0, _sideWidth, height);
			_top2bottomBar.graphics.endFill();
		}
		
		private function drawSideBars():void
		{
			if (!_content) return;
			_content.graphics.clear();
			_content.graphics.lineStyle(1, BORDER_COLOR, 1);
			_content.graphics.beginFill(BORDER_COLOR, 1);
			_content.graphics.drawRect(0, 0, width, height);
			_content.graphics.endFill();
		}
		
		private function setAllPostion():void
		{
			drawSideBars();
			switch(_position)
			{
				case POSITION_NORTHEAST : 
				{
					//_left2rightBar.x = 0;
					//_left2rightBar.y = height - _sideHeight;
					//_top2bottomBar.x = 0;
					//_top2bottomBar.y = 0;
					//_mapContainer.x = _sideWidth;
					//_mapContainer.y = 0;
					_hideButton.x = width - _hideButton.width;
					_hideButton.y = 0;
					x = map.size.x - width;
					y = 0;
					_x_range = {start:0, end:width};
					_y_range = {start:0, end:0 - height}
					break;
				}
				case POSITION_NORTHWEST : 
				{
					//_left2rightBar.x = 0;
					//_left2rightBar.y = height - _sideHeight;
					//_top2bottomBar.x = width - _sideWidth;
					//_top2bottomBar.y = 0;
					//_mapContainer.x = 0;
					//_mapContainer.y = 0;
					_hideButton.x = 0;
					_hideButton.y = 0;
					x = 0;
					y = 0;
					_x_range = {start:0, end:0-width};
					_y_range = {start:0, end:0-height}
					break;
				}
				case POSITION_SOUTHEAST : 
				{
					///_left2rightBar.x = 0;
					//_left2rightBar.y = 0
					//_top2bottomBar.x = 0;
					//_top2bottomBar.y = 0;
					//_mapContainer.x = _sideWidth;
					//_mapContainer.y = _sideHeight;
					_hideButton.x = width - _hideButton.width;
					_hideButton.y = height - _hideButton.height;
					x = map.size.x - width;
					y = map.size.y - height;
					_x_range = {start:0, end:0 + width};
					_y_range = {start:0, end:0 + height}
					break;
				}
				case POSITION_SOUTHWEST : 
				{
					//_left2rightBar.x = 0;
					//_left2rightBar.y = 0;
					//_top2bottomBar.x = width - _sideWidth;
					//_top2bottomBar.y = 0;
					//_mapContainer.x = 0;
					//_mapContainer.y = _sideHeight;
					_hideButton.x = 0;
					_hideButton.y = height - _hideButton.height;
					x = 0;
					y = map.size.y - height;
					_x_range = {start:0, end:0 - width};
					_y_range = {start:0, end:0 + height}
					break;
				}
				default: break;
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onMouseWheelHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		/**
		 * Place control 
		 * 
		 */		
		override protected function placeControl():void
		{
			setAllPostion();
		}
		
		/**
		 * Event handlder for big map's zoom change
		 * When big map's zoom change, minimap's zoom also should change.
		 * 
		 * @param event
		 */		
		private function handleMapZoomChangedEvent(event:MapEvent):void
		{
			this._miniMap.setZoom(_control.mapping[map.zoom]);
		}
		
		/**
		 * Event handlder for big map drag end,
		 * When drag big map, also move minimap to new center.
		 * 
		 * @param event
		 */		
		private function handleMapDragEndEvent(event:MapEvent):void
		{
			_miniMap.setCenter(map.center);
		}
		
		/**
		 * Event handlder for map's size changed,
		 * re-invoke placeControl method to place control.
		 * 
		 * @param event
		 */		
		private function handleMapSizeChangedEvent(event:MapEvent):void
		{
			this.placeControl();
		}

		/**
		 * Event handler for city change 
		 * @param event
		 * 
		 */		
		private function handleCityChangedEvent(event:MapEvent):void
		{
			var city:String = event.data.city;
			switch(city)
			{
				case MapConstants.NEW_YORK:
					_miniMap.removeAllMapType();
					_miniMap.addMapType(MapTypeConstants.getManhattanMiniMap());
					_miniMap.setMapType(MapTypeConstants.getManhattanMiniMap());
					_miniMap.setCenter(new MapPoint(43724,27842));
//					_miniMap.setCenter(new MapPoint(43724,27842), _control.mapping[map.zoom]);
					break;
				case MapConstants.SAN_FRANCISCO:
					_miniMap.removeAllMapType();
					_miniMap.addMapType(MapTypeConstants.getSanFranciscoMiniMap());
					_miniMap.setMapType(MapTypeConstants.getSanFranciscoMiniMap());
					_miniMap.setCenter(new MapPoint(21248, 8960));
//					_miniMap.setCenter(new MapPoint(21248, 8960), _control.mapping[map.zoom]);
					break;
				default:
					break;
			}
			
		}
		
		/**
		 * Event handlder for minimap ready,
		 * set minimap's center.
		 * 
		 * @param event
		 */	
		private function handleMapReady(event:MapEvent):void
		{
			_miniMap.disableWheel();
			_miniMap.disabledDrag();
			this._miniMap.setCenter(map.center, _control.mapping[map.zoom]);
		}	
		
		/**
		 * Event handlder for mini map drag end,
		 * When drag minimap, also move big map to new center
		 * 
		 * @param event
		 */		
		private function handleMiniMapDragEndEvent(event:MapEvent):void
		{
			map.setCenter(_miniMap.center, _control.mapping[_miniMap.zoom]);
		}
		
		/**
		 * hide map begin
		 * @param event
		 * 
		 */		
		private function mapHideHandler(event:MouseEvent = null):void
		{
			_effectTimer.start();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function doEffectHandler(event:TimerEvent):void
		{
			if (_isHide) showMiniMap();
			else hideMiniMap();
		}
		
		private function hideMiniMap():void
		{
			_content.x += _slideX;
			_content.y += _slideY;
			if (!checkRange())
			{
				_effectTimer.stop();
				isHide = true;
				//_hideButton.addEventListener(MouseEvent.CLICK, mapHideHandler);
			}
		}
		
		private function showMiniMap():void
		{
			_content.x -= _slideX;
			_content.y -= _slideY;
			if (!checkRange())
			{
				_effectTimer.stop();
				isHide = false;
				//_hideButton.addEventListener(MouseEvent.CLICK, mapHideHandler);
			}
		}
		
		private function checkRange():Boolean
		{
			var flag:Boolean = true;
			if (_x_range.start >= _x_range.end)
			{
				if (_content.x >= _x_range.start || _content.x <= _x_range.end)
				{
					flag = false;
				}
			}
			else
			{
				if (_content.x <= _x_range.start || _content.x >= _x_range.end)
				{
					flag = false;
				}
			}
			
			if (_y_range.start > _y_range.end)
			{
				if (_content.y > _y_range.start || _content.y < _y_range.end)
				{
					flag = false;
				}
			}
			else
			{
				if (_content.y < _y_range.start || _content.y > _y_range.end)
				{
					flag = false;
				}
			}
			return flag;
			
		}
		
	}
}