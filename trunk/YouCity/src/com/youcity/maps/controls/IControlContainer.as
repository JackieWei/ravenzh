package com.youcity.maps.controls
{
	/**
	 * Interface methods for ControlContainer 
	 * @author raven
	 * 
	 */	
	public interface IControlContainer 
	{
		function get controlsArray():Array;
		
		function set controlsArray(arr:Array):void;
		
		function addControl(control:IControl):void;
		
		function addControlAt(control:IControl, index:uint):void;
		
		function removeControl(control:IControl):void;
		
		function removeAllControls():void;
		
	}

}
