package com.youcity.maps.tiles.layers
{
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.tiles.HashMap;
	import com.youcity.maps.tiles.LayerContentContainer;
	import com.youcity.maps.tiles.interfaces.ITileLayer;
	import com.youcity.maps.tiles.layers.tiles.Tile;
	import com.youcity.maps.util.MapUtil;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	[Event(name="progress", type="flash.events.Event")]
	[Event(name="loaded", type="flash.events.Event")]
	
	/**
	 * Abstract Class
	 * Base class for TileLayer
	 * @author Administrator
	 * 基本的层的抽象归纳，不可以直接实例化
	 * 
	 * 规定了一些必要的接口和属性，没有多少具体实现，有一些公用的方法
	 */	
	public class TileLayerBase extends UIComponent implements ITileLayer
	{
		public static const EVENT_PROGRESS:String = "progress";
		public static const EVENT_LOADED:String = "loaded";
		
		/**
		 * read only property show progress
		 * process
		 */		
		protected var _progress:Number = 0;
		public function get progress():Number
		{
			return _progress;
		}
		
		/**
		 * read only progress show whether to show
		 * progress 
		 */		
		protected var _showProgress:Boolean;
		public function get showProgress():Boolean
		{
			return _showProgress;
		}
		
		/**
		 * relative array to store all tiles on layer
		 */		
		protected var _tiles:HashMap;
		
		/**
		 * prefix url
		 */		
		protected var _prefixUrl:String;
		
		
		/**
		 * read only property layerName
		 */		
		private var _layerName:String;
		public function get layerName():String
		{
			return _layerName;
		}
		
		protected var _direction:String;
		public function get direction():String
		{
			return _direction;
		}
		public function set direction(value:String):void
		{
			_direction = value;
			clear();
		}
		
		protected var _zoom:uint;
		public function get zoom():uint
		{
			return _zoom;
		}
		
		protected var _container:LayerContentContainer;
		
		protected var _zoomChangeBuffered:Boolean;
		
		/**
		 * new tiles num (need to added part)
		 */		
		protected var _newTilesNum:uint = 0
		
		/**
		 * loaded tile num
		 */		
		protected var _tilesLoadedNum:uint = 0;
		
		/**
		 * 
		 * @param self: for Abstract Check 
		 * @param name
		 * @param url : direct to city url
		 * @param fextName
		 * @param showProgress
		 * @param tileWidth
		 * @param tileHeight
		 * @param buffer
		 * 
		 */		
		public function TileLayerBase(self:TileLayerBase, name:String, url:String, direction:String, showProgress:Boolean)
		{
			if (self != this) throw new Error("Abstract Class");
			
			_prefixUrl = url;
			_direction = direction;
			_showProgress  = showProgress;
			_layerName = name;
		}
		
		/**
		 * clear tiles store
		 * 
		 */		
		public function clear():void
		{
			for each (var item:Object in _tiles)
			{
				if (!item) break;
				Tile(item.value).removeEventListener(TileLayerBase.EVENT_LOADED, loadedHandler);
				Tile(item.value).clear();
			}
			_tiles = new HashMap();
			
			if (_container)
			MapUtil.removeAllChildren(_container);
			
//			MapUtil.removeAllChildren(this);
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
		protected var paramObj:Object = new Object();
		public function loadTiles(width:uint, height:uint, center:ScreenPoint, zoom:uint):void 
		{
			paramObj.width = width;
			paramObj.height = height;
			paramObj.center = center;
			paramObj.zoom = zoom;
			return;
		}
		
		/**
		 * 
		 * @param width
		 * @param height
		 * @param center
		 * @param zoom
		 * @return an object contains boundary : minX, minY, maxX, maxY 
		 * use width, height, and center, zoom to set boundary
		 * 
		 * 得到最小最大的范围
		 */	
		public function getMinMax(width:uint, height:uint, center:ScreenPoint, zoom:uint, buffer:uint, tileWidth:uint, tileHeight:uint):Object
		{
			var maxSize:Point = MapUtil.getMapSize(zoom);
			var leftX:int = Math.floor((center.x - width/2) / tileWidth) - buffer;
			var topY:int  = Math.floor((center.y - height/2) / tileHeight) - buffer;
			var rightX:int = Math.ceil((center.x + width/2) / tileWidth) + buffer;
			var bottomY:int = Math.ceil((center.y + height/2) / tileHeight)  + buffer;
			
			var _minX:uint = leftX > 0 ? leftX : 0;
			var _minY:uint = topY > 0 ? topY : 0;
			
			var _maxX:uint = rightX < maxSize.x? rightX : maxSize.x;
			var _maxY:uint = bottomY < maxSize.y? bottomY : maxSize.y;
			
			if (_minX >= _maxX) _minX = _maxX;
			if (_minY >= _maxY) _minY = _maxY;
			
			return {minX:_minX, minY:_minY, maxX:_maxX, maxY:_maxY};
		}
		
		/**
		 * 
		 * @param event
		 * 空函数，作为加载每个Tile的完成处理器
		 * 留待每个具体的类实现
		 */		
		protected function loadedHandler(event:Event):void
		{
			
		}
		
		protected var _proxy:LayerContentContainer;
		protected var _lastProxy:LayerContentContainer;
		/**
		 * 
		 * @param zoom
		 * 这个函数主要是把上一级别地图（如果有的话）缩放或者放大，然后把再前一级别（如果有的话）remove掉
		 * _proxy指向的是前一个zoom级别，就是那个需要缩放或者放大的层级
		 * _lastProxy是指向_proxy之前指向的那个zoom级别的图，主要是为了把它remove掉
		 * _container永远指向最新的地图
		 */		
		public function zoomChangedAction(zoom:int = -1):void
		{
			if (!_zoomChangeBuffered)
			clear();

			if (!_container) 
			return;
			
			_container.accordToZoom(zoom);//由于地图变化，之前的_container指向的已经成为前一zoom，所以根据zoom缩放或放大
			_lastProxy = _proxy;//_lastProxy指向再之前的那个zoom下的
			if (_lastProxy && contains(_lastProxy))//如果确实存在再前一个zoom下的图，就清楚它
			{
				while(_lastProxy.numChildren > 0)
				{
					Tile(_lastProxy.getChildAt(0)).removeEventListener(Event.COMPLETE, loadedHandler);
					Tile(_lastProxy.getChildAt(0)).clear();
					_lastProxy.removeChildAt(0);
				}
				removeChild(_lastProxy);
				_lastProxy = null;
			}
			_proxy = _container;//把_container指向的图给_proxy
			if (_proxy)//如果有上一zoom级别的图，把其中每个的事件处理器移除，以便移除
			{
				for (var i:uint = 0; i < _proxy.numChildren; i++)
				{
					_proxy.getChildAt(i).removeEventListener(TileLayerBase.EVENT_LOADED, loadedHandler);
				}
			}
			_container = null;
			isFirst = true;
			_tiles = new HashMap();
			//然后清除_tiles。container将会被重新初始化并且加载新的地图
		}
	}
}