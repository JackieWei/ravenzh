package com.youcity.maps
{
	
	/**
	 * 
	 * @author Jackie Wei
	 * LatLng Point for WGS84 and translate to MapPoint
	 * 经纬度点，并且扩展出可以转换的方法，主要是转换到MapPoint
	 */	
	public class LatLngPoint
	{
		/**
		 * lat:纬度
		 */		
		public var lat:Number;
		
		/**
		 * lng:经度
		 */		
		public var lng:Number;
		
		public function get type():String
		{
			return "wgs84";
		}
		
		public function LatLngPoint(lat:Number, lng:Number)
		{
			if (!lat || !lng) throw new Error("lat or lng is invalid");
			this.lat = lat;
			this.lng = lng;
		}
		
		/**
		 * 
		 * @param constant city constant
		 * @return relative MapPoint to a city
		 * 
		 */		
		public function toMapPoint (constant:CityConstant = null):MapPoint
		{
			if (!constant) constant = MapConstants.MANHATTANCONSTANTS;
			return new MapPoint((constant.E * lng - constant.B * lat - constant.C*constant.E + constant.B*constant.F)/(constant.A*constant.E - constant.B*constant.D),  (constant.D * lng - constant.A * lat - constant.C*constant.D + constant.A*constant.F)/(constant.B*constant.D - constant.A*constant.E));
		}
		
		/**
		 * 
		 * @return hash key
		 * 
		 */		
		public function toHashKey():String
		{
			return "lat:" + String(lat) + ";lng:" + String(lng);
		}
		
	}
} 
