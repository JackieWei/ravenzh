package com.youcity.website.front.view.common
{
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	public class ContentVeil
	{
		private var _mask:UIComponent;
		private function set mask(value:UIComponent):void
		{
			if (_mask && _content.contains(_mask))
				_content.removeChild(_mask);
			_mask = value;
			_mask.percentWidth = 100;
			_mask.percentHeight = 100;
		}
		
		private var _content:UIComponent;
		
		public function ContentVeil(content:UIComponent, mask:UIComponent = null)
		{
			_content = content;
			_content.addEventListener(ResizeEvent.RESIZE, onReizeHandler);
			if (mask)
				this.mask = mask;
			else
				setDefaultMask();
		}
		
		private function onReizeHandler(event:ResizeEvent):void
		{
			
		}
		
		private function setDefaultMask():void
		{
			var ms:Canvas = new Canvas();
			ms.alpha = 0.5;
			ms.setStyle("backgroundColor", 0x000000);
			mask = ms;
		}
		
		public function showveil():void
		{
			if (_mask && !_content.contains(_mask))
				_content.addChild(_mask);
		}
		
		public function unveil():void
		{
			if (_mask && _content.contains(_mask))
				_content.removeChild(_mask);
			clear();
		}
		
		public function clear():void
		{
			_mask = null;
			_content = null;
		}
		

	}
}