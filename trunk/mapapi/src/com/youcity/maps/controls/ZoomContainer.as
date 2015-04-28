package com.youcity.maps.controls
{
	import com.youcity.maps.AssetsEmbed;
	import com.youcity.maps.Map;
	import com.youcity.maps.MapEvent;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ZoomContainer extends ControlContainer
	{
		public var ZOOM_TREE:Class = AssetsEmbed.ZOOMCONTROL_TREE;
		
		public var ZOOM_LEVEL:Class = AssetsEmbed.ZOOMCONTROL_LEVEL;
		
		public var ZOOM_SLIDE:Class = AssetsEmbed.ZOOMCONTROL_SLIDE;
		
		private var _zoom_tree:Bitmap;
		private var _zoom_level:Bitmap;
		private var _zoom_slider:Bitmap;
		
		private var _topHeight:uint = 14;
		private var _bottomHeight:uint = 14;
		private var _levelHeight:Number;
		private var _averageHeight:Number;
		
		private var _plus:Sprite;
		private var _minus:Sprite;
		private var _slide:Sprite;
		
		private var _positionArray:Array;
		
		private var _zoomControl:ZoomControl;
		
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
				placeSlide(_positionArray[value]);
				_zoomControl.setZoom(value);
			}
		}
		
		
		public function get zoomWidth():Number
		{
			return _zoom_tree.width;
		}
		
		public function get zoomHeight():Number
		{
			return _zoom_tree.height;
		}
		
		public function ZoomContainer(map:Map)
		{
			super(map);
			_zoomControl = new ZoomControl(map);
			_zoom_tree = new ZOOM_TREE();
			_zoom_level= new ZOOM_LEVEL();
			_zoom_slider = new ZOOM_SLIDE();
			_positionArray = new Array();
			width = _zoom_tree.width;
			height = _zoom_tree.height;
			/* graphics.beginFill(0xCFFFFF, 0);
			graphics.drawRect(0, 0, _zoom_tree.width, _zoom_tree.height);
			graphics.endFill(); */
			
			drawZoomTree();
			_slide.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, onZoomMouseDownHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			//addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
			_slide.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			map.addEventListener(MapEvent.ZOOM_CHANGED, setSlideByZoomHandler);
			setSlideByZoomHandler();
		}
		
		private function drawZoomTree():void
		{
			if (!map || !map.zoomArray || map.zoomArray.length <= 0) return;
			_levelHeight = _zoom_tree.height - _topHeight - _bottomHeight;
			_averageHeight = _levelHeight / map.zoomArray.length;
			graphics.beginBitmapFill(_zoom_tree.bitmapData, null, true, true);
			graphics.drawRect(0, 0, _zoom_tree.width, _zoom_tree.height);
			graphics.endFill();
			
			var leveX:Number = _zoom_tree.width / 2 - _zoom_level.width / 2;
			var itemStart:Number;
			for (var i:uint = 0; i < map.zoomArray.length; i++)
			{
				itemStart = i * _averageHeight + _topHeight;
//				_positionArray.push(itemStart);
				_positionArray.unshift(itemStart);
				//graphics.drawRect(leveX, itemStart + 0.5 * _averageHeight, _zoom_level.width, _zoom_level.height);
				var level:Sprite = getLevelView(i, leveX, itemStart + 0.5 * _averageHeight);
				addChild(level);
			}
			
			drawPlusMinus();
			
			drawSlide();
		}
		
		private function getLevelView(zoom:uint, x:Number, y:Number):Sprite
		{
			var level:Sprite = new Sprite();
			level.x = x;
			level.y = y;
			level.name = "level_" + String(zoom);
			level.graphics.beginBitmapFill(_zoom_level.bitmapData, null, true, true);
			level.graphics.drawRect(0, 0, _zoom_level.width, _zoom_level.height);
			level.graphics.endFill();
			level.buttonMode = true;
			level.mouseChildren = false;
			level.addEventListener(MouseEvent.CLICK, onLevelClickHandler);
			level.addEventListener(MouseEvent.MOUSE_OVER, levelOverHandler);
			level.addEventListener(MouseEvent.MOUSE_OUT, levelOutHandler);
			return level;
		}
		
		private var _shape:Shape;
		
		private function levelOverHandler(event:MouseEvent):void
		{
			var target:Sprite = Sprite(event.currentTarget);
			if (!_shape)
			{
				_shape = new Shape();
				_shape.graphics.lineStyle(1, 0xbcfadd);
				_shape.graphics.beginFill(0x000000, .2);
				_shape.graphics.drawRect(-5, -5, _zoom_level.width + 10, _zoom_level.height + 10);
				_shape.graphics.endFill();
			}
			if (_shape.parent)
				(_shape.parent as Sprite).removeChild(_shape);
			target.addChild(_shape);
		}
		
		private function levelOutHandler(event:MouseEvent):void
		{
			var target:Sprite = Sprite(event.currentTarget);
			if (_shape && target.contains(_shape))
				target.removeChild(_shape);
		}
		
		private function onLevelClickHandler(event:MouseEvent):void
		{
			var name:String = Sprite(event.currentTarget).name;
			var zoom:uint = uint(name.substring(6, name.length));
			currentZoom = zoom;
		}
		
		private function drawPlusMinus():void
		{
			if (!_plus)
			{
				_plus = new Sprite();
				_plus.x = 0;
				_plus.y = 0;
				drawRect(_plus, _topHeight);
				_plus.addEventListener(MouseEvent.CLICK, zoomInHandler);
			}
			if (!_minus)
			{
				_minus = new Sprite();
				_minus.x = 0;
				_minus.y = _zoom_tree.height - _bottomHeight;
				drawRect(_minus, _bottomHeight);
				_minus.addEventListener(MouseEvent.CLICK, zoomOutHandler);
			}
		}
		
		private function zoomInHandler(event:MouseEvent):void
		{
			currentZoom --;
		}
		
		private function zoomOutHandler(event:MouseEvent):void
		{
			currentZoom ++;
		}
		
		private function drawRect(target:Sprite, height:Number):void
		{
			target.graphics.beginFill(0xFFFFFF, 0);
			target.graphics.drawRect(0, 0, _zoom_tree.width, height);
			target.graphics.endFill();
			target.buttonMode = true;
			addChild(target);
		}
		
		private function drawSlide():void
		{
			if (!_slide)
			{
				_slide = new Sprite();
				_slide.buttonMode = true;
				_slide.graphics.beginBitmapFill(_zoom_slider.bitmapData, null, true, true);
				_slide.graphics.drawRect(0, 0, _zoom_slider.width, _zoom_slider.height);
				_slide.graphics.endFill();
				addChild(_slide);
			}
		}
		
		private function placeSlide(startY:Number):void
		{
			var x:Number = (_zoom_tree.width - _zoom_slider.width)/2;
			_slide.x = x;
			_slide.y = startY + _averageHeight / 2 - _zoom_slider.height / 2;
		}
		
		private function setZoomByY(y:Number):void
		{
			var center:Number = _slide.y + _zoom_slider.height / 2;
			if (center <= _positionArray[0])
			{
				currentZoom = 0;
				return;
			}
			if (center >= _positionArray[_positionArray.length - 1])
			{
				currentZoom = _positionArray.length - 1;
				return;
			}
			for (var i:uint; i < _positionArray.length; i++)
			{
				if (center > _positionArray[i] && center < _positionArray[i] + _averageHeight)
				{
					currentZoom = i;
					break;
				}
			}
		}
		
		private function setSlideByZoomHandler(event:MapEvent = null):void
		{
			currentZoom = map.zoom;
		}
		
		private var _isDown:Boolean = false;
		private var _startY:Number;
		private function onMouseDownHandler(event:MouseEvent):void
		{
			_isDown = true;
			_startY = mouseX;
		}
		
		private function onZoomMouseDownHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		private function onMouseMoveHandler(event:MouseEvent):void
		{
			if (_isDown)
			{
				var newPosition:Number = mouseY;
				if (mouseX <= 0 || mouseX >= _zoom_tree.width)
				{
					_isDown = false;
					return;
				} 
				if (newPosition < _topHeight) 
				{
					newPosition = _topHeight;
				}
				else if (newPosition > _zoom_tree.height - _bottomHeight)
				{
					newPosition = _zoom_tree.height - _bottomHeight;
				}
				else 
				{
					
				}
				_slide.y = newPosition;
			}
		}
		private function onMouseUpHandler(event:MouseEvent):void
		{
			setZoomByY(_slide.y);
			if (_isDown) _isDown = false;
		}
		
		private function onMouseOutHandler(event:MouseEvent):void
		{
			setZoomByY(_slide.y);
			if (_isDown) _isDown = false;
		}
		
		
	}
}