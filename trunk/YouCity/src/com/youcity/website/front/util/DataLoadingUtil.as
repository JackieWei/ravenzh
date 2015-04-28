package com.youcity.website.front.util
{
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	
	public final class DataLoadingUtil
	{
		private static var _dictionary:Dictionary = new Dictionary();
		
		public static function startLoading(ui:UIComponent):void
		{
			if (_dictionary[ui] != null)
			return;
			
			var loadingUI:Loading = new Loading();
			var __w:Number = ui.width > 60 ? 60 : ui.width - 10;
			var __h:Number = ui.height >60 ? 60 : ui.height - 10;
			loadingUI.x = (ui.width - __w) / 2;
			loadingUI.y = (ui.height - __h) / 2;
			loadingUI.scaleX = __w/loadingUI.width;
			loadingUI.scaleY = __h/loadingUI.height;
//			loadingUI.isLoading = true;
			ui.addChild(loadingUI);
			
			//hold the loadingUI instance , when we remove the loadingUI, we need this instance
			_dictionary[ui] = loadingUI;
		}
		
		public static function finishLoading(ui:UIComponent):void
		{
			if (ui == null || _dictionary[ui] == null)
			return;
			if (ui.contains(_dictionary[ui] as Loading))
			{
//				LoadingUI(_dictionary[ui]).isLoading = false;
				ui.removeChild(_dictionary[ui]);
				delete _dictionary[ui];
			}
		}
		
	}
}