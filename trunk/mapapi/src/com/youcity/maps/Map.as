package com.youcity.maps
{
	import com.youcity.maps.controls.ControlContainer;
	import com.youcity.maps.overlays.GraphicDrawer;
	import com.youcity.maps.overlays.InfoWindow;
	import com.youcity.maps.overlays.OverlayBase;
	import com.youcity.maps.tiles.layers.TileLayerBase;
	import com.youcity.maps.util.DisplayUtil;
	import com.youcity.maps.util.MapUtil;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	[Event(name = "map_ready",				type = "com.youcity.maps.MapEvent")]
	[Event(name = "map_progress", 		type = "com.youcity.maps.MapEvent")]
	[Event(name = "map_loaded", 			type = "com.youcity.maps.MapEvent")]
	[Event(name = "map_move", 				type = "com.youcity.maps.MapEvent")]
	[Event(name = "drag_begin", 			type = "com.youcity.maps.MapEvent")]
	[Event(name = "dragging", 				type = "com.youcity.maps.MapEvent")]
	[Event(name = "drag_end", 				type = "com.youcity.maps.MapEvent")]
	[Event(name = "direction_changed", 	type = "com.youcity.maps.MapEvent")]
	[Event(name = "size_changed",			type = "com.youcity.maps.MapEvent")]
	[Event(name = "maptype_changed",		type = "com.youcity.maps.MapEvent")]
	[Event(name = "maptype_added", 		type = "com.youcity.maps.MapEvent")]
	[Event(name = "maptype_removed",		type = "com.youcity.maps.MapEvent")]
	[Event(name = "zoom_changed",			type = "com.youcity.maps.MapEvent")]
	[Event(name = "control_added",		type = "com.youcity.maps.MapEvent")]
	[Event(name = "control_removed",		type = "com.youcity.maps.MapEvent")]
	[Event(name = "overlay_changed",		type = "com.youcity.maps.MapEvent")]
	[Event(name = "overlay_added",		type = "com.youcity.maps.MapEvent")]
	[Event(name = "overlay_removed",		type = "com.youcity.maps.MapEvent")]
	[Event(name = "infowindow_closed",	type = "com.youcity.maps.MapEvent")]
	[Event(name = "infowindow_closing",	type = "com.youcity.maps.MapEvent")]
	[Event(name = "infowindow_opened",	type = "com.youcity.maps.MapEvent")]
	/**
	 * Main class for Map API
	 * @author Jackie Wei
	 * Map类是map的主要显示载体，同时对外提供一些公开的方法和属性用来操作地图。
	 * 至于加载地图等操作其实主要是在各个层自己做的，map只负责调用接口
	 */	
	public class Map extends Sprite 
	{
		public static var TILE_DEFAULT_BG:Class = AssetsEmbed.MAP_TILE_DEFAULT_BG;
		
		private var _mapWidth:int;
		private var _mapHeight:int;
		public function get mapWidth():int { return _mapWidth; }
		public function get mapHeight():int { return _mapHeight; }
		
		/**
		 * Flag to show  if wheel enabled
		 */		
		private var _wheelEnabled:Boolean;//标志当前的地图是否允许滚轮，内部标识，通过函数enableWheel()和disableWheel()来控制。对外只读
		public function get wheelEnabled():Boolean { return _wheelEnabled; };
		
		/**
		 * Flag to show if in drag model
		 */		
		private var _dragEnabled:Boolean;//标志当前是否可以拖动地图，通过函数enableDrag() disabledDrag() 来设置，对外只读
		public function dragEnabled():Boolean { return _dragEnabled; }
		
		/**
		 * The inside layer, base layer for map, manage several layers,
		 * All layers move with map will be included in this layer
		 * etc. mapbaselayer, overlayerLayer...
		 */
		private var _insideLayer:Sprite;//这个层包含基本上所有地图相关层，基本上所有东西的root，上面只会有别的层
		//不会有具体的图片或者overlay，图片会有图片层，overlay会有overlay层，但是都依附于这个层，总体的位置也由这个层决定。
		//这个层的起始位置是当前Map左上角点相对于城市的位置的负数，比如当前左上角点在2000，20000处的话，_insideLayer，位置就是
		//-2000,-2000.注意不是中心点，而是相对于Map容器的左上角点。
		
		/**
		 * Base map layer, for img layer, spot layer and so on
		 */		
		private var _mapbaseLayer:Sprite;//多层的map都依附于这上面，包括地图，热区等，基本上在maptype的array里的都会在这上面
		
		private var _overlayLayer:Sprite;//管理overlay的层。
		private var _controlLayer:Sprite;//管理控制组建的层

		private var _controls:Array;//控制数组
		private var _overlays:Array;//overlay数组
		private var _infoWindows:Array;//infowin数组
		
		/**
		 * store all maptypes for map
		 * Readonly property. To add a maptype
		 * please use addMapType function
		 */		
		
		private var _mapTypes:Array;//记录maptypes的数组
		public function get mapTypes():Array { return _mapTypes; }
		
		/**
		 * current map type, read only property
		 * to set current using MapType please
		 * use setMapType function
		 */		
		private var _currentMapType:MapType;//当前的MapType
		public function get currentMapType():IMapType { return _currentMapType; }
		
		/**
		 * Read only zoomArray, store zoom levels
		 * Changed when MapType changed.
		 */		
		private var _zoomArray:Array;
		public function get zoomArray():Array {//地图zoom级别数组，取当前的maotype下的zoom级别
			return _zoomArray;
		}
		
		public function enableDrag():void {//开启拖动功能
//			_dragEnabled = true;
			addEventListener(MouseEvent.MOUSE_DOWN, insideLayerMouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, insideLayerMouseUpHandler);
		}
		
		public function disabledDrag():void {//关闭拖动功能
//			_dragEnabled = false;
			removeEventListener(MouseEvent.MOUSE_DOWN, insideLayerMouseDownHandler);
//			removeEventListener(MouseEvent.MOUSE_MOVE, insideLayerMouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_UP, insideLayerMouseUpHandler);
		}
		
		/**
		 * Read only property center.
		 * Use setCenter function to set it
		 */		
		private var _center:MapPoint;//中心点
		public function get center():MapPoint { return this._center; }
		/**
		 * @param value: Type, MapPoint, for center
		 * @param zoom : Type:int, default -1, for current zoom level
		 * @param mapType : Type:MapType, default null, for current map type
		 * 
		 */		
		public function setCenter(value:MapPoint, zoom:int = -1, mapType:MapType = null):void {//设置中心点，改变中心点，
		//采用类似google map的做法。统一派发MAP_MOVE事件，zoom有变化则同时派发ZOOM_CHANGED，maptype变化则
		//派发MAPTYPE_CHANGED事件
			//if center not changed, no action 
			if(center && value.equals(center))
			return;
			_center = value;
			//evaluate new value to current center of map
			
			//if define maptype param and not euqal to current, set new maptype
			if (mapType && mapType != _currentMapType) {
				_currentMapType = mapType;
				_zoomArray = mapType.zoomArray;
				dispatchEvent(new MapEvent(MapEvent.MAPTYPE_CHANGED));
			}
			
			//if define zoom param and not euqal to current, set new zoom
			if (-1 != _zoomArray.indexOf(zoom) && _zoom != zoom) {
				_zoom = zoom;
				dispatchEvent(new MapEvent(MapEvent.ZOOM_CHANGED));
				
				//when zoom changed need to relocate all overlays
				relocateOverlays();
				zoomChangedHanlder();
			} else {
				reloadTileLayer();
			}
			dispatchEvent(new MapEvent(MapEvent.MAP_MOVE));
		}
		
		/**
		 * Read only property zoom 
		 * If need to change zoom use setZoom function
		 */		
		private var _zoom:uint;
		public function get zoom():uint //当前的zoom级别
		{
			return _zoom;
		}
		
		/** 
		 * @param value : uint, new zoom value
		 * set zoom level and set map, reload all layers, relocate all
		 * overlays and dispatch zoom change event
		 */		
		public function setZoom(value:uint):void//设置当前的zoom，并且派发ZOOM_CHANGED事件
		{
			if (_zoom != value && -1 != _zoomArray.indexOf(value))
			{
				_zoom = value;
				zoomChangedHanlder();
				dispatchEvent(new MapEvent(MapEvent.ZOOM_CHANGED));
				relocateOverlays();
			}
		}
		
		/**
		 * Resize map according to container's size
		 * should use while conatiner's size changed
		 */		
		public function setSize(newWidth:int, newHeight:int):void {
			_mapWidth = newWidth;
			_mapHeight = newHeight;
			reloadTileLayer(true); 
			setMask(_mapWidth, _mapHeight);
			drawBackground();
			dispatchEvent(new MapEvent(MapEvent.MAP_SIZE_CHANGED));
		}
		
		/**
		 * Drag start mouse position
		 */		
		private var _dragStartPosition:Point;//拖动开始的点
		
		/**
		 * Flag to show if now in dragging model
		 */		
		private var _isDragging:Boolean = false;//标记当前是否处于拖动状态
		
		/**
		 * Set mask for map, to clip the needed part of map
		 * Size is the container's size
		 */
		private var _mask:Sprite;//地图的遮罩，让map容器之外的图层不显示出来
		
		/**
		 * @Constructor. 
		 * Init All need vars
		 * Listen to event when added to stage act
		 */		
		public function Map():void //初始化大部分变量
		{
			_dragEnabled = false;
			_dragStartPosition = new Point();
			
			_mapTypes = [];
			
			_infoWindows = [];
			
			_insideLayer  = new Sprite();
			_mapbaseLayer = new Sprite();
			_overlayLayer = new Sprite();
			_controlLayer = new Sprite();
			
			_wheelEnabled = true;
			
			//listen to event added to stage to decide whether to dispatch
			//map ready event
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		/** 
		 * @param width：Conainer's width
		 * @param height:Container's height
		 * set mask for map, set after container is init
		 * changed mask size when container's size changed
		 */		
		private function setMask(w:Number, h:Number):void {//设置容器的MASK
			if (!_mask) {
				_mask = new Sprite();
				addChild(_mask);
			}
			_mask.graphics.clear();
			_mask.alpha = 1;
			_mask.graphics.lineStyle(0, 0xFF0000);
			_mask.graphics.beginFill(0x000000);
			_mask.x = 0;
			_mask.y = 0;
			_mask.graphics.drawRect(0, 0, w, h);
			_mask.graphics.endFill();
			mask = _mask;
		}
		
		/**
		 * while center changed or container size changed, reset inside layer's position
		 */		
		private function insideLayerPositionInit():void {//根据当前的center和容器大小确定insiderlayer的位置，
		//核心代码，不过由于添加zoom变化效果，这部分只在地图全部变化的时候调用
			var newX:Number = -(_center.toScreenPoint(zoom).x - _mapWidth/2);
			var newY:Number = -(_center.toScreenPoint(zoom).y - _mapHeight/2);
			_insideLayer.x = newX;
			_insideLayer.y = newY;
		}
		
		/**
		 * reload tiles, including reset inside layer's position
		 * and load tiles
		 * @param clear:whether to clear all on layers
		 * 
		 */		
		private function reloadTileLayer(clear:Boolean = false):void {//重新加载地图数据
			insideLayerPositionInit();
			_currentMapType.loadTiles(clear);
		}
		
		private function zoomChangedHanlder():void//zoomchang时候重新计算位置，并且加上动画效果，强烈提示：此处的动画效果与
		//具体图片层的缩放效果合起来才是zoom变化的效果，具体的代码在maptype的loadTiles函数，并且用了一个类来封装这个操作
		{
			var newX:Number = -(_center.toScreenPoint(zoom).x - _mapWidth / 2);
			var newY:Number = -(_center.toScreenPoint(zoom).y - _mapHeight / 2);
			_insideLayer.x = newX;
			_insideLayer.y = newY;
			_currentMapType.loadTiles(true);
		}
		
		/**
		 * @param event:default null.
		 * init all layers, vars, add drag event
		 * add wheel event, set all display layers,
		 * dispatch mapready event while currentMapType is setted
		 */		
		private function onAddedToStageHandler(event:Event = null):void//在map被添加进显示列表之后，添加各个层级，初始化，初始化完毕派发MAP_READY事件
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			drawBackground();
			setMask(_mapWidth, _mapHeight);
			_controls = [];
			_overlays = [];
			addEventListener(MouseEvent.MOUSE_WHEEL, mapWheelHandler);
			addChild(_insideLayer);
			_insideLayer.addChild(_mapbaseLayer);//base map layer
			_insideLayer.addChild(_overlayLayer);//overlay layer
			addChild(_controlLayer);//control layer
			enableDrag();
			if (_currentMapType)
			dispatchEvent(new MapEvent(MapEvent.MAP_READY));
		}
		
		/**
		 * @param event:MouseEvent
		 * if wheel forward, zoom in
		 * else zoom out.
		 * And the point you point to will stay at the default position
		 */	
		private var _allowWheel:Boolean = true;//标识是否允许wheel，
		//这个解释一下，主要是因为在windows系统下，
		//你打开控制面板--鼠标--滚轮（轮），就会看到设置，鼠标滚轮没滚一下可能代表好几下的滚动
		//而flash只能检测到window模拟派发后的鼠标滚轮事件（基本上我不知道有什么语言可以跳过这个）
		//所以采用了一个停顿机制，上一次鼠标滚轮事件开始之后500毫秒之内不响应新的鼠标滚轮事件，
		//从效果上看，500是最合适的数字
		private function mapWheelHandler(event:MouseEvent):void {
			if (!_allowWheel)
			return;
			
			_allowWheel = false;
			setTimeout(allowWheelHandler, 500); 
			event.stopPropagation();
			if (!_center) 
			return;
			
			var newzoom:int = event.delta < 0 ? (_zoom - 1) :  (_zoom + 1);//changed zoom level
			if (-1 == _zoomArray.indexOf(newzoom)) 
			return;
			
			var mousePoint:ScreenPoint = mouseToScreen(new Point(mouseX, mouseY));
			var screenCenter:ScreenPoint = _center.toScreenPoint(_zoom);
			var disX:Number = mousePoint.x - screenCenter.x;
			var disY:Number = mousePoint.y - screenCenter.y;
			
			var tPoint:ScreenPoint = mousePoint.toZoom(newzoom);
			setCenter((new ScreenPoint(newzoom,  tPoint.x  - disX,  tPoint.y - disY)).toMapPoint(), newzoom, null);
		}
		
		private function allowWheelHandler():void//定时器设置，过500毫秒允许响应
		{
			_allowWheel = true;
		}
		
		private function drawBackground():void {//画背景，就是那个Youcity logo的图
			var graphic:Graphics = graphics;
			var bg:* = new TILE_DEFAULT_BG();
			graphic.clear();
			graphic.beginBitmapFill(bg.bitmapData, null,true, true);
			graphic.drawRect(0, 0, _mapWidth, _mapHeight);
			graphic.endFill(); 
		}
		
		private function insideLayerMouseOutHandler(event:MouseEvent):void {//鼠标出界和释放是一个效果
			insideLayerMouseUpHandler(event);
		}
		
		/**
		 * @param event
		 * for drag, handle while mouse down
		 */		
		private function insideLayerMouseDownHandler(event:MouseEvent = null):void {//当鼠标按下时候开始拖拽，并且派发MAP_DRAG_BEGIN事件
			_dragStartPosition.x =  mouseX;
			_dragStartPosition.y =  mouseY;
			_dragEnabled = true;
			dispatchEvent(new MapEvent(MapEvent.MAP_DRAG_BEGIN));
			_insideLayer.startDrag();
		}
		
		/**
		 * @param event
		 * for drag, hanle while mouse up, stop drag
		 */		
		private function insideLayerMouseUpHandler(event:MouseEvent = null):void {
		//当鼠标释放，停止拖拽，派发MAP_DRAG_END事件
			if (!_dragEnabled) 
			return;
			_dragEnabled = false;
			_insideLayer.stopDrag();
			dragMoveMap();
			dispatchEvent(new MapEvent(MapEvent.MAP_DRAG_END));
		}
		
		/**
		 * record map offset and reset center
		 */		
		private function dragMoveMap():void {	//拖动之后设置新的中心点，load图片和热区等
			var offsetX:Number = mouseX - _dragStartPosition.x;
			var offsetY:Number = mouseY - _dragStartPosition.y;
			var screenCenter:ScreenPoint = center.toScreenPoint(zoom);
			screenCenter.offset(-offsetX, -offsetY); 
			setCenter(screenCenter.toMapPoint());
		}
		
		/**
		 * @param mapType
		 * add new map type to maptypes for map
		 */		
		public function addMapType(mapType:MapType):void//添加地图类型
		{
			mapType.map = this;
			_mapTypes.push(mapType);
		}
		
		/**
		 * @param mapType
		 * set map type, add if not in maptypes
		 * reset all in mapbaselayer
		 */		
		public function setMapType(mapType:MapType):void
		//设置当前的地图类型，如果在数组中，就设置，如果不在，先add再设置
		//把当前maptype的层一个个添加进maplayer上
		{
			//if not in, add it
			if (-1 == _mapTypes.indexOf(mapType))
			{
				addMapType(mapType);
			}
			if (_currentMapType != mapType)//这个判断里面的意思是
			//从选定的MapType里面抽取layers，然后把它放到mapBase上。目前只能有一个层作为loading层
			{
				//remove all layers in mapbase
				DisplayUtil.removeAllChildren(_mapbaseLayer);//删除所有的mapbaselayer的内容
				_currentMapType = mapType;
				_zoomArray = mapType.zoomArray;
				var layersArr:Array = _currentMapType.layers;
				for (var j:uint = 0; j < layersArr.length; j++) {
					var layer:TileLayerBase = layersArr[j];
					layer.layerLoaded = layerLoadedHandler;
					_mapbaseLayer.addChild(layer);
				}
				//if center not null, reset map, else do nothing
				if (null != _center) {
					_currentMapType.loadTiles(true);
					insideLayerPositionInit();
				}
				dispatchEvent(new MapEvent(MapEvent.MAPTYPE_CHANGED));
			}
		}
		
		//地图图片层加载完成派发事件
		private function layerLoadedHandler(layerName:String):void {
			dispatchEvent(new MapEvent(MapEvent.MAP_LOADED));
		}
		
		/**
		 * map zoom in
		 */		
		public function zoomIn():void { setZoom(_zoom - 1); }
		
		/**
		 * map zoom out
		 */		
		public function zoomOut():void { setZoom(_zoom + 1); }
		
		/**
		 * 
		 * @param overlay
		 * add overlay to map. Store overlay
		 * dispatch event
		 */		
		public function addOverlay(overlay:OverlayBase):void {//添加overlay
			_overlays.push(overlay);
			_overlayLayer.addChild(overlay);
			dispatchEvent(new MapEvent(MapEvent.OVERLAY_ADDED));
		}
		
		/**
		 * 
		 * @param overlay
		 * remove overlay from map and remove from store
		 */		
		public function removeOverlay(overlay:OverlayBase):void//remove overlay，在本程序中大多数情况采用的是
		//制度不那么苛刻，对于用户remove 一个不存在或者已经remove的overlay这样的操作，以及在程序中类似的操作，
		//均不报错。一般都是采用温和的机制。
		{
			if (_overlays.indexOf(overlay) < 0)
			{
				return;
			}
			_overlays.splice(_overlays.indexOf(overlay, 0), 1);
			_overlayLayer.removeChild(overlay);
			dispatchEvent(new MapEvent(MapEvent.OVERLAY_REMOVED));
		}
		
		/**
		 * Relocate overlays while needed(most time 
		 * used while zoom changed)
		 */		
		private function relocateOverlays():void//私有函数，目的是为了在zoom变化时候迁移所有overlay
		{
			if (_overlayLayer && _overlays && _overlays.length > 0)
			{
				for (var i:uint = 0; i < _overlays.length; i++)
				{
					var t:OverlayBase = _overlays[i];
					t.relocate(_zoom);
					if (t is GraphicDrawer) GraphicDrawer(t).reDraw(_zoom);//如果该实例是画图工具的产物，需要重绘
				}
			}
			for (var j:uint = 0; j < _infoWindows.length; j++)//同理对于infowin
			{
				var o:InfoWindow = InfoWindow(_infoWindows[j]);
				o.relocate(_zoom);
			}
		}
		
		public function drawRect(start:OverlayBase, toPoint:ScreenPoint):void//提供在地图上画矩形的接口
		{
			if (!start) return;
			var x:Number = toPoint.x - start.position.x;
			var y:Number = toPoint.y - start.position.y;
			start.graphics.beginFill(0xFFAADD, 1);
			start.graphics.drawRect(0, 0, x, y);
			start.graphics.endFill();
		}
		
		public function removeRect(start:OverlayBase):void//remove画出的矩形
		{
			if (!start) return;
			start.graphics.clear();
			removeOverlay(start);
			start = null;
		}
		
		/**
		 * 
		 * @param control
		 * add control to map.
		 */		
		public function addControl(control:ControlContainer):void//添加控制
		{
			_controls.push(control);
			addChild(control);
			dispatchEvent(new MapEvent(MapEvent.CONTROL_ADDED));
		}
		
		/**
		 * 
		 * @param control
		 * remove control
		 */		
		public function removeControl(control:ControlContainer):void //去除控制
		{
			_controls.splice(_controls.indexOf(control), 1);
			removeChild(control);
			dispatchEvent(new MapEvent(MapEvent.CONTROL_REMOVED));
		}
		
		/**
		 * @param offsetX
		 * @param offsetY
		 * move map by offset, reset center
		 */		
		public function moveMapByCoordinate(offsetX:int, offsetY:int):void //通过偏移量移动地图
		{
			var ox:uint = offsetX > 0 ? offsetX : -offsetX;
			var oy:uint = offsetY > 0 ? offsetY : -offsetY;
			var newCenter:ScreenPoint = new ScreenPoint(_zoom, center.toScreenPoint(zoom).x + offsetX, center.toScreenPoint(zoom).y + offsetY);
			slideToNewCenter(newCenter);
		}
		
		public function slideCenter(center:MapPoint, zoom:int = -1):void
		//这个函数和下面的slideToNewCenter，onSlideCompleteHandler一起完成让地图移动的
		{
			slideToNewCenter(center.toScreenPoint(_zoom), zoom);
		}
		
		private function slideToNewCenter(newCenter:ScreenPoint, zoom:int = -1):void
		{
			setCenter(newCenter.toMapPoint());
		}
		
		private function onSlideCompleteHandler(newCenter:ScreenPoint, zoom:int):void//当slide结束的时候
		{
			var newZoom:int;
			if (zoom < 0 || zoom > 4) newZoom = _zoom;
			else newZoom = zoom;
			setCenter(newCenter.toMapPoint(), newZoom);
		}
		
		/**
		 * 
		 * @param point
		 * set center use screen point. 
		 */		
		public function setCenterForScreenPoint(point:ScreenPoint):void 
		{
			setCenter(point.toMapPoint());
		}
		
		/**
		 * 
		 * @param point
		 * set center use MapPoint, that is set center 
		 */		
		public function setCenterForMapPoint(point:MapPoint):void 
		{
			setCenter(point);
		}
		
		/**
		 * 
		 * @param point
		 * set center using latlng location
		 */		
		public function setCenterForLatLngPoint(point:LatLngPoint):void 
		{
			setCenter(point.toMapPoint());
		}
		
		/**
		 * enable wheel
		 */		
		public function enableWheel():void { //启用wheel
			if (_wheelEnabled)
			return;
			_wheelEnabled = true;
			addEventListener(MouseEvent.MOUSE_WHEEL, mapWheelHandler);
		}
		
		/**
		 * disable wheel
		 * not listen to wheel event
		 */		
		public function disableWheel():void { //禁止wheel
			if (!_wheelEnabled)
			return;
			_wheelEnabled = false;
			removeEventListener(MouseEvent.MOUSE_WHEEL, mapWheelHandler);
		}
		
		/**
		 * 
		 * @param mousePoint
		 * @return 
		 * translate mouse point in map to screen point according to current level
		 */		
		public function mouseToScreen(mousePoint:Point):ScreenPoint {
			return new ScreenPoint(zoom, mousePoint.x - _insideLayer.x, mousePoint.y - _insideLayer.y);
		}
		
		/**
		 * 
		 * @param fromPoint
		 * @param toPoint
		 * @return 
		 * measure distance for two points
		 */		
		public function point_measure(fromPoint:ScreenPoint, toPoint:ScreenPoint):Number//计算两点之间的距离
		{
			var fromLngLat:LatLngPoint = fromPoint.toMapPoint().toLatLng();
			var toLngLat:LatLngPoint = toPoint.toMapPoint().toLatLng();
			return MapUtil.measure(fromLngLat, toLngLat);
		}
		
		public function openInfoWindow(infowin:InfoWindow):void//打开infowin
		{
			if (_infoWindows.indexOf(infowin) >= 0) return;
			_infoWindows.push(infowin);
			_overlayLayer.addChild(infowin);
			dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_OPENDED));
		}
		
		public function closeInfoWindow(infowin:InfoWindow):void//关闭infowin
		{
			var index:int = _infoWindows.indexOf(infowin);
			if (index < 0)
			{
				throw new Error("Not an exsit infowindow!");
				return;
			}
			
			_infoWindows.splice(index, 1);
			_overlayLayer.removeChild(infowin);
			dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_CLOSED));
		}
		
		public function get bound():MapBound {//得到map当前的范围等信息，本来的意思是把所有点和范围的比较这些东西都做到这个类里面
			//这样可以避免耦合
			return new MapBound(this);
		}
		
		public function positionToMapPoint(position:Point):MapPoint//把地图上的鼠标位置转换为mappoint
		{
			return (positionToScreenPoint(position)).toMapPoint();
		}
		
		public function positionToScreenPoint(position:Point):ScreenPoint {//把地图上的鼠标位置转换为ScreenPoint
			var point:ScreenPoint = _center.toScreenPoint(_zoom);
			var newX:Number = point.x - _mapWidth / 2 + position.x;
			var newY:Number = point.x - _mapHeight / 2 + position.y;
			return new ScreenPoint(_zoom, newX, newY);
		}
		
		public function mapPointToPoint(mapPoint:MapPoint):Point {//把mappoint转换为鼠标位置
			return screenPointToPoint(mapPoint.toScreenPoint(_zoom));
		}
		
		public function screenPointToPoint(screenPoint:ScreenPoint):Point {//把screenpoint转换为point
			var x:Number = screenPoint.x - bound.ltPoint.x;
			var y:Number = screenPoint.y - bound.ltPoint.y;
			return new Point(x,y);
		}
		
	}
}