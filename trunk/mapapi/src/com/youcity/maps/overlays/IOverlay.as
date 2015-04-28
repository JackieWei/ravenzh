package com.youcity.maps.overlays
{
	import com.youcity.maps.MapPoint;
	import com.youcity.maps.ScreenPoint;
	
	/**
	 * Interface methods for Overlay 
	 * @author raven
	 * 
	 */
	public interface IOverlay 
	{
	 	function getOverlayPosition():ScreenPoint;
	 	
	 	function setOverlayPosition(value:ScreenPoint):void;
	 	
	 	function  destory():void;
	}
}
 
