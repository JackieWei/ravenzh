package com.youcity.maps.tiles.layers.tiles
{
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.util.DisplayUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	
	/**
	 * 
	 * @author Jackie Wei
	 * 解析XML并且把根据内容创建新的HotSpot
	 */	
	public final class HotSpotTile extends Tile 
	{
		/**
		 * record all spot
		 */		
		private var _hotSpotArray:Array;
		
		private var _urlLoader:URLLoader;
		
		public function HotSpotTile(url:String, position:ScreenPoint) 
		{
			super(url, position);
			_urlLoader = new URLLoader();
			_hotSpotArray = [];
		}
		
		/**
		 * @overriide 
		 */		
		override public function load():void {
			_request.url = _url;
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			_urlLoader.load(_request);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_urlLoader.addEventListener(Event.COMPLETE, spotLoadedHandler);
		}
		
		/**
		 * load spot handler
		 * @param event
		 */		
		private function spotLoadedHandler(event:Event):void {
			if (_urlLoader) {
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_urlLoader.removeEventListener(Event.COMPLETE, spotLoadedHandler);
			}
			try {
				parseXML(XML(_urlLoader.data));
				_urlLoader = null;
				_request = null;
			} catch (error:Error) {
				trace("Parse XML Error", error.message);
			} 
			
		}
		
		/**
		 * parse xml
		 * @param hotSpots
		 * 解析XML并创建HotSpot实例
		 */		
		private function parseXML(hotSpots:XML):void {
			var spotList:XMLList = XMLList(hotSpots.spot);
			var spotNum:uint = spotList.length();
			var id:String;
			var title:String;
			var centerX:String
			var centerY:String;
			var tempCoordsList:Array;
			var coords:String;
			var coordsList:Array;
			for (var i:uint = 0; i < spotNum; i++) {
				id = spotList[i].id;
				title = spotList[i].title;
				centerX = spotList[i].centerX;
				centerY = spotList[i].centerY;
				coords = spotList[i].coords;
				tempCoordsList = coords.split(",");
				coordsList = [];
				var length:int = tempCoordsList.length;
				for (var j:int = 0; j < length; j += 2) {
					var tempX:int = parseInt(tempCoordsList[j]);
					var tempY:int = parseInt(tempCoordsList[j + 1]);
					coordsList.push([tempX, tempY]);
				}
				var tSpot:HotSpot = new HotSpot(id, title, centerX, centerY, coordsList, position);
				addChild(tSpot);
				_hotSpotArray.push(tSpot);
			}
			spotList = null; 
		}
		
		//io error
		private function ioErrorHandler(event:IOErrorEvent):void {
			if (_urlLoader) {
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_urlLoader.removeEventListener(Event.COMPLETE, spotLoadedHandler);
				_urlLoader = null;
				_request = null;
			}
		}
		
		/**
		 * @override
		 * clear all
		 */		
		override public function clear():void {
			_urlLoader = null;
			DisplayUtil.removeAllChildren(this);
			var length:int = _hotSpotArray.length;
			for (var i:int = 0; i < length; i ++) {
				HotSpot(_hotSpotArray[i]).destruct();
			}
			_hotSpotArray = null;
		}
		
	}
}
