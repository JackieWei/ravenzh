package com.youcity.maps.controls
{
	import com.youcity.maps.Map;
	 
	/**
	 * Encapsulate maptype control logic here.
	 * @author raven
	 * 
	 */	
	public class MapTypeControl extends ControlBase 
	{
	
		private var mapTypeArray:Array;
		
		public function MapTypeControl(map:Map)
		{
			super(map);
			mapTypeArray = map.mapTypes;
		}
		
		/**
		 * 
		 * @param type
		 * 
		 */		 
		public function setMapType(type:String):void
		{
			for (var i:String in mapTypeArray)
			{
				if (mapTypeArray[i].name == type)
				{
				 	this.map.setMapType(mapTypeArray[i]);
				 	return;
				}					
			}
		}
		
	}
}
