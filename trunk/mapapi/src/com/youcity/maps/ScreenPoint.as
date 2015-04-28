package com.youcity.maps
{
	import com.youcity.maps.util.MapUtil;
	
	import flash.geom.Point;
	
	/**
	 * Screen point, relative to position at zoom
	 * @author Administrator
	 * ScreenPoint主要目标是记录对应于一个zoom下某个具体位置。
	 * 按照最初的设计原则，这个点不应当可以改变的，只可以在构造函数里初始化
	 * 但是在继承Point类之后x，y都是可以改变的了。
	 * 此类的所有方法都不会改变x，y值，只会生成新的点
	 */	
	public class ScreenPoint extends Point
	{
		/**
		 * readonly property zoom
		 * init in constructor
		 */
		private var _zoom:uint;
		public function get zoom():uint//ScreenPoint有唯一的zoom，这个是代表当前点所在的zoom，是不会被改变的
		{
			return _zoom;
		}
		
		/**
		 * @constructor
		 * @param zoomlevel : relative zoom level
		 * @param x : x
		 * @param y : y
		 * 
		 */		
		public function ScreenPoint(zoomlevel:uint, x:Number = 0, y:Number = 0)
		{
			super(x, y);
			_zoom = zoomlevel;
		}
		
		/**
		 * translate to MapPoint
		 * @return correspond MapPoint
		 */		
		public function toMapPoint():MapPoint {//得到想对应的mappoint，注意一样是生成新的类的实例，当前的不会变 
			var t:uint = MapUtil.getScaler(zoom);
			return new MapPoint(x * t, y * t);
		}
		
		/**
		 * 
		 * @return HaskKey(String)
		 * translate to HashKey
		 */		
		public function toHashKey():String {//生成唯一的Key，主要用于标识
			return 'x:' + String(x) + ';y:' + String(y) + ';zoom:' + String(_zoom);
		}
		
		public function toZoom(zoom:uint):ScreenPoint {//根据zoom得到适合的screenpoint，注意得到的是新的实例，当前的没变
			if (_zoom == zoom || zoom < 0) {
				return this;
			}
			return toMapPoint().toScreenPoint(zoom);
		}
		
		/**
		 * 根据一定的偏移量得到新的screenpoint，注意不会改变当前实例
		 * get offset point
		 * @param dx
		 * @param dy
		 * @return 
		 */		
		public function offsetPoint(dx:Number, dy:Number):ScreenPoint {
			return new ScreenPoint(zoom, x + dx, y + dy);
		}
		
		/**
		 * 判断两个screenPoint是否是指向同一个zoom的同一个点
		 * check if equals
		 * @param toCompare
		 * @return 
		 * 
		 */		
		public function equalsTo(toCompare:ScreenPoint):Boolean {
			return toCompare.x == x && toCompare.y == y && toCompare.zoom == _zoom;
		}
		
	}
}
 
