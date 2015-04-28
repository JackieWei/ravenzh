package com.youcity.maps.tiles.interfaces
{
	import com.youcity.maps.ScreenPoint;
	
	/**
	 * Interface for TileLayer
	 * Implemented by TileLayerBase
	 */
	public interface ITileLayer 
	{
		function get layerName():String;//readonly property layerName
		function loadTiles(width:uint, height:uint, center:ScreenPoint, zoom:uint):void;//load tiles
		function clear():void;//clear all tiles
	}
}

