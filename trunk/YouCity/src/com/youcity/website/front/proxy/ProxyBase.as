package com.youcity.website.front.proxy
{
	import com.youcity.website.front.event.EventBase;
	import com.youcity.website.front.util.DataLoadingUtil;
	import com.youcity.website.front.view.common.CallbackData;
	
	import mx.core.UIComponent;
	
	public class ProxyBase
	{
		protected var _callback:Function;
		protected var _container:UIComponent;
		
		public function ProxyBase(callback:Function, container:UIComponent)
		{
			_callback = callback;
			_container = container;
		}
		
		public function dispatchEvent(event:EventBase):void
		{
			event.callback = callbackHandler;
			event.dispatch();
			if (_container)
				DataLoadingUtil.startLoading(_container);
		}
		
		protected function callbackHandler(callbackData:CallbackData):void
		{
			if (_container)
				DataLoadingUtil.finishLoading(_container);
			if (null != _callback)
				_callback(callbackData);
			clear();
		}
		
		protected function clear():void
		{
			_callback = null;
			_container = null;
		}
	}
}