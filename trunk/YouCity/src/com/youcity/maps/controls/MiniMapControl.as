package com.youcity.maps.controls
{
	import com.youcity.maps.Map;
	
	
	/**
	 * Encapsulate minimap control logic here.
	 * @author Administrator
	 * 
	 */	
	public class MiniMapControl extends ControlBase 
	{
		private var _mapping:Array;
		public function get mapping():Array
		{
			return _mapping;
		}
		
		private var _reverseMapping:Array;
		public function get reverseMapping():Array
		{
			return _reverseMapping;
		}
		
		public function MiniMapControl(map:Map)
		{
			super(map);
			_mapping = [2, 3, 4, 4, 4];
			_reverseMapping = [0,0,0,1,2];
		}
	}
}

