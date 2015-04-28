package com.youcity.maps.tiles.layers
{
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.tiles.HashMap;
	import com.youcity.maps.tiles.HashMapItem;
	import com.youcity.maps.tiles.layers.tiles.HotSpotTile;
	import com.youcity.maps.tiles.layers.tiles.Tile;
	import com.youcity.maps.util.DisplayUtil;
	import com.youcity.maps.util.MapUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * HotSpot layer contains several HotSpots
	 * @author Jackie Wei
	 * 通用的组织方式，不过里面每一项都可能会有数个（0-多）个hotspot，主要处理数据都在HotSpotTile里
	 */	
	public class HotSpotTileLayer extends TileLayerBase
	{
		/**
		 * 
		 * @param name : name
		 * @param prefixUrl : prefixUrl for hotspot, folder location
		 * @param fileExtName : fileExtName, jpg, xml .etc
		 * @param tileBuffer : load tile buffer
		 * @param tileWidth : tile width
		 * @param tileHeight : tile height
		 * 
		 */		
		public function HotSpotTileLayer(name:String, url:String) 
		{
			super(this, name, url);
			_tiles = new HashMap();
			_extName = "xml";
		}
		
		/**
		 * @override
		 * override clear, clear all
		 */		
		override public  function clear():void {
			var tileArray:Array = _tiles.toArray();
			var length:int = tileArray.length;
			for (var i:uint = 0; i < length; i++) {
				var item:HashMapItem = tileArray[i];
				if (item) HotSpotTile(item.value).clear();
			}
			_tiles = new HashMap();
			DisplayUtil.removeAllChildren(this);
		}
		
		/**
		 * @override
		 * @param width : district width
		 * @param height : district height
		 * @param center : center point location
		 * @param zoom : current zoom
		 * compare to store and decide what to add and what to remove
		 */		
		override public function loadTiles(width:uint, height:uint, center:ScreenPoint, zoom:uint):void  {
			super.loadTiles(width, height, center, zoom);
			var bound:Array = MapUtil.getBound(width, height, center);
			var minX:int = bound[0];
			var minY:int = bound[1];
			var maxX:int = bound[2];
			var maxY:int = bound[3];
			
			//use minx miny maxx maxy to check which are need and add it,
			//which are not need to remove them
			for (var row:uint = minX; row < maxX; row ++) {
				for (var colum:uint = minY; colum < maxY; colum ++) {
					var spoint:ScreenPoint = new ScreenPoint(zoom, row*256, colum*256);
					if (_tiles.contains(spoint.toHashKey())) {
						_tiles.getItem(spoint.toHashKey()).needRemove = false;
						continue;
					}
					var url:String = getTileUrl(spoint, zoom);
					var tile:HotSpotTile = new HotSpotTile(url, spoint);
					tile.x = spoint.x;
					tile.y = spoint.y;
					tile.load();
					_tiles.putItem(tile, spoint.toHashKey());
					_tiles.getItem(spoint.toHashKey()).needRemove = false;
					addChild(tile);
				}
			}
			
			//find properties in relative object and remove that should be removed
			//mark all to need removed
			var tilesArray:Array = _tiles.toArray();
			for (var i:uint = 0; i < tilesArray.length; i++) {
				var item:HashMapItem = tilesArray[i];
				if (true == item.needRemove) {
					var _item:HotSpotTile = HotSpotTile(_tiles.deleteItem(Tile(item.value).position.toHashKey()).value);
					if (_item) removeChild(_item);
					_item.clear();
				} else {
					item.needRemove = true;
				}
			}
		}
		
		/**
		 * @override 
		 * @param event
		 */		
		override protected function loadedHandler(event:Event):void {
			//todo
		}
		
	}
}
