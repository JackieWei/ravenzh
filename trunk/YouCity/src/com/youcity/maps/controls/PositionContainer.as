package com.youcity.maps.controls
{
	import com.youcity.maps.AssetsEmbed;
	import com.youcity.maps.Map;
	import com.youcity.maps.MapConstants;
	import com.youcity.maps.MapTypeConstants;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class PositionContainer extends ControlContainer
	{
		private var POSITION_CONTROL_2D:Class = AssetsEmbed.POSITION_CONTROL_2D;
		private var POSITION_CONTROL_3D:Class = AssetsEmbed.POSITION_CONTROL_3D;
		
		private var _positionControl:PositionControl;
		private var _mapTypeControl:MapTypeControl;
		
		private var _positionShape:Bitmap;
		private var _interactiveLength:Number = 18;
		private var _measureLength:Number = 18;
		
		public function get postionHeight():Number
		{
			return _positionShape.height;
		}
		
		public function get postionWidth():Number
		{
			return _positionShape.width;
		}
		
		public function PositionContainer(map:Map)
		{
			super(map);
			_positionControl = new PositionControl(map);
			_mapTypeControl = new MapTypeControl(map);
			drawContainer(POSITION_CONTROL_2D);
			drawInteractiveAreas();
		}
		private function drawContainer(icon:Class):void
		{
			if(_positionShape)
			_positionShape.bitmapData.dispose();
			
			_positionShape = new icon();
			graphics.clear();
			graphics.beginBitmapFill(_positionShape.bitmapData, null, true, true);
			graphics.drawRect(0, 0, _positionShape.width, _positionShape.height);
			graphics.endFill();
		}
		
		private function drawInteractiveAreas():void
		{
			var north:Point = new Point(_positionShape.width / 2 - _interactiveLength / 2, 0);
			var west:Point = new Point(0, _positionShape.width / 2 - _interactiveLength / 2);
			var south:Point = new Point(_positionShape.width / 2 - _interactiveLength / 2, _positionShape.height - _interactiveLength);
			var east:Point = new Point( _positionShape.width - _interactiveLength,  _positionShape.height/2 - _interactiveLength/2);
			addChild(getInteractiveArea(north, MapConstants.NORTH));
			addChild(getInteractiveArea(west, MapConstants.WEST));
			addChild(getInteractiveArea(south, MapConstants.SOUTH));
			addChild(getInteractiveArea(east, MapConstants.EAST));
			drawMeasureArea();
		}
		
		private function drawMeasureArea():void
		{
			var measureArea:Sprite = new Sprite();
			measureArea.graphics.beginFill(0xFFFFFF, 0);
			measureArea.graphics.drawRect(_positionShape.width / 2 - _measureLength / 2, _positionShape.height / 2 - _measureLength / 2, _measureLength, _measureLength);
			measureArea.graphics.endFill();
			measureArea.buttonMode = true;
			measureArea.addEventListener(MouseEvent.CLICK, changeMapType);
			addChild(measureArea);
		}
		
		private function getInteractiveArea(position:Point, direction:String):Sprite
		{
			var target:Sprite = new Sprite();
			target.graphics.beginFill(0xFFFFFF, 0);
			target.graphics.drawRect(0, 0, _interactiveLength, _interactiveLength);
			target.graphics.endFill();
			target.buttonMode = true;
			target.x = position.x;
			target.y = position.y;
			switch (direction)
			{
				case MapConstants.SOUTH: 
				{
					target.addEventListener(MouseEvent.CLICK, forwardSouth);
					break;
				}
				case MapConstants.NORTH: 
				{
					target.addEventListener(MouseEvent.CLICK, forwardNorth);
					break;
				}
				case MapConstants.WEST: 
				{
					target.addEventListener(MouseEvent.CLICK, forwardWest);
					break;
				}
				case MapConstants.EAST: 
				{
					target.addEventListener(MouseEvent.CLICK, forwardEast);
					break;
				}
				default: break;
			}
			return target;
		}
		
		private function forwardWest(event:MouseEvent):void
		{
			_positionControl.forwardWest();
		}
		
		private function forwardNorth(event:MouseEvent):void
		{
			_positionControl.forwardNorth();
		}
		
		private function forwardEast(event:MouseEvent):void
		{
			_positionControl.forwardEast();
		}
		
		private function forwardSouth(event:MouseEvent):void
		{
			_positionControl.forwardSouth();
		}
		
		private function changeMapType(event:MouseEvent):void
		{
			if (map.currentMapType.type == MapConstants.MAPTYPE_2D)
			{
				drawContainer(POSITION_CONTROL_2D);
				_mapTypeControl.setMapType(MapConstants.MAPTYPE_3D);
				return;
			}
			if(map.currentMapType.type == MapConstants.MAPTYPE_3D)
			{
				drawContainer(POSITION_CONTROL_3D);
				_mapTypeControl.setMapType(MapConstants.MAPTYPE_2D);
			}
		}
		
		
	}
}