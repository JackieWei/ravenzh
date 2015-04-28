package com.youcity.maps.tiles.layers.tiles
{

	import com.youcity.maps.ScreenPoint;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * Each Image Block
	 * @author Jackie Wei
	 * 
	 */	
	public class ImageTile extends Tile 
	{
		private var _loader:Loader;
		private var _content:Bitmap;
		private var _loadedHandler:Function;
		public function set loadedHandler(value:Function):void { _loadedHandler = value; }
		
		/**
		 * @constructor
		 * @param url : folder url
		 * @param position: leftop position
		 */
		public function ImageTile(url:String = "", position:ScreenPoint = null) {
			super(url, position);
			_gc = false;
			_loaded = false;
			_loader = new Loader();
			_content = new Bitmap();
			addChild(_content);
		}
		
		/**
		 * @param event
		 * while completed remove listener and mark loaded as loaded
		 * remove loader
		 */		
		private function completedHandler(event:Event):void {
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completedHandler);
			_content.bitmapData = Bitmap(_loader.content).bitmapData;
			_loaded = true;
			if (_loadedHandler != null) {
				_loadedHandler(event);								
			}
//			test();
		}
		
		private var _txtField:TextField;
		private function test():void {
			_txtField = new TextField();
			var format:TextFormat = new TextFormat();
			format.color = 0xFFF000;
			format.size = 14;
			format.bold = true;
			_txtField.defaultTextFormat = format;
//			_txtField.text = _url.substr(44);
			_txtField.text = x + "," + y;
			_txtField.x =  (256 - _txtField.textWidth) / 2;
			_txtField.y =  (256 - _txtField.textHeight) / 2;
			addChild(_txtField);
		}
		
		/**
		 * begin to load, return DisplayObject
		 * @override
		 */		
		override public function load():void {
			_request.url = _url;
			_loader.load(_request, new LoaderContext(true, null, null));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completedHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
		}
		
		//io error
		private function onIOErrorHandler(event:IOErrorEvent):void {
			//todo
		}
		
		/**
		 * clear all
		 * @override
		 */		
		override public function clear():void {
			_gc = true;
			_loaded = false;
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completedHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			_loader.unload();
			if (_content.bitmapData) {
				_content.bitmapData.dispose();
			}
		} 
		
		public function recycle():void {
			_url = "";
			_gc = true;
			_loaded = false;
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completedHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			_loader.unload();
			if (_content.bitmapData) {
				_content.bitmapData.dispose();
			}
		}
		
	}
}