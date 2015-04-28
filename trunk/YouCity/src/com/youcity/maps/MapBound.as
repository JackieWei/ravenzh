package com.youcity.maps
{
	import flash.geom.Point;
	
	/**
	 * 
	 * @author Administrator
	 * 主要是想把Map里的一些计算搬到这里来，比如Map的size，
	 * 范围，等等属性，包括一切通用的方法。但是因为Map的属性会改变
	 * 所有每次必须生成新的实例。这样可能会比较浪费
	 */	
	public final class MapBound
	{
		private var _extendWidth:Number = 400;
		public function get extendWidth():Number
		{
			return _extendWidth;
		}
		public function set extendWidth(value:Number):void
		{
			_extendWidth = value;
		}
		
		private var _extendLTPoint:ScreenPoint;
		public function get extendLTPoint():ScreenPoint
		{
			return _extendLTPoint;
		}
		
		private var _extendRBPoint:ScreenPoint;
		/**
		 * 
		 * @return 
		 * 扩展后的左上右下点
		 */		
		public function get extendRBPoint():ScreenPoint
		{
			return _extendRBPoint;
		}
		
		private var _extendHeight:Number = 400;
		public function get extendHeight():Number
		{
			return _extendHeight;
		}
		public function set extendHeight(value:Number):void
		{
			_extendHeight = value;
		}
		
		private var _ltPoint:ScreenPoint;
		public function get ltPoint():ScreenPoint
		{
			return _ltPoint;
		}
		
		private var _rbPoint:ScreenPoint;
		public function get rbPoint():ScreenPoint
		{
			return _rbPoint;
		}
		
		public function get ltMapPoint():MapPoint
		{
			return _ltPoint.toMapPoint();
		}
		
		public function get rbMapPoint():MapPoint
		{
			return _rbPoint.toMapPoint();
		}
		
		public function get width():Number
		{
			return _map.size.x;
		}
		
		public function get height():Number
		{
			return _map.size.y;
		}
		
		/**
		 * 
		 * @param point
		 * @return 
		 * 是否在扩展后的地图范围内，主要是用来判断是否需要slide效果的
		 */		
		public function insideMap(point:Point):Boolean
		{
			var toCompare:Point;//refer to mappoint
			if (point is ScreenPoint) toCompare = ScreenPoint(point).toMapPoint();
			else toCompare = point;
			var lt:MapPoint = _extendLTPoint.toMapPoint();
			var rb:MapPoint = _extendRBPoint.toMapPoint();
			if (toCompare.x >= lt.x && toCompare.x <= rb.x && toCompare.y >= lt.y && toCompare.y <= rb.y) return true;
			else return false;
		}
		
		private var _map:Map;
		/**
		 * 
		 * @param map
		 * 根据map计算数值，包括左上角点，右下角点，map的大小，扩展后的大小
		 */		
		public function MapBound(map:Map)
		{
			_map = map;
			var center:ScreenPoint = _map.center.toScreenPoint(_map.zoom);
			_ltPoint= new ScreenPoint(_map.zoom, center.x - _map.size.x/2, center.y - _map.size.y/2);
			_extendLTPoint= new ScreenPoint(_map.zoom, center.x - _map.size.x/2 - _extendWidth, center.y - _map.size.y/2 - _extendHeight);
			_extendRBPoint = new ScreenPoint(_map.zoom, center.x + _map.size.x/2 + _extendWidth, center.y + _map.size.y/2 + _extendHeight);
            _rbPoint = new ScreenPoint(_map.zoom, center.x + _map.size.x/2, center.y + _map.size.y/2);
		}
	}
}