package com.youcity.maps.tiles.interfaces
{
	import com.youcity.maps.ScreenPoint;
	
	/**
	 * Interface for TileLayer
	 * Implemented by TileLayerBase
	 */
	public interface ITileLayer 
	{
		function get showProgress():Boolean;//readonly property decide whether to show progress or not
		function get layerName():String;//readonly property layerName
		function clear():void;//clear all tiles
		function loadTiles(width:uint, height:uint, center:ScreenPoint, zoom:uint):void;//load tiles
		function getMinMax(width:uint, height:uint, center:ScreenPoint, zoom:uint, buffer:uint, tileWidth:uint, tileHeight:uint):Object;//get bound
	}
}

