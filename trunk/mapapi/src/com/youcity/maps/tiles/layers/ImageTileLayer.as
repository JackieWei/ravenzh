package com.youcity.maps.tiles.layers
{
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.tiles.layers.tiles.ImageTile;
	import com.youcity.maps.util.DisplayUtil;
	import com.youcity.maps.util.MapUtil;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * Image Layer contains many image tiles
	 * @author Jackie Wei
	 * 根据当前Map提供的中心点和大小得到所需的图片资源，然后每个图片根据所处的行和列设定自己的位置。也就是
	 * 根据ScreenPoint得到位置。
	 * 
	 * 主要的逻辑在LoadTile函数里，别的层的此函数基本都是一致的，详细的过程参见该函数的说明
	 */	
	 
	public class ImageTileLayer extends TileLayerBase
	{
		private var _loaded:Boolean;
		private var _tileDic:Dictionary;
		
		/**
		 * 
		 * @param name
		 * @param url
		 * 
		 */		
		public function ImageTileLayer(name:String, url:String):void {
			super(this, name, url);
			_extName = "jpg";
			mouseChildren = false;
			mouseEnabled = false;
			_buffer = 1;
			_tileDic = new Dictionary(true);
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
		override public function loadTiles(width:uint, height:uint, center:ScreenPoint, zoom:uint):void {
			var bound:Array = MapUtil.getBound(width, height, center);
			var minX:int = bound[0];
			var minY:int = bound[1];
			var maxX:int = bound[2];
			var maxY:int = bound[3];
			
			for (var row:uint = minX; row <= maxX; row ++) {//双重循环，对于每一个，查看是不是已经存在
				for (var colum:uint = minY; colum <= maxY; colum ++) {
					var tile:ImageTile;
					var spoint:ScreenPoint = new ScreenPoint(zoom, row * 256, colum*256);
					var key:String = spoint.toHashKey();
					if (key in _tileDic) {
						tile = _tileDic[key];
						tile.x = spoint.x;
						tile.y = spoint.y;
						tile.gc = false;
						continue;
					}
					var url:String = getTileUrl(spoint, zoom);
					tile = new ImageTile(url);
					tile.x = spoint.x;
					tile.y = spoint.y;
					tile.url = url;
					tile.loadedHandler = loadedHandler;
					tile.load();
					addChild(tile);
					_tileDic[key] = tile;
					_newTilesNum ++;
				}
			}
			
			for (var tileKey:String in _tileDic) {
				var imageTile:ImageTile = _tileDic[tileKey];
				if (imageTile.gc) {
					delete _tileDic[tileKey];
					imageTile.clear();
					DisplayUtil.removeChild(this, imageTile);
				} else {
					imageTile.gc = true;
				}
			}
		}
		
		/**
		 * 
		 * @param event
		 * while each item loaded, dispatch event
		 * and remove event listener
		 * 
		 * 加载图片的完成事件处理器，并且当加载全部完成时候清除掉上一层的图片
		 */		
		override protected function loadedHandler(event:Event):void {
			_loaded = true;
			for each (var tile:ImageTile in _tileDic) {
				if (!tile.loaded) {
					_loaded = false;
					break;
				}
			}
			if (_loaded && layerLoaded != null) {
				layerLoaded(layerName);
			}
		}
		
		/**
		 *@override 
		 */		
		override public function clear():void {
			for (var key:String in _tileDic) {
				var tile:ImageTile = _tileDic[key];
				tile.clear();
				delete _tileDic[key];
			}
			DisplayUtil.removeAllChildren(this);
		}
	}
}

