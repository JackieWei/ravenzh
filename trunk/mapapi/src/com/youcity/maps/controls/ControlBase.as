package com.youcity.maps.controls
{

	import com.youcity.maps.Map;
	import com.youcity.maps.ScreenPoint;
	
	import flash.display.Sprite;
	
	/**
	 * The base class of control.
	 * @author Administrator
	 * 
	 */	
	public class ControlBase implements IControl 
	{
	
		/**
		 * The map instance in the control 
		 */		
		private var _map:Map;
		
		public function get map():Map
		{
			return this._map;
		}

		/**
		 * Create a new Control with parameters map and postion. 
		 * @param map
		 * @param position
		 * 
		 */		
		public function ControlBase(map:Map):void
		{
			this._map = map;
		}
	}
}

