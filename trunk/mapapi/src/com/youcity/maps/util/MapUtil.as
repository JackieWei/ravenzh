package com.youcity.maps.util
{
	import com.youcity.maps.LatLngPoint;
	import com.youcity.maps.MapConstants;
	import com.youcity.maps.ScreenPoint;
	
	import flash.geom.Point;
	
	/**
	 * 
	 * Auxiliary functions for Map
	 * @author Jackie Wei
	 */	
	public class MapUtil
	{
		/**
		 * use zoom to get scaler
		 * 
		 * @param zoom
		 * @return scaler
		 */		
		public static function getScaler(zoom:uint):uint {
			if (zoom >= MapConstants.TOTALLEVEL) {
				throw new Error("Zoom out of range!"); 
				return;
			}
			return Math.pow(2, MapConstants.TOTALLEVEL - 1 - zoom);
//			return Math.pow(2, zoom);
		} 
		
		/**
		 * use BaseSize to get map size under current zoom
		 * 
		 * @param zoom
		 * @return 
		 * 计算Map的大小。主要是对应于各个zoom下的x，y方向图片个数多少
		 */		
		public static function getMapSize(zoom:uint):Point {
			var pow:uint = Math.pow(2, zoom);
//			var pow:uint = Math.pow(2, MapConstants.TOTALLEVEL - 1 - zoom);
			return new Point(MapConstants.BASESIZE.x * pow, MapConstants.BASESIZE.y * pow);
		}
		
		public static function measure(fromtLngLat:LatLngPoint, toLngLat:LatLngPoint):Number {
			var radLat1:Number = rad(fromtLngLat.lat);
			var radLat2:Number = rad(toLngLat.lat);
		    var a:Number =  radLat1 - radLat2;
		    var b:Number = rad(fromtLngLat.lng) - rad(toLngLat.lng);
		    var s:Number = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2) + Math.cos(radLat1) * Math.cos(radLat2) * Math.pow(Math.sin(b / 2), 2)));
		    s = s * 6378137.0;
		    s = Math.round(s)
		    return s;
		}
		
		private static function rad(angle:Number):Number {
			return angle * Math.PI / 180;
		}
		
		public static function getBound(width:int, height:int, center:ScreenPoint):Array {
			var maxSize:Point = getMapSize(center.zoom);
			var leftX:int = Math.floor((center.x - width/2) / MapConstants.TILE_WIDTH);
			var topY:int  = Math.floor((center.y - height/2) / MapConstants.TILE_HEIGHT);
			var rightX:int = Math.floor((center.x + width/2) / MapConstants.TILE_WIDTH);
			var bottomY:int = Math.floor((center.y + height/2) / MapConstants.TILE_HEIGHT);
			
			var minX:uint = leftX >= 0 ? leftX : 0;
			var minY:uint = topY >= 0 ? topY : 0;
			
			var maxX:uint = rightX < maxSize.x ? rightX : maxSize.x;
			var maxY:uint = bottomY < maxSize.y ? bottomY : maxSize.y;
			
			if (minX >= maxX) minX = maxX;
			if (minY >= maxY) minY = maxY;
			
			return [minX, minY, maxX, maxY];
		}
	}
	
}

