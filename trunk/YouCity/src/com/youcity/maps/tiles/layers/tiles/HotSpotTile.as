package com.youcity.maps.tiles.layers.tiles
{
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.util.MapUtil;
	
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
			super(this, url, position);
			_urlLoader = new URLLoader();
			_hotSpotArray = new Array();
		}
		
		public override function load():void
		{
			_request.url = _resourceUrl;
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			_urlLoader.load(_request);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_urlLoader.addEventListener(Event.COMPLETE, spotLoadedHandler);
		}
		
		/**
		 * load spot handler
		 * @param event
		 * 
		 */		
		private function spotLoadedHandler(event:Event):void
		{
			if (_urlLoader)
			{
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_urlLoader.removeEventListener(Event.COMPLETE, spotLoadedHandler);
			}
			try 
			{
				parseXML(XML(_urlLoader.data));
				_urlLoader = null;
				_request = null;
			}
			catch (error:Error)
			{
				
			} 
			
		}
		
		/**
		 * parse xml
		 * @param hotSpots
		 * 解析XML并创建HotSpot实例
		 */		
		private function parseXML(hotSpots:XML):void
		{
			var spotList:XMLList = XMLList(hotSpots.spot);
			var spotNum:uint = spotList.length();
			var id:String;
			var title:String;
			var centerX:String
			var centerY:String;
			var coordsList:Array;
			var coordsXML:XMLList;
			for (var i:uint = 0; i < spotNum; i++)
			{
				coordsList = [];
				id = spotList[i].id;
				title = spotList[i].title;
				centerX = spotList[i].centerX;
				centerY = spotList[i].centerY;
				coordsXML = XMLList(spotList[i].coordsList);
				for (var j:uint = 0; j < coordsXML.coords.length(); j++)
				{
					coordsList.push(String(coordsXML.coords[j]));
					
				}
				var tSpot:HotSpot = new HotSpot(id, title, centerX, centerY, coordsList, position);
				addChild(tSpot);
				_hotSpotArray.push(tSpot);
				
			}
			spotList = null; 
		}
		
		/**
		 * @private
		 * @param event
		 * 
		 */		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			if (_urlLoader)
			{
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_urlLoader.removeEventListener(Event.COMPLETE, spotLoadedHandler);
				_urlLoader = null;
				_request = null;
			}
		}
		
		/**
		 * clear all
		 * 
		 */		
		public override function clear():void
		{
			super.clear();
			_urlLoader = null;
			MapUtil.removeAllChildren(this);
			for (var i:uint; i < _hotSpotArray.length; i++)
			{
				HotSpot(_hotSpotArray[i]).destruct();
			}
			_hotSpotArray = null;
		}
	}
}
