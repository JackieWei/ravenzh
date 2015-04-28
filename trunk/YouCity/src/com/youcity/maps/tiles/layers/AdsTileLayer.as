package com.youcity.maps.tiles.layers
{
	import com.youcity.maps.MapConstants;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.tiles.HashMap;
	import com.youcity.maps.tiles.HashMapItem;
	import com.youcity.maps.tiles.layers.tiles.AdsTile;
	import com.youcity.maps.tiles.layers.tiles.HotSpotTile;
	import com.youcity.maps.tiles.layers.tiles.Tile;
	import com.youcity.maps.util.MapUtil;
	
	import flash.display.Sprite;
	
	/**
	 * HotSpot layer contains several HotSpots
	 * @author Jackie Wei
	 * AdsTileLayer继承自MonoTileLayer。里面的组织方式跟别的层都一样的方式。
	 * 不过是里面的每一项都是AdsTile。
	 */	
	public class AdsTileLayer extends MonoTileLayer
	{
		/**
		 * 
		 * @param name : name
		 * @param prefixUrl : prefixUrl for hotspot, folder location
		 * @param fileExtName : fileExtName, jpg, xml .etc
		 * @param showProgress : whether to show progress 
		 * @param tileBuffer : load tile buffer
		 * @param tileWidth : tile width
		 * @param tileHeight : tile height
		 * 
		 */		
		public function AdsTileLayer(name:String, url:String, tileBuffer:uint = 0, fileExtName:String = 'xml',  direction:String = MapConstants.SOUTH, showProgress:Boolean = false, tileWidth:uint = 256, tileHeight:uint = 256) 
		{
			super(this, name, url, direction, tileBuffer, showProgress, fileExtName, tileHeight, tileWidth, true);
			_tiles = new HashMap();
		}
		
		/**
		 * override clear, clear all
		 */		
		public override function clear():void
		{
			super.clear();
			var tileArray:Array = _tiles.toArray();
			for (var i:uint = 0; i < tileArray.length; i++)
			{
				var item:HashMapItem = tileArray[i];
				if (item) AdsTile(item.value).clear();
			}
			_tiles = new HashMap();
			while(numChildren > 0)
			{
				var t:Sprite = Sprite(getChildAt(0));
				MapUtil.removeAllChildren(t);
				removeChild(t);
			}
		}
		
		/**
		 * 
		 * @param width : district width
		 * @param height : district height
		 * @param center : center point location
		 * @param zoom : current zoom
		 * compare to store and decide what to add and what to remove
		 */		
		public override function loadTiles(width:uint, height:uint, center:ScreenPoint, zoom:uint):void 
		{
			super.loadTiles(width,height,center,zoom);
			var bound:Object = getMinMax(width, height, center, zoom, _tileBuffer, _tileWidth, _tileHeight);
			
			//var scaler:uint = MapUtil.getScaler(zoom);
			
			//use minx miny maxx maxy to check which are need and add it,
			//which are not need to remove them
			for (var row:uint = bound.minX; row < bound.maxX; row++)
			{
				for (var colum:uint = bound.minY; colum < bound.maxY; colum++)
				{
					var spoint:ScreenPoint = new ScreenPoint(zoom, row*256, colum*256);
					if (_tiles.contains(spoint.toHashKey()))
					{
						_tiles.getItem(spoint.toHashKey()).needRemove = false;
						continue;
					}
					var url:String = getTileUrl(getServerUrl(), spoint, zoom);
					var tile:AdsTile = new AdsTile(url, spoint);
					tile.load();
					tile.x = spoint.x;
					tile.y = spoint.y;
					_tiles.putItem(tile, spoint.toHashKey());
					_tiles.getItem(spoint.toHashKey()).needRemove = false;
					addChild(tile);
				}
			}
			
			//find properties in relative object and remove that should be removed
			//mark all to need removed
			var tilesArray:Array = _tiles.toArray();
			for (var i:uint = 0; i < tilesArray.length; i++)
			{
				var item:HashMapItem = tilesArray[i];
				if (true == item.needRemove)
				{
					var _item:AdsTile = AdsTile(_tiles.deleteItem(Tile(item.value).position.toHashKey()).value);
					if (_item) removeChild(_item);
					_item.clear();
				}
				else
				{
					item.needRemove = true;
				}
			}
		}
	}
}
