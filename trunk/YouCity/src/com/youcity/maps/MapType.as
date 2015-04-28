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
		private var _tileLayers:Array;//存储layers
		public function get tileLayers():Array
		{
			return _tileLayers;
		}
		
		/**
		 * 
		 * @param value: tileLayers Array
		 * set tilelayes for MapType, needed for init MapType
		 */		
		public function setTileLayers(value:Array):void//直接设置layers
		{
			_tileLayers = value;
			if (value.length > 0) _direction = TileLayerBase(value[0]).direction;
		}
		
		/**
		 * read only property for zoom levels Array.
		 */		
		private var _zoomArray:Array;
		public function get zoomArray():Array//得到当前maptype的zooms 数组
		{
			return _zoomArray;
		}
		
		/**
		 * Store MapType's cityName
		 */		
		private var _name:String;
		public function get name():String//当前city的名字
		{
			return this._name;
		}
		
		public function set name(value:String):void
		{
			this._name = value;
		}
		
		/**
		 * Store MapType's type
		 * proablely value could be "3d", "2d", "transparent" , "satellite"
		 */		
		private var _type:String;
		public function get type():String
		{
			return this._type;
		}
		
		public function set type(value:String):void
		{
			this._type = value;
		}
		/**
		 * read only property map,
		 * init in constructor
		 */		
		private var _map:Map;
		public function set map(value:Map):void//设置当前所作用的map
		{
			_map = value;
		}
		
		/**
		 * direction, decide which direction show be used
		 */		
		private var _direction:String;
		public function get direction():String//当前的方向
		{
			return _direction;
		}
		public function set direction(value:String):void//设置方向参数，并且重新加载该方向的数据
		{
			if (!_tileLayers || _tileLayers.length <= 0) return;
			if (value == _direction) return;
			_direction = value;
			for (var i:uint = 0; i < _tileLayers.length; i++)
			{
				var item:TileLayerBase = TileLayerBase(_tileLayers[i]);
				item.direction = value;
				item.loadTiles(_map.size.x,_map.size.y,_map.center.toScreenPoint(_map.zoom), _map.zoom);
			}
		}
		
		/**
		 * readonly property url, store maptype's url
		 */		
		private var _url:String;
		public function get url():String//url属性，记录当前maptype所在的url，原来是根据maptype分的，现在这个url和city的url没区别了
		{
			return _url;
		}
		
		/**
		 * @constructor
		 * @param name: MapType's name, according to MapType's url
		 * @param cityUrl:url to current city
		 * 
		 */	
		/**
		 * maptype的类是管理各个层，并且直接和各个层级想交互的主要的类之一。
		 * maptype的主要功能就是接受并存储各个层级，然后对这些层级做一些通用的操作，比如加载
		 * 数据，转变方向。本类原则上不对map之外的代码提供任何接口。
		 * */
		public function MapType(name:String, type:String, url:String, zooms:Array = null)
		{
			_name = name;
			_type = type
			_url = url;
			_zoomArray = zooms ? zooms : MapConstants.ZOOMS;
		}
		
		/**
		 * 
		 * @param clear: decide if need clear former
		 * load all tiles in tilelayers
		 */		
		private var _item:TileLayerBase;		
		public function loadTiles(zoomChanged:Boolean = false):void
		{
			//if _titleLayer is null or its length equals 0, return
			if(!_tileLayers || 0 == _tileLayers.length) 
			return;
			
			//if _map is null, return
			if (!_map) 
			return;
			var _item:TileLayerBase;
			//invoke TileLayerBase's loadTiles method
			for (var i:uint = 0; i < _tileLayers.length; i++)
			{
				_item = TileLayerBase(_tileLayers[i]);
				if (zoomChanged)  _item.zoomChangedAction(_map.zoom);//zoomchange的话就让每个TileLayerBase执行zoom变化，当然对于
				//除了imageLayer之外的层目前都没有实现这个过程，所以其实这些层只是预留接口。
				var delay:uint = zoomChanged ? MapConstants.ZOOM_CHANGED_EFFECT_TIME : 0;
				setTimeout(loadTilesssss, delay, _item);
			}
		}
		
		private function loadTilesssss(target:TileLayerBase):void//延时加载数据
		{
			target.loadTiles(_map.size.x, _map.size.y, _map.center.toScreenPoint(_map.zoom), _map.zoom);
		}
	}
}