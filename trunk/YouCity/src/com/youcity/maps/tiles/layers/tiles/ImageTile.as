package com.youcity.maps.tiles.layers.tiles
{

	import com.youcity.maps.MapPoint;
	import com.youcity.maps.ScreenPoint;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * Each Image Block
	 * @author Jackie Wei
	 * 
	 */	
	 
	/**
	* Dispatched when ImageTile has already loaded the pic from the specified URL
	*/	 
	[Event(name="image_loaded", type="flash.events.Event")] 
	public class ImageTile extends Tile 
	{
		/**
		 * loader to load images
		 */		
		private var _loader:Loader;
		
		private var _contents:Bitmap;
		
		/**
		 * @constructor
		 * @param url : folder url
		 * @param position: leftop position
		 */
		public function ImageTile(url:String,position:ScreenPoint)
		{
			super(this, url, position);
			_loader = new Loader();
			_contents = new Bitmap();
			addChild(_contents);
		}
		
		/**
		 * @param event
		 * while completed remove listener and mark loaded as loaded
		 * remove loader
		 */		
		private function completedHandler(event:Event):void
		{
			//_loaded = true;
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completedHandler);
			_contents.bitmapData = Bitmap(_loader.content).bitmapData;
			dispatchEvent(new Event("image_loaded"));
			_loaded = true;
			//_loader = null;
		}
		
		/**
		 * 
		 * @return contents
		 * begin to load, return DisplayObject
		 */		
		public override function load():void
		{
			super.load();
			_request.url = _resourceUrl;
			_loader.load(_request, new LoaderContext(true, null, null));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completedHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
		}
		
		private function onIOErrorHandler(event:IOErrorEvent):void
		{
			
		}
		
		/**
		 * clear all
		 * 
		 */		
		public override function clear():void
		{
			super.clear();
			if (_loader)
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completedHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
				_loader.unload();
			}
		} 
	}
}