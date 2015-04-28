package com.youcity.maps
{
	import com.youcity.maps.tiles.layers.HotSpotTileLayer;
	import com.youcity.maps.tiles.layers.ImageTileLayer;
	
	/**
	 * Define different types of MapType
	 * @author Jackie Wei
	 * 此类就是提供所有MapType类型目前只针对Manhattan的，包括3D，2D，透明层，小地图等
	 */	
	public class MapTypeConstants 
	{
		private static var _maptype_Sat:MapType;
		public static function getManhattanSatMap():MapType {
			if (!_maptype_Sat) {
				_maptype_Sat = new MapType(MapConstants.MAPTYPE_SATELLITE, MapConstants.MANHATTAN_MAPURL);
				var layers:Array = new Array();
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_SAT, _maptype_Sat.url));
				_maptype_Sat.layers = layers;
			}
			return _maptype_Sat;
		}
		
		private static var _maptype_3D:MapType;
		public static function getManhattan3DMap():MapType {
			if (!_maptype_3D) {
				_maptype_3D = new MapType(MapConstants.MAPTYPE_3D, MapConstants.MANHATTAN_MAPURL);
				var layers:Array = new Array();
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_3D, MapConstants.IMGAE_URL_PREFIX));
				layers.push(new HotSpotTileLayer(MapConstants.LAYER_TYPE_3D_HOTSPOT,  MapConstants.HOTSPOT_URL_PREFIX));
				_maptype_3D.layers = layers;
			}
			return _maptype_3D;
		}
		
		private static var _maptype_2D:MapType;
		public static function getManhattan2DMap():MapType {
			if (!_maptype_2D) {
				_maptype_2D = new MapType(MapConstants.MAPTYPE_2D, MapConstants.MANHATTAN_MAPURL, MapConstants.MAP_2D_ZOOMS);
				var layers:Array = new Array();
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_2D, _maptype_2D.url));
				_maptype_2D.layers = layers;
			}
			return _maptype_2D;
		}
		
		private static var _maptype_MiniMape:MapType;
		public static function getManhattanMiniMap():MapType {
			if (!_maptype_MiniMape) {
				_maptype_MiniMape = new MapType(MapConstants.MAPTYPE_2D, MapConstants.MANHATTAN_MAPURL, MapConstants.MINIMAP_ZOOMS);
				var layers:Array = new Array();
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_2D, _maptype_MiniMape.url));
				_maptype_MiniMape.layers = layers;
			}
			return _maptype_MiniMape;
		}
		
		private static var _mapType_Transparent3D:MapType;
		public static function getManattanTransparent3DMap():MapType {
			if (!_mapType_Transparent3D) {
				_mapType_Transparent3D = new MapType(MapConstants.MAPTYPE_TRANSPARENT_3D, MapConstants.MANHATTAN_MAPURL);
				var layers:Array = [];
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_TRANSPARENT, _mapType_Transparent3D.url));
				layers.push(new HotSpotTileLayer(MapConstants.LAYER_TYPE_3D_HOTSPOT, MapConstants.MANHATTAN_MAPURL));
				_mapType_Transparent3D.layers = layers;
			}
			return _mapType_Transparent3D;
		} 
		
		private static var _mapType_New:MapType;
		public static function getNewMap():MapType {
			if (!_mapType_New) {
				_mapType_New = new MapType(MapConstants.MAPTYPE_3D, MapConstants.NEW_MAP_URL, [4, 3, 2, 1, 0]);
				var layers:Array = [];
				layers.push(new ImageTileLayer(MapConstants.LAYER_TYPE_3D, _mapType_New.url));
				_mapType_New.layers = layers;
			}
			return _mapType_New;
		}
	}
} 
