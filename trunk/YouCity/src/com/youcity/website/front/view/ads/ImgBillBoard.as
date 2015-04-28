package com.youcity.website.front.view.ads
{
	import com.youcity.maps.MapEvent;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.website.front.view.ads.base.Billboard;
	import com.youcity.website.front.view.common.MapManager;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class ImgBillBoard extends Billboard
	{
		protected var _asset:String;
		public function get asset():String
		{
			return this._asset;
		}
		private var _map:MapManager = MapManager.getInstance();
		public function get mapManager():MapManager
		{
			return this._map;
		}
		
		private var _defaultZoom:uint = 0;
		public function get defaultZoom():uint
		{
			return this._defaultZoom;
		}
		
		public function ImgBillBoard(position:ScreenPoint, asset:String, defaultZoom:uint = 0)
		{
			super(position);
			_asset = asset;
			mouseChildren = false;
			buttonMode = true;
			_defaultZoom = defaultZoom;
			drawBillBoard();
		}
		
		protected function drawBillBoard():void
		{
			var loader:Loader = new Loader();
			var url:URLRequest = new URLRequest(_asset);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			loader.load(url);
			_map.addEventListener(MapEvent.ZOOM_CHANGED, onZoomChangeHandler);
		}
		
		protected var _ox:Number;
		protected var _oy:Number;
		private var _content:DisplayObject;
		public function get content():DisplayObject
		{
			return this._content;
		}
		public function set content(value:DisplayObject):void
		{
			this._content = value;	
		}
		
		private function onCompleteHandler(event:Event):void
		{
			var loader:LoaderInfo = LoaderInfo(event.target);
			var asset:DisplayObject = loader.content;
			_ox = asset.width;
			_oy = asset.height;
			addChild(asset);
			_content = asset;
			setDisplay();
		}
		
		private function onIOErrorHandler(event:IOErrorEvent):void
		{
			trace(event);
		}
		
		private function onZoomChangeHandler(event:Event):void
		{
			setDisplay();
		}
		
		protected function setDisplay():void
		{
			_content.scaleX = 1/Math.pow(2, _map.zoom - _defaultZoom);
			_content.scaleY = _content.scaleX;
			offsetX =_ox * _content.scaleX / 2;
			offsetY = _oy* _content.scaleY;
			setOverlayPosition(position);
		}
	}
}