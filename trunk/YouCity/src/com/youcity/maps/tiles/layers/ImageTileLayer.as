package com.youcity.maps.tiles.layers
{
	import com.youcity.maps.MapConstants;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.tiles.HashMap;
	import com.youcity.maps.tiles.HashMapItem;
	import com.youcity.maps.tiles.LayerContentContainer;
	import com.youcity.maps.tiles.layers.tiles.ImageTile;
	import com.youcity.maps.tiles.layers.tiles.Tile;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	/**
	 * Image Layer contains many image tiles
	 * @author Jackie Wei
	 * 根据当前Map提供的中心点和大小得到所需的图片资源，然后每个图片根据所处的行和列设定自己的位置。也就是
	 * 根据ScreenPoint得到位置。
	 * 
	 * 主要的逻辑在LoadTile函数里，别的层的此函数基本都是一致的，详细的过程参见该函数的说明
	 */	
	 
	[Event(name="imagelayer_progress", 	type="flash.events.Event")]
	[Event(name="imagelayer_loaded", 		type="flash.events.Event")]
	public class ImageTileLayer extends MonoTileLayer
	{

		/**
		 * 
		 * @param name
		 * @param prefixUrl
		 * @param fileExtName
		 * @param showProgress
		 * @param tileBuffer
		 * @param tileWidth
		 * @param tileHeight
		 * @param buffer
		 * 
		 */		
		public function ImageTileLayer(name:String, url:String,  tileBuffer:uint = 0, showProgress:Boolean = false, direction:String = MapConstants.SOUTH, fileExtName:String = 'jpg', tileWidth:uint = 256, tileHeight:uint = 256):void 
		{
			super(this, name, url, direction, tileBuffer, showProgress, fileExtName, tileHeight, tileWidth, true);
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		/**
		 * clear all things
		 * 
		 */		
		public override function clear():void
		{
			super.clear();
		}
		
		/**
		 * 
		 * @param width : district width
		 * @param height : district height
		 * @param center : center
		 * @param zoom : zoom
		 * 最核心的代码之一。主要功能就是每次center或者size变化就重新计算并得到新的地图块的数据。
		 * 
		 * 首先根据getMinMax得到当前宽高center下应当取哪些地图数据（关于_container部分请参见TileLayerBase里的zoomChangedAction函数，
		 * 该函数主要和此部分代码合作完成zoom变化时候地图的缩放，缓冲等）。然后循环遍历，与当前哈希表里存储的数据对照，
		 * 如果是已经存在，就把此块地图标记为需要的，不可删除的，然后如果是新的地图就添加进去，同样标记为不可删除的。
		 * 
		 * 然后在第二个循环里删除所有标记为需要删除的(needRemove==true)然后别的未被标记删除的项全部都标记为删除，等待下次执行此函数
		 */		
		public override function loadTiles(width:uint, height:uint, center:ScreenPoint, zoom:uint):void 
		{
			super.loadTiles(width,height,center,zoom);
			var bound:Object = getMinMax(width, height, center, zoom, _tileBuffer, _tileWidth, _tileHeight);//得到当前地图容器所需要的范围,
			_newTilesNum = 0;
			_tilesLoadedNum = 0;
			if (isFirst && !_container)//这段主要是初始化container，只有在需要zoom时候的才会有这样的代码
			{
				_container = new LayerContentContainer((bound.maxX - bound.minX) * _tileWidth, (bound.maxY - bound.minY) * _tileHeight);
				addChild(_container);
				_container.position = new ScreenPoint(zoom, bound.minX*256, bound.minY*256);
				isFirst = false;
				_tiles = new HashMap();
			} 
			for (var row:uint = bound.minX; row < bound.maxX; row++)//双重循环，对于每一个，查看是不是已经存在
			{
				for (var colum:uint = bound.minY; colum < bound.maxY; colum++)
				{
					var spoint:ScreenPoint = new ScreenPoint(zoom, row*256, colum*256);
					if (_tiles.contains(spoint.toHashKey()))//如果当前块已经存在，那就把它needRemove标记为false
					{
						_tiles.getItem(spoint.toHashKey()).needRemove = false;
						continue;
					} 
					var url:String = getTileUrl(getServerUrl(), spoint, zoom);//下面是如果不存在此块的情况，如果不存在，那么就创建新的块，添加进去
					//并且标记needRemove = false;
					var tile:ImageTile = new ImageTile(url, spoint);
					
					if (_showProgress) tile.addEventListener(TileLayerBase.EVENT_LOADED, loadedHandler);
					tile.x = spoint.x - _container.x;
					tile.y = spoint.y - _container.y;
					_tiles.putItem(tile, spoint.toHashKey());
					_tiles.getItem(spoint.toHashKey()).needRemove = false;
					_container.addChild(tile);
					tile.load();
					_newTilesNum ++;
				}
			}
			
			
			var _tileArray:Array = _tiles.toArray();
			for (var i:uint = 0; i < _tileArray.length; i++)//在此循环里把所有标记needRemove = true的都删除，别的都标记needRemove = true;
			{
				var item:HashMapItem = _tileArray[i];
				if (true == item.needRemove)//如果该项标记为needRemove那就移除
				{
					var _item:Tile = Tile(_tiles.deleteItem(Tile(item.value).position.toHashKey()).value);
					if (_item && _container.contains(_item))
					_container.removeChild(_item);
					_item.clear();
				}
				else//否则就标记为需要移除
				{
					item.needRemove = true;
				}
			}

		}
		
		/**
		 * 
		 * @return 
		 * 得到snapshotUrl，目前没用了
		 */		
		protected function getSnapUrl():String
		{
			if (MapConstants.ISMAN == true)
			return _prefixUrl + "/" + MapConstants.LAYER_TYPE_3D_SNAPSHOT + "/" + _direction;
			
			return _prefixUrl + "/" + layerName;
		}
		
		/**
		 * 
		 * @param event
		 * while each item loaded, dispatch event
		 * and remove event listener
		 * 
		 * 加载图片的完成事件处理器，并且当加载全部完成时候清除掉上一层的图片
		 */		
		override protected function loadedHandler(event:Event):void
		{
			_tilesLoadedNum ++;
			IEventDispatcher(event.target).removeEventListener(Event.COMPLETE, loadedHandler);
			dispatchEvent(new Event('imagelayer_progress'));
			if (true)
			{
				dispatchEvent(new Event('imagelayer_loaded'))//当图片加载完成派发完成事件;
				if (_proxy)//如果上一层地图存在，清楚该层地图
				{
					while(_proxy.numChildren > 0)
					{
						ImageTile(_proxy.getChildAt(0)).removeEventListener(Event.COMPLETE, loadedHandler);
						ImageTile(_proxy.getChildAt(0)).clear();
						_proxy.removeChildAt(0);
					}
					removeChild(_proxy);
					_proxy = null;
				}
			}
		}
	}
}

