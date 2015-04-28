package com.youcity.maps.tiles.layers
{
	import com.youcity.maps.MapConstants;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.tiles.HashMap;
	import com.youcity.maps.tiles.interfaces.ITileLayer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Abstract Class
	 * Base class for TileLayer
	 * @author Administrator
	 * 基本的层的抽象归纳，不可以直接实例化
	 * 
	 * 规定了一些必要的接口和属性，没有多少具体实现，有一些公用的方法
	 */	
	public class TileLayerBase extends Sprite implements ITileLayer
	{
		/**
		 * read only properties
		 */		
		protected var _layerName:String;
		protected var _zoom:uint;
		public function get layerName():String { return this._layerName; }
		public function get zoom():uint { return _zoom; }
		
		/**
		 * relative array to store all tiles on layer
		 */		
		protected var _tiles:HashMap;
		
		protected var _prefixUrl:String;
		
		protected var _extName:String;//file ext name, jpg, xml .ect
		
		protected var _driection:String = MapConstants.SOUTH;
		
		protected var _buffer:int = 0;
		
		protected var _zoomChangeBuffered:Boolean;
		
		/**
		 * new tiles num (need to added part)
		 */		
		protected var _newTilesNum:uint = 0
		
		/**
		 * loaded tile num
		 */		
		protected var _tilesLoadedNum:uint = 0;
		public var layerLoaded:Function;
		
		/**
		 * 
		 * @param self: for Abstract Check 
		 * @param name
		 * @param url : direct to city url
		 * @param fextName
		 * @param tileWidth
		 * @param tileHeight
		 * @param buffer
		 * 
		 */		
		public function TileLayerBase(self:TileLayerBase, name:String, url:String)
		{
			if (self != this) throw new Error("Abstract Class");
			
			_prefixUrl = url;
			_layerName = name;
		}
		
		/**
		 * clear tiles store
		 * 
		 */		
		public function clear():void {
			throw new Error("TileLayerBase. Method 'clear' should be overrided by its subclass!");
		}
		
		/**
		 * 
		 * @param width
		 * @param height
		 * @param center
		 * @param zoom
		 * to load all tiles
		 * 
		 * 读取数据，根据层的具体去实现，这里就是一个虚的函数
		 */	
		protected var isFirst:Boolean = true;
		protected var _containerPosition:ScreenPoint;
		public function loadTiles(width:uint, height:uint, center:ScreenPoint, zoom:uint):void {
			throw new Error("TileLayerBase. Method 'loadTiles' should be overrided by its subclass!");
		}
		
		/**
		 * follow rule to get server url
		 * @param point : position
		 * @param zoom : current zoom
		 * @return : url
		 * 
		 * 得到每一个Tile的Url
		 */		
		protected function getTileUrl(point:ScreenPoint, zoom:uint):String {
			if (!_extName) {
				throw new Error("TileLayerBase. Method 'getTileUrl' _extName null Error");
				return "";
			}
			var originalX:uint = point.x / MapConstants.TILE_WIDTH;
			var originalY:uint = point.y / MapConstants.TILE_HEIGHT;
			var sub_x:uint = originalX / MapConstants.SUBFOLDER_SIDE;
			var sub_y:uint = originalY / MapConstants.SUBFOLDER_SIDE;
			return _prefixUrl + '/zoom' + String(4 - zoom)+ "/" + String(sub_x) + "_" + String(sub_y) +  '/x' 
					+ originalX + 'y' + originalY + 'z0zoom' + 
					String( 4 - zoom)+ '.' + _extName;
		}
		
		/**
		 * 
		 * @param event
		 * 空函数，作为加载每个Tile的完成处理器
		 * 留待每个具体的类实现
		 */		
		protected function loadedHandler(event:Event):void {
			throw new Error("TileLayerBase. Method 'loadedHandler' should be overrided by its subclass!");
		}
	
		/**
		 * @param zoom
		 */		
		public function zoomChangedAction(zoom:int = -1):void {
			if (!_zoomChangeBuffered)
			clear();
			
			//accordToZoom(zoom);//由于地图变化，之前的_container指向的已经成为前一zoom，所以根据zoom缩放或放大
			_tiles = new HashMap();
		}
	}
}