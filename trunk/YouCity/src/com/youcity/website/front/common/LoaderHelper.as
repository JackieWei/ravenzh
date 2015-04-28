package com.youcity.website.front.common
{
	import com.adobe.net.DynamicURLLoader;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	
	public class LoaderHelper
	{
		private var _file:String;
		public function get file():String
		{
			return this._file
		}
		public function set file(value:String):void
		{
			if (value != null && value != "")
			this._file = value;
		}
		
		public function LoaderHelper(file:String, loadSucceedHandler:Function = null, loadFailedHandler:Function = null)
		{
			if (file == null ||file == "")
			return;
			this._file = file;
			var loader:DynamicURLLoader = new DynamicURLLoader();
			if (loadSucceedHandler != null)
			{
				loader.addEventListener(Event.COMPLETE, loadSucceedHandler);
			}
			if (loadFailedHandler != null)
			{
				loader.addEventListener(IOErrorEvent.IO_ERROR, loadFailedHandler);
			}
			
			loader.load(new URLRequest(this._file));
			
		}
		

	}
}