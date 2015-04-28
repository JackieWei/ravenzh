package com.youcity.maps.tiles.layers.tiles
{
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author Administrator
	 * 存储资源，根据key得到资源
	 */	
	internal class AdAssets
	{
		private static var _instance:AdAssets;
		public static  function get instance():AdAssets
		{
			if (!_instance) _instance = new AdAssets();
			return _instance;
		}
		
		private var _dictionary:Dictionary = new Dictionary(false);
		
		public function getAsset(source:String, callback:Function):void
		{
			if (_dictionary[source]) callback(_dictionary[source]);//如果当前有此资源就直接返回，如果没有就去加载
			else
			{
				var wrapper:LoaderWrapper = new LoaderWrapper(source, callback, _dictionary, null);
				wrapper.load();
			}
		}
		
		public function AdAssets()
		{
			
		}
	}
}

import flash.display.DisplayObject;
import flash.system.LoaderContext;
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLRequest;
import com.youcity.maps.MapConstants;
import flash.display.LoaderInfo;
import flash.events.IOErrorEvent;
import com.youcity.maps.tiles.layers.tiles.AdAssets;
import flash.utils.Dictionary;

[Event(type="flash.events.Event",name="complete")]
/**
 * 
 * @author Administrator
 * 加载资源的包装
 */
class LoaderWrapper
{
	private var _url:String;
	public function get url():String
	{
		return _url;
	}
	private var _content:DisplayObject;
	public function get content():DisplayObject
	{
		return _content;
	}
	
	private var _callback:Function;
	
	private var _dict:Dictionary;
	
	public function LoaderWrapper(url:String, callback:Function, dict:Dictionary = null, context:LoaderContext = null)
	{
		_callback = callback;
		_url = url;
		_dict = dict;
	}
	
	/**
	 * 
	 * 加载资源
	 */	
	public function load():void
	{
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
		loader.load(new URLRequest(_url),new LoaderContext(true));
	}
	
	private function onErrorHandler(event:IOErrorEvent):void
	{
        _callback = null;
	}
	
	/**
	 * 
	 * @param event
	 * 
	 */	
	private function onCompleteHandler(event:Event):void
	{
		var target:LoaderInfo = event.target as LoaderInfo;
		_content = target.content;
		if (_dict) _dict[_url] = _content;
		if (null != _callback) _callback(_content);
		_callback = null;
	}
	
}
