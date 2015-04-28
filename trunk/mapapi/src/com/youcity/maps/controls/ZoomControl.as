package com.youcity.maps.controls
{
	import com.youcity.maps.Map;
	import com.youcity.maps.ScreenPoint;
	
	import flash.display.Sprite;
	
	/**
	 * Encapsulate the zoom control logic here. 
	 * @author Administrator
	 * 
	 */
	public class ZoomControl extends ControlBase 
	{
		 
		public function ZoomControl(map:Map)
		{
			super(map);
		}		
		 
		public function zoomIn():void
		{
			this.map.zoomIn();
		}
		
		public function zoomOut():void 
		{
		 	this.map.zoomOut();
		}
		 
		public function setZoom(zoom:uint):void 
		{
			this.map.setZoom(zoom);
		}
		 
	}
}
