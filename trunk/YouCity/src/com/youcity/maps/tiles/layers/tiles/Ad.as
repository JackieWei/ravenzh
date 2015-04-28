package com.youcity.maps.tiles.layers.tiles
{
	import com.youcity.maps.MapConstants;
	import com.youcity.maps.MapPoint;
	import com.youcity.maps.ScreenPoint;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	internal class Ad extends Sprite
	{
		private var _originalZoom:int;
		private var _originalWidth:Number = 0;
		private var _originalHeight:Number = 0;
		
		private var _currentZoom:int;
		
		private var adId:String
		private var title:String;
		private var position:MapPoint;
		private var source:String;
		private var type:String;
		
		private var _ltPoint:ScreenPoint;
		
		private var _id:String;
		public function get id():String
		{
			return _id;
		}
		
		private var _loader:Loader;
		
		private var _website:String;
		
		private var _offsetX:int;
		private var _offsetY:int;
		
		public function Ad(id:String, title:String, centerX:String, centerY:String, asset:String, type:String, zoom:int,  website:String, ltPoint:ScreenPoint)
		{//根据数据定义所需的各个数值，并且
			_currentZoom = ltPoint.zoom;
			_originalZoom = zoom
			adId = id;
			position = new MapPoint(Number(centerX),Number(centerY));
			_ltPoint = ltPoint;
			_id = "AD_container_" + id + "_" + name + "_end";
			source = MapConstants.AD_PREFIX + asset;
			this.type = type;
			
			_website = website;
            if (_website && _website != "" && _website.indexOf("http://") == 0) addEventListener(MouseEvent.CLICK, onClickHandler);
			
			AdAssets.instance.getAsset(source,onGetAssetCallbackHandler);
			return;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadedHandler)
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler)
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadErrorHandler)
			_loader.load(new URLRequest(source));
		}
		
		private function onGetAssetCallbackHandler(content:DisplayObject):void
		{
			var sc:ScreenPoint = position.toScreenPoint(_ltPoint.zoom);
            content.x = sc.x - _ltPoint.x;
            content.y = sc.y - _ltPoint.y;
            content.scaleX = 1 / Math.pow(2,_currentZoom-_originalZoom);
            content.scaleY = 1 / Math.pow(2,_currentZoom-_originalZoom);
            addChild(content);
		}
		
		private function onClickHandler(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(_website), "_blank");
		}
		
		private function onLoadedHandler(event:Event):void
		{
			var sc:ScreenPoint = position.toScreenPoint(_ltPoint.zoom);
			_loader.content.x = sc.x - _ltPoint.x;
			_loader.content.y = sc.y - _ltPoint.y;
			_loader.content.scaleX = 1 / Math.pow(2,_currentZoom-_originalZoom);
			_loader.content.scaleY = 1 / Math.pow(2,_currentZoom-_originalZoom);
			addChild(_loader.content);
		}
		
		private function onLoadErrorHandler(event:IOErrorEvent):void
		{
			trace(event.toString());
		}
	}
}