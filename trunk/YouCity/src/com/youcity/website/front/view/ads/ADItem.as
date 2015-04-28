package com.youcity.website.front.view.ads
{
	import com.youcity.maps.MapEvent;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.overlays.OverlayBase;
	import com.youcity.website.front.view.common.MapManager;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	
	public final class ADItem extends OverlayBase
	{
		private var _loader:Loader;
		
		private var _content:DisplayObject;
		
		private var _contentType:String;
		public function get contentType():String
		{
			return _contentType;
		}
		
		private var _map:MapManager = MapManager.getInstance();
		
		public function ADItem(position:ScreenPoint, asset:String)
		{
			super(this, position);
//			trace("assets is : " + asset + "    position is " + position.toMapPoint().toHashKey() + "   defaultZoom is " + position.zoom.toString());
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			_loader.load(new URLRequest(asset));
			_map.addEventListener(MapEvent.ZOOM_CHANGED, onZoomChangeHandler);
		}
		
		private var _contentClip:Shape;
		private var __ow:Number;
		private var __oh:Number;
		private function onCompleteHandler(event:Event):void
		{
			_content = _loader.content;
			_contentType = _content is Bitmap ? "img" : "swf";
			addChild(_content);
			_contentClip = new Shape();
			addChild(_contentClip);
			mask = _contentClip;
			__ow = _loader.contentLoaderInfo.width;
			__oh = _loader.contentLoaderInfo.height;
			onZoomChangeHandler();
			graphics.endFill(); 
		}
		
		private function onZoomChangeHandler(event:Event = null):void
		{
			_content.scaleX = 1 / Math.pow(2, _map.zoom);
			_content.scaleY = 1 / Math.pow(2, _map.zoom);
			_contentClip.graphics.clear();
			_contentClip.graphics.beginFill(0x000000, 0);
			_contentClip.graphics.drawRect(-3, 0, (__ow + 100) / Math.pow(2, _map.zoom), (__oh + 10) / Math.pow(2, _map.zoom));
			_contentClip.graphics.endFill(); 
		}
		
	}
}