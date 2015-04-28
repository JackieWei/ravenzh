package com.youcity.maps
{
	import com.youcity.maps.tiles.layers.TileLayerBase;
	
	import flash.utils.setTimeout;
	
	internal class MapType implements IMapType
	{
		/**
		 * read only property
		 * tile layes, store tilelayer instances
		 */		
		private var _layers:Array = [];//存储layers
		public function get layers():Array { return _layers; }
		public function set layers(value:Array):void {
			_layers = value;
		}
		
		/**
		 * read only property for zoom levels Array.
		 */		
		private var _zoomArray:Array;//当前maptype的zooms 数组
		public function get zoomArray():Array { return _zoomArray; }
		
		/**
		 * read only property name,
		 * init in constructor 
		 */		
		private var _name:String;//当前maptype的名字
		public function get name():String { return _name; }
		
		/**
		 * read only property map,
		 * init in constructor
		 */		
		private var _map:Map;
		public function set map(value:Map):void {//设置当前所作用的map
			_map = value;
		}
		
		/**
		 * 记录当前maptype所在的url
		 * readonly property url, store maptype's url
		 */		
		private var _url:String;
		public function get url():String { return _url; }
		
		/**
		 * @constructor
		 * @param name: MapType's name, according to MapType's url
		 * @param cityUrl:url to current city
		 * maptype的类是管理各个层，并且直接和各个层级想交互的主要的类之一。
		 * maptype的主要功能就是接受并存储各个层级，然后对这些层级做一些通用的操作，比如加载
		 * 数据，转变方向。本类原则上不对map之外的代码提供任何接口。
		 * */
		public function MapType(name:String, url:String, zooms:Array = null) {
			_name = name;
			_zoomArray = zooms ? zooms : MapConstants.ZOOMS;
			_url = url;
		}
		
		/**
		 * 
		 * @param clear: decide if need clear former
		 * load all tiles in tilelayers
		 */		
		public function loadTiles(zoomChanged:Boolean = false):void {
			var length:int = _layers.length;
			if (length == 0)
			return;
			if (!_map) 
			return;
			for (var i:uint = 0; i < length; i ++) {
				var layer:TileLayerBase = _layers[i];
				if (zoomChanged) {
					 layer.zoomChangedAction(_map.zoom);//zoomchange的话就让每个TileLayerBase执行zoom变化，当然对于
				}
				//除了imageLayer之外的层目前都没有实现这个过程，所以其实这些层只是预留接口。
				if (_map.mapWidth != 0 && _map.mapHeight !=0) {
					var delay:uint = zoomChanged ? MapConstants.ZOOM_CHANGED_EFFECT_TIME : 0;
					setTimeout(loadTilesssss, delay, layer);
				}
			}
		}
		
		private function loadTilesssss(target:TileLayerBase):void {//延时加载数据
			target.loadTiles(_map.mapWidth, _map.mapHeight, _map.center.toScreenPoint(_map.zoom), _map.zoom);
		}
	}
}