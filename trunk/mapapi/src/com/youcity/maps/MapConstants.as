package com.youcity.maps
{
	import flash.geom.Point;
	
	/**
	 * public static constant methods or vars
	 * 一些静态的属性
	 */
	public final class MapConstants
	{

		/**
		 *define actions of the Map 
		 */		
		public static const FORWARD_WEST:String	= "forwardWest";
		public static const FORWARD_NORTH:String	= "forwardNorth";
		public static const FORWARD_EAST:String	= "forwardEast";
		public static const FORWARD_SOUTH:String	= "forwardSouth";
		public static const MEASURE_START:String 	= "measureStart";
		public static const MEASURE_END:String 	= "measureEnd";
		public static const ZOOM_IN:String 	= "zoomIn";
		public static const ZOOM_OUT:String 	= "zoomOut";
			
		public static const HANGZHOU_MAPURL_REMOTE:String = 'http://61.164.44.123/cache/hangzhou';
		public static const MANHATTAN_MAPURL_REMOTE:String = 'http://www.youcity.com/maps';
		
//		public static var SERVER_URL:String = "http://localhost:8080";
		public static var NEW_MAP_URL:String = "http://www.youcity.com/pitz/south";
		
		public static const CITY_MANHATTAN:String = "man";
		public static const CITY_MANHATTAN_NEW:String = "man_new";
		
		public static const MAPTYPE_3D:String = "3d";
		public static const MAPTYPE_2D:String = "2d";
		public static const MAPTYPE_SATELLITE:String = "satellite";
		public static const MAPTYPE_TRANSPARENT_3D:String = "transparent";//transparent_3d
		
		public static const WEST:String = "west";
		public static const NORTH:String = "north";
		public static const EAST:String = "east";
		public static const SOUTH:String = "south";
		public static const LAYER_TYPE_3D:String = "3d";
		public static const LAYER_TYPE_TRANSPARENT:String = "transparent";
		public static const LAYER_TYPE_3D_HOTSPOT:String = "3dhotspot";
		public static const LAYER_TYPE_3D_SNAPSHOT:String = "3dsnapshot";
		public static const LAYER_TYPE_ROAD:String = "road";
		public static const LAYER_TYPE_2D:String = "2d";
		public static const LAYER_TYPE_SAT:String = "sat";
		public static const LAYER_TYPE_AD:String = "ad";
		public static const LAYER_TYPE_TRANSLUCENT:String = "translucent";
		public static const LAYER_TYPE_TRANSLUCENT_SNAPSHOT:String = "translucentsnapshot";
		public static const LAYER_TYPE_TRANSLUCENT_HOTSPOT:String = "translucenthotspot";
		public static const LAYER_TYPE_MAPBASE:String = "mapbase";
		
		public static const IMGAE_URL_PREFIX:String = "http://localhost:8080/3d/image";
		public static const HOTSPOT_URL_PREFIX:String = "http://localhost:8080/3d/hotspot";
		
		public static var AD_PREFIX:String;
		
		public static const ZOOM_CHANGED_EFFECT_TIME:Number = 0.2;//second
		
		public static const MANHATTANCONSTANTS:CityConstant = CityConstant.getInstanceByCity("Manhattan");
		
		public static var MANHATTAN_MAPURL:String;
		
		public static const TOTALLEVEL:uint = 5;
		
		public static const SUBFOLDER_SIDE:Number = 50;
		
		public static const ZOOMS:Array = [0, 1, 2, 3, 4];
		
		public static const MINIMAP_ZOOMS:Array = [2, 3, 4];
		
		public static const MAP_2D_ZOOMS:Array = [0, 1, 2, 3, 4];
		
		public static const BASESIZE:Point = new Point(8, 8);
		
		public static const HOTSPOT_LINE_COLOR:uint = 0xf6f31b;
		
		public static const HOTSPOT_LINE_WIDTH:uint = 1;
		
		public static const HOTSPOT_LINE_ALPHA:Number = 0.8;
		
		public static const HOTSPOT_FILL_COLOR:uint = 0xbfff16;
		
		public static const HOTSPOT_FILL_ALPHA:Number = 0.4;
		
		public static const SLIDE_DELAY:uint = 1000;
		
		public static const TILE_WIDTH:int = 256;
		
		public static const TILE_HEIGHT:int = 256;
	}
}