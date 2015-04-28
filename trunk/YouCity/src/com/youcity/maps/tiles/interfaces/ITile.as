package com.youcity.maps.tiles.interfaces
{
	import com.youcity.maps.ScreenPoint;
	
	import flash.display.DisplayObject;
	
	/**
	 * Interface
	 * @author Jackie Wei
	 * 
	 */	
	public interface ITile
	{
		function get position():ScreenPoint//readonly property position
		function get loaded():Boolean//readonly property loaded
		function load():void//function to load data and return a displayobject
		
	}
}