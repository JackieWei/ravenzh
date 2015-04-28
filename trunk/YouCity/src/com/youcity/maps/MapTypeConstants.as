package com.youcity.maps
{
	import com.youcity.maps.tiles.layers.AdsTileLayer;
	import com.youcity.maps.tiles.layers.HotSpotTileLayer;
	import com.youcity.maps.tiles.layers.ImageTileLayer;
	
	/**
	 * Define different types of MapType
	 * @author Jackie Wei
	 * 此类就是提供所有MapType类型目前针对Manhattan的，包括3D，2D，透明层，小地图等
	 * 针对SanFrancisco的 包括3D， 2D。
	 */	
	public class MapTypeConstants 
	{
		private static var _maptype_Sat:MapType;
		public static function getManhattanSatMap():MapType 
		{
			if (!_maptype_Sat)
			{
				_maptype_Sat = new MapType(MapConstants.NEW_YORK, MapConstants.MAPTYPE_SATELLITE, MapConstants.MANHATTAN_MAPURL);
				var layers:Array = new Array();
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_SAT, _maptype_Sat.url));
				_maptype_Sat.setTileLayers(layers);
			}
			return _maptype_Sat;
		}
		
		private static var _maptype_3D:MapType;
		public static function getManhattan3DMap():MapType
		{
			if (!_maptype_3D || _maptype_3D.name != MapConstants.NEW_YORK) 
			{
				_maptype_3D = new MapType(MapConstants.NEW_YORK, MapConstants.MAPTYPE_3D, MapConstants.MANHATTAN_MAPURL);
				var layers:Array = new Array();
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_3D, _maptype_3D.url, 0));
				layers.push(new HotSpotTileLayer(MapConstants.LAYER_TYPE_3D_HOTSPOT, _maptype_3D.url, 1));
				layers.push(new AdsTileLayer(MapConstants.LAYER_TYPE_AD, _maptype_3D.url, 1));
				_maptype_3D.setTileLayers(layers);
			}
			return _maptype_3D;
		}
		
		public static function getSanFrancisco3DMap():MapType
		{
			if (!_maptype_3D || _maptype_3D.name != MapConstants.SAN_FRANCISCO) 
			{
				_maptype_3D = new MapType(MapConstants.SAN_FRANCISCO, MapConstants.MAPTYPE_3D, MapConstants.SAN_FRANCISCO_MAPURL);
				var layers:Array = new Array();
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_3D, _maptype_3D.url, 0));
				_maptype_3D.setTileLayers(layers);
			}
			return _maptype_3D;
		}
		
		private static var _maptype_2D:MapType;
		public static function getManhattan2DMap():MapType
		{
			if (!_maptype_2D || _maptype_2D.name != MapConstants.NEW_YORK)
			{
				_maptype_2D = new MapType(MapConstants.NEW_YORK, MapConstants.MAPTYPE_2D, MapConstants.MANHATTAN_MAPURL, MapConstants.MAP_2D_ZOOMS);
				var layers:Array = new Array();
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_2D, _maptype_2D.url));
				_maptype_2D.setTileLayers(layers);
			}
			return _maptype_2D;
		}
		
		public static function getSanFrancisco2DMap():MapType
		{
			if (!_maptype_2D || _maptype_2D.name != MapConstants.SAN_FRANCISCO)
			{
				_maptype_2D = new MapType(MapConstants.SAN_FRANCISCO, MapConstants.MAPTYPE_2D, MapConstants.SAN_FRANCISCO_MAPURL, MapConstants.MAP_2D_ZOOMS);
				var layers:Array = new Array();
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_2D, _maptype_2D.url));
				_maptype_2D.setTileLayers(layers);
			}
			return _maptype_2D;
		}
		
		private static var _maptype_MiniMap:MapType;
		public static function getManhattanMiniMap():MapType
		{
			if (!_maptype_MiniMap || _maptype_MiniMap.name != MapConstants.NEW_YORK)
			{
				_maptype_MiniMap = new MapType(MapConstants.NEW_YORK, MapConstants.MAPTYPE_2D, MapConstants.MANHATTAN_MAPURL, MapConstants.MINIMAP_ZOOMS);
				var layers:Array = new Array();
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_2D, _maptype_MiniMap.url, 0, false));
				_maptype_MiniMap.setTileLayers(layers);
			}
			return _maptype_MiniMap;
		}
		
		public static function getSanFranciscoMiniMap():MapType
		{
			if (!_maptype_MiniMap || _maptype_MiniMap.name != MapConstants.SAN_FRANCISCO)
			{
				_maptype_MiniMap = new MapType(MapConstants.SAN_FRANCISCO, MapConstants.MAPTYPE_2D, MapConstants.SAN_FRANCISCO_MAPURL, MapConstants.MINIMAP_ZOOMS);
				var layers:Array = new Array();
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_2D, _maptype_MiniMap.url, 0, false));
				_maptype_MiniMap.setTileLayers(layers);
			}
			return _maptype_MiniMap;
		}
		
		
		private static var _mapType_Transparent3D:MapType;
		public static function getManattanTransparent3DMap():MapType
		{
			if (!_mapType_Transparent3D)
			{
				_mapType_Transparent3D = new MapType(MapConstants.NEW_YORK, MapConstants.MAPTYPE_TRANSPARENT_3D, MapConstants.MANHATTAN_MAPURL);
				var layers:Array = [];
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_TRANSPARENT, _mapType_Transparent3D.url));
				layers.push(new HotSpotTileLayer(MapConstants.LAYER_TYPE_3D_HOTSPOT, MapConstants.MANHATTAN_MAPURL, 1));
				_mapType_Transparent3D.setTileLayers(layers);
			}
			return _mapType_Transparent3D;
		}
		
	}
} 
