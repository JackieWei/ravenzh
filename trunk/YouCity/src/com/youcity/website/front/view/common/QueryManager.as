package com.youcity.website.front.view.common
{
	import com.youcity.website.front.common.Config;
	import com.youcity.website.front.common.Constants;
	import com.youcity.website.front.util.DebugUtil;
	import com.youcity.website.front.view.building.BuildingProxy;
	import com.youcity.website.front.view.business.BusinessProxy;
	
	import flash.external.ExternalInterface;
	
	import mx.events.BrowserChangeEvent;
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;
	
	public class QueryManager
	{
		private static var key:Boolean;
		private static var _instance:QueryManager;
		public static function get instance():QueryManager
		{
			if (!_instance)
			{
				key = true;
				_instance = new QueryManager();
			}
			return _instance;
		}
		
		public function QueryManager()
		{
			if (!key)
			{
				throw new Error("Singlton");
				return;
			}
			key = false;
		}
		
		public function get browserManager():IBrowserManager
		{
			return BrowserManager.getInstance();
		}
		
		public function init():void
		{
//			browserManager.init("", "");
/* 			browserManager.addEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE, browserChangeHandler);
			browserManager.addEventListener(BrowserChangeEvent.URL_CHANGE, browserChangeHandler);
			browserManager.addEventListener(BrowserChangeEvent.APPLICATION_URL_CHANGE, browserChangeHandler);
			setTimeout(browserChangeHandler, 2000, null); */
			urlParser();
		}
		
		private function browserChangeHandler(event:BrowserChangeEvent):void
		{
//			browserManager.setTitle("www.youcity.com");
		}
		
		private var _queryParams:Array;
		public function get queryParams():Array
		{
			return _queryParams;
		}
		
		public function getRelativeLink(type:String, id:String):String {
			//todo
			DebugUtil.debug();
			return "";
			if ("activity" == type.toLowerCase() || Constants.ACTIVITY == type) type = "activity";
			else if ("business" == type.toLowerCase() || Constants.BUSINESS == type) type = "business";
			else if ("building" == type.toLowerCase() || Constants.BUILDING == type) type = "building";
			else return null;
			var url:String = ExternalInterface.call("getUrl") as String;
			var last:int = url.indexOf("?");
			last = last < 0 ? url.length : last;
            var url_1:String = url.substring(0,last);
            url_1 += "?" + type + "=" + id;
            return url_1;
		}
		private function urlParser():void
		{
			_queryParams = [];
			var resultObj:Array = ExternalInterface.call("getQueryStringValue") as Array;
//			var o:Object = URLUtil.stringToObject(browserManager.fragment);
			if (!resultObj || resultObj.length <= 0) return;
			var arrItem:Array;
			for (var i:uint = 0; i < resultObj.length; i++)
			{
				arrItem = String(resultObj[i]).split("=");
				_queryParams.push(arrItem);
				switch(arrItem[0])
				{
					case "building" : 
					{
						Config.NEED_LOCATE_NEW_CENTER = true;
						BuildingProxy.instance.openBuilding(arrItem[1] as String);
						break;
					}
					case "business" : 
					{
						Config.NEED_LOCATE_NEW_CENTER = true;
						BusinessProxy.instance.openBusinessView(arrItem[1] as String);
					}
					default : break;
				}
			}
		}
		
		
	}
}