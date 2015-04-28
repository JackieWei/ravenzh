package com.youcity.maps.controls
{
	import com.youcity.maps.AssetsEmbed;
	import com.youcity.maps.Map;
	import com.youcity.maps.MapEvent;
	import com.youcity.maps.util.MapUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * Draw zoom control 
	 * @author Administrator
	 * 
	 */
	public class ZoomControlContainer extends ControlContainer
	{
		public var Zoom_In_Icon:Class = AssetsEmbed.ZOOMCONTROL_OLD_Zoom_In_Icon;
		
		public var Zoom_Out_Icon:Class = AssetsEmbed.ZOOMCONTROL_OLD_Zoom_Out_Icon;
		
		public var Zoom_Top_Icon:Class = AssetsEmbed.ZOOMCONTROL_OLD_Zoom_Top_Icon;
		
		public var Zoom_Bottom_Icon:Class = AssetsEmbed.ZOOMCONTROL_OLD_Zoom_Bottom_Icon;
		
		public var Zoom_Level_Icon:Class = AssetsEmbed.ZOOMCONTROL_OLD_Zoom_Level_Icon;
		
		private var Slide_Block_Icon:Class = AssetsEmbed.ZOOMCONTROL_OLD_SLIDE_BLOCK_ICON;
		
		private var _zoomInBtn:Sprite ;
		
		private var _zoomOutBtn:Sprite;
		
		private var _zoomSlideBlock:Sprite;
		
		private var _zoomTopBar:Sprite;
		
		private var _zoomArea:Sprite;
		
		//store several needed data
		private var _areaHeight:Number;//level area height
		private var _totalWidth:Number;
		private var _totalHeight:Number;
		private var _levelHeight:Number;//each level's height
		private var _topHeight:Number;//top part height
		private var _bottomHeight:Number;//bottom part height
		
		private var _zoomBottomBar:Sprite;
		
		private var _dragEnabled:Boolean = false;
		
		private var _spacer:Number = 4;
		private var _extendSize:Number = 10;
		
		/**
		 * @private  
		 */		
		private var _zoomControl:ZoomControl;
		
		/**
		 * @private Hold the position of the zoom plate mapping with the map's zooms
		 */		
		private var _positionDictionary:Array;
		
		/**
		 *Hold the current zoom level of the map 
		 */		
		private var _currentZoom:Number;
		
		public function get currentZoom():Number
		{
			return this._currentZoom;
		}
		
		public function set currentZoom(value:Number):void
		{
			if (-1 != _zoomControl.map.zoomArray.indexOf(value) && _currentZoom != value)
			{
				_currentZoom = value;
				setZoomPosition(value);
				_zoomControl.setZoom(value);
			}
		}
		
		public function ZoomControlContainer(map:Map)
		{
			super(map);
			map.addEventListener(MapEvent.ZOOM_CHANGED, handleMapZoomChangeEvent);
			//map.addEventListener(MapEvent.MAPTYPE_CHANGED, handleMapTypeChangeEvent);
		}
		
		override protected function placeControl():void
		{
			this.x = 40;		
			this.y = 80;		
		}
		
		override protected function initControlWithMap(map:Map):void
		{
			_zoomControl = new ZoomControl(map);
			_positionDictionary = new Array();
			
			//first zoom plus button
			_zoomInBtn = drawIconBtn(this, null, Zoom_In_Icon, 0, 0, true);
			
			/**----------------whole zoom level area begin -------------- ***/
			_zoomArea = drawIconBtn(this, null, null, 1, _zoomInBtn.height + _zoomInBtn.y + _spacer);
			
			//add top bar
			var topBar:Sprite = drawIconBtn(_zoomArea, null, Zoom_Top_Icon, 0, 0);
			
			//add levels 
			var levelBar:Sprite = new Sprite();
			var _zoomLevelBar_Icon:* = new Zoom_Level_Icon();
			levelBar.graphics.clear();
			levelBar.graphics.beginBitmapFill(_zoomLevelBar_Icon.bitmapData, null,true, true);
			levelBar.graphics.drawRect(0, 0, _zoomLevelBar_Icon.width, _zoomLevelBar_Icon.height * _zoomControl.map.zoomArray.length);
			levelBar.graphics.endFill();			
			levelBar.x = 0;
			levelBar.y = topBar.y + topBar.height;
			_zoomArea.addChild(levelBar);
			
			_zoomArea.graphics.beginFill(0xFFAAFF, 0);
			_zoomArea.graphics.drawRect(0, 0, _zoomArea.width, _zoomArea.height);
			_zoomArea.graphics.endFill();
			
			//add zoom slide bar
			_zoomSlideBlock = drawIconBtn(_zoomArea, null, Slide_Block_Icon, -1);
			
			//add zoom bottom bar
			var bottomBar:Sprite = drawIconBtn(_zoomArea, null, Zoom_Bottom_Icon, 0,  levelBar.y + levelBar.height);
			/****---------------- whole zoom level area end --------------------**********/
			
			//zoom out btn
			_zoomOutBtn = drawIconBtn(this, _zoomOutBtn, Zoom_Out_Icon, 0, _zoomArea.y + _zoomArea.height + _spacer, true);
			for (var i:uint = 0; i < _zoomControl.map.zoomArray.length; i++)
			{
				var min:Number = _zoomArea.height - _spacer - (i + 1) * _zoomLevelBar_Icon.height;
				var position:Object = 
				{
					zoom:i,
					min:min,
					max:min + _zoomLevelBar_Icon.height,
					center:min + _zoomLevelBar_Icon.height/2
				}
				_positionDictionary.push(position);
			}
			
			_currentZoom = _zoomControl.map.zoom;
			setZoomPosition(_zoomControl.map.zoom);
			
			_totalWidth  = _zoomOutBtn.x + _zoomOutBtn.width + 2 * _extendSize;
			_totalHeight = _zoomOutBtn.height + _zoomOutBtn.y+ 2 * _extendSize;
			this.graphics.beginFill(0xFFFFFF, 0);
			this.graphics.drawRect(-_extendSize, -_extendSize, _totalWidth,  _totalHeight);
			this.graphics.endFill();
			
			_areaHeight = _zoomArea.height - _zoomSlideBlock.height/2;
			
			//add listeners for controls
			_zoomInBtn.addEventListener(MouseEvent.CLICK, handleZoomInBtnClick);
			_zoomOutBtn.addEventListener(MouseEvent.CLICK, handleZoomOutBtnClick);
			
			_zoomSlideBlock.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDownEvent);
			
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMoveEvent);
			_zoomArea.addEventListener(MouseEvent.MOUSE_UP, handleMouseUpEvent);
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOutEvent);
		}
		
		private function drawIconBtn(parent:Sprite, target:Sprite,  Icon:Class = null, x:Number = 0, y:Number = 0, buttonMode:Boolean = false):Sprite
		{
			if (!parent) return null;
			if (!target) target = new Sprite();
			if (Icon)
			{
				var c:* = new Icon();
				target.addChild(c);
			}
			target.x = x;
			target.y = y;
			target.buttonMode = buttonMode;
			parent.addChild(target);
			return target;
		}
		
		private function handleZoomInBtnClick(event:MouseEvent):void
		{
			event.stopPropagation();
			this._zoomControl.zoomIn();
		}
		
		private function handleZoomOutBtnClick(event:MouseEvent):void
		{
			event.stopPropagation();
			this._zoomControl.zoomOut();
		}
		
		private function handleMouseDownEvent(event:MouseEvent):void
		{
			event.stopPropagation();
			_dragEnabled = true;
		}
		
		private function handleMouseMoveEvent(event:MouseEvent):void
		{
			event.stopPropagation();
			if (_dragEnabled)
			{
				var y:Number = event.currentTarget.mouseY - _zoomArea.y - _zoomSlideBlock.height/2;
				if (y < 0 || y > _areaHeight || event.currentTarget.mouseX <= 0 || event.currentTarget.mouseX >= _totalWidth - _extendSize)
				{
					_dragEnabled = false;
					setZoomPositionByY(_zoomSlideBlock.y);
					return;
				}
				_zoomSlideBlock.y = y;
			}
		}
		
		private function handleMouseUpEvent(event:MouseEvent):void
		{
			event.stopPropagation();
			_dragEnabled = false;
			setZoomPositionByY(_zoomSlideBlock.y);
		}
		
		private function handleMouseOutEvent(event:MouseEvent):void
		{
			event.stopPropagation();	
			return;
		}
		
		/**
		 * This handler is to handle the event of map's zoom changes.
		 * It will re-locate the zoomPlate.
		 * 
		 * @param event
		 */		
		private function handleMapZoomChangeEvent(event:MapEvent):void
		{
			currentZoom = event.currentTarget.zoom;
		}
		
		/**
		 * This handler is to handle the event of map's type changes.
		 * 
		 * @param event
		 */		
		private function handleMapTypeChangeEvent(event:MapEvent):void
		{
			clear();
			this.initControlWithMap(event.currentTarget as Map)
		}
		
		/**
		 *	When mouse move on the level bar, get the new zoom.
		 *  
		 * @param num
		 * @return 
		 * 
		 */		
		private function moveSlideBlock(num:Number):Boolean
		{
			return false;
		}
		
		private function setZoomPositionByY(y:Number):void
		{
			if (y >=  _positionDictionary[0].max) 
				y = _positionDictionary[0].max;
			if (y < _positionDictionary[_positionDictionary.length - 1].min) 
				y = _positionDictionary[_positionDictionary.length - 1].min + 3e-3;
			for each (var item:Object in _positionDictionary)
			{
				if (y > item.min && y <= item.max)
				{
					_zoomSlideBlock.y = item.center - _zoomSlideBlock.height/2;
					currentZoom = item.zoom;
				}
			}
		}
		
		/**
		 * set zoom bar to correct position according to zoom
		 * @param zoom  zoom level
		 * 
		 */		
		private function setZoomPosition(zoom:uint):void
		{
			if (-1 == _zoomControl.map.zoomArray.indexOf(zoom)) return;
			_zoomSlideBlock.y = _positionDictionary[_zoomControl.map.zoomArray.length - zoom -1].center - _zoomSlideBlock.height/2;
		}
		
		private function clear():void
		{
			graphics.clear();
			MapUtil.removeAllChildren(this);
			removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMoveEvent);
			_zoomArea.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUpEvent);
			removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOutEvent);
			_zoomInBtn = null ;
			_zoomOutBtn = null;
			_zoomSlideBlock = null;
			_zoomTopBar = null;
			_zoomArea = null;
			_positionDictionary = null;
			
			_areaHeight = 0;
			_totalWidth = 0;
			_totalHeight = 0;
			_levelHeight = 0;
			_topHeight = 0;
			_bottomHeight = 0;
		}
	}
}