package com.youcity.maps
{
	/**
	 * 
	 * @author Jackie Wei
	 * CityConstant define const vars
	 * for translating between MapPoint 
	 * and WGS84 according to a city
	 * 这个类没有用到呢。
	 */	
	internal class CityConstant
	{
//		public var A:Number = 2.24485653053594e-006;
//		public var B:Number =  2.10387177884686e-006;
//		public var C:Number = -74.083054038437;
//		public var D:Number= 1.01855486506902e-006;
//		public var E:Number = -2.65122348523661e-006;
//		public var F:Number = 40.7344846224975;
	
		public var A:Number = 2.23606676726107e-006;
		public var B:Number = 2.09777281803825e-006;
		public var C:Number = -74.1634252826989;
		public var D:Number = 1.01745337808407e-006;
		public var E:Number = -2.65560996243197e-006;
		public var F:Number = 40.7422050790874;
		
		private static var _cityInstance:CityConstant = new CityConstant();
		private static var _city:String;
		
		public function CityConstant():void
		{
			if (_cityInstance)
			throw new Error("Singleton Class please use getInstanceByCity");
		}
		
		/**
		 * get city's constant data by city name
		 * @param city
		 * @return 
		 * 
		 */		
		public static function getInstanceByCity(city:String):CityConstant
		{
			if (_cityInstance && _city == city) return _cityInstance;
			_cityInstance = null;
			_cityInstance = new CityConstant();
			_city = city;
			return _cityInstance;
		}
	}
}