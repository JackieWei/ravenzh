package com.youcity.maps
{
	import com.youcity.maps.util.MapUtil;
	
	import flash.geom.Point;
	/**
	 * 
	 * @author Administrator
	 * 此类的主要目的是记录对应于一个城市的某个唯一的点，跟zoom无关，各个zoom下会有相对应的点
	 */	
	public class MapPoint extends Point
	{
		/**
		 * constructor
		 * @param x
		 * @param y
		 * set x,y for point
		 */		
		public function MapPoint(x:Number, y:Number)
		{
			super(x, y);
		}
		
		/**
		 * 
		 * @param zoom
		 * @return 
		 * translate MapPoint to ScreenPoint
		 * 对应于某个zoom下会有具体的ScreenPoint
		 */		
		public function toScreenPoint(zoom:uint):ScreenPoint 
		{
			var t:Number = MapUtil.getScaler(zoom);
			return new ScreenPoint(zoom, x/t, y/t);
			//return new ScreenPoint(zoom, x/Math.pow(2, zoom), y/Math.pow(2, zoom));
		}
		
		/**
		 * get relative latlng point according to city
		 * @param constant
		 * @return 
		 * 可以根据城市的一系列参数得到当前点对应的经纬度
		 */		
		public function toLatLng(constant:CityConstant = null):LatLngPoint
		{
			if (!constant) constant = MapConstants.MANHATTANCONSTANTS;
			return new LatLngPoint(constant.E * y + constant.D * x + constant.F, constant.B * y + constant.A * x + constant.C);
		}
		
		/**
		 * 
		 * @return HashKey 
		 * rule is x: y: 
		 * 作为唯一的key
		 */		
		public function toHashKey():String
		{
			return 'x:' + String(x) + ';y:' + String(y);
		}
	}
}