package com.youcity.maps.tiles.layers
{
	import com.youcity.maps.MapConstants;
	import com.youcity.maps.ScreenPoint;
	
	/**
	 * 
	 * @author Administrator
	 * 单层的Layer，主要是本来还有个双层的，包括snap和image的那个地图层，但是需求变化了之后就不需要了。
	 * 这个类是虚类，直接实例化没有任何意义，只用来继承
	 * 如果不需要有双层或多层图的话那也可以把这个里面的代码归结到TileLayerBase里
	 * 
	 * 
	 */	
	public class MonoTileLayer extends TileLayerBase
	{
		/**
		 * tile width
		 */		
		protected var _tileWidth:int;
		
		/**
		 * tile height
		 */		
		protected var _tileHeight:int;
		
		/**
		 * tilelayer's buffer
		 */		
		protected var _tileBuffer:int;
		
		/**
		 * file ext name, jpg, xml .ect
		 */		
		protected var _fileExtendName:String;
		
		public function MonoTileLayer(self:MonoTileLayer, name:String, url:String, direction:String, tileBuffer:uint, showProgress:Boolean, fileExtName:String, tileWidth:uint, tileHeight:uint, zoomChangeBuffered:Boolean)
		{
			super(self, name, url, direction, showProgress);
			_tileBuffer = tileBuffer;
			_tileHeight = tileHeight;
			_tileWidth = tileWidth;
			_fileExtendName = fileExtName;
			_zoomChangeBuffered = zoomChangeBuffered;
			if (self != this)
			{
				throw new Error("Abstract Class");
			}
		}
		
		/**
		 * follow rule to get server url
		 * @param point : position
		 * @param zoom : current zoom
		 * @return : url
		 * 
		 * 得到每一个Tile的Url
		 */		
		protected function getTileUrl(serverUrl:String, point:ScreenPoint, zoom:uint):String
		{
			var x:uint = point.x/_tileWidth;
			var y:uint = point.y/_tileHeight;
			var sub_x:uint = x / MapConstants.SUBFOLDER_SIDE;
			var sub_y:uint = y / MapConstants.SUBFOLDER_SIDE;
			return serverUrl + '/zoom' + String(zoom)+ "/" + String(sub_x) + "_" + String(sub_y) +  '/x' 
					+ String(point.x/_tileWidth) + 'y' + String(point.y/_tileHeight) + 'z0zoom' + 
					String(zoom)+ '.' + _fileExtendName;
		}
		
		/**
		 * 
		 * @return prefix url except zoom folder
		 * 得到当前图层所在的Url前缀
		 */		
		protected function getServerUrl():String
		{
			return _prefixUrl + "/" + layerName + "/" + _direction;
		}
	}
}