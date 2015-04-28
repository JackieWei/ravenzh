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
		
		public function MapTypeControl(map:Map)
		{
			super(map);
		}
		
		/**
		 * 
		 * @param type
		 * 
		 */		 
		public function setMapType(type:String):void
		{
			for (var i:String in map.mapTypes)
			{
				if (map.mapTypes[i].type == type)
				{
				 	this.map.setMapType(map.mapTypes[i]);
				 	return;
				}					
			}
		}
		
	}
}
