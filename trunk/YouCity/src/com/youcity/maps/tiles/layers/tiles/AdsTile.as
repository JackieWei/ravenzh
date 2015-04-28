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
	 * AdsTile每个代表一个XML里面存储的数据。根据里面数据的多少创建多个Ad实例
	 */	
	public final class AdsTile extends Tile 
	{
		/**
		 * record all spot
		 */		
		private var _urlLoader:URLLoader;
		
		public function AdsTile(url:String, position:ScreenPoint) 
		{
			super(this, url, position);
			_urlLoader = new URLLoader();
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
		 * 加载数据
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
		 * 加载完成之后，取得相关数据，并且遍历里面的ADs，构建Ad的实例
		 */		
		private function parseXML(ads:XML):void
		{
			var adList:XMLList = XMLList(ads);
			var adsNum:uint = adList.length();
			var id:String;
			var title:String;
			var centerX:String
			var centerY:String;
			var ad:Ad;
			var asset:String; 
			var zoom:int;
			var type:String;
			var website:String;
			for (var i:uint = 0; i < adsNum; i++)
			{
				id = adList[i].id;
				title = adList[i].title;
				centerX = adList[i].centerX;
				centerY = adList[i].centerY;
				asset = adList[i].asset.toString();
				zoom = int(adList[i].zoom.toString());
				website = adList[i].website.toString();
				type = adList[i].asset.@type;
				ad = new Ad(id, title, centerX, centerY, asset, type, zoom, website, position);
				addChild(ad);
			}
			adList = null; 
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
		}
	}
}
