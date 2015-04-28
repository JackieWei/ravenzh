package com.youcity.website.front.util
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import mx.core.UIComponent;

	public class LoadingUI extends UIComponent
	{
		[Bindable]
		private var Loading:Class;
		
		private var _isLoading:Boolean = false;
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		public function set isLoading(value:Boolean):void
		{
			_isLoading = value;
			if (value)
			{
				addEventListener(Event.ENTER_FRAME, handleEnterFrameEvent);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, handleEnterFrameEvent);
				graphics.clear();
			}
		}
		
		
		private var increment:Number = 0;
		
		public function LoadingUI()
		{
			super();
		}
		
		private var flag:Boolean = false;
		private function handleEnterFrameEvent(event:Event):void
		{
			graphics.clear();
			graphics.beginFill(0x333333, 1);
			
			if (increment > width)
			{
				increment = 0;
				flag = !flag;
			}
			if (flag)
			{
				graphics.drawRect(increment, 0, width - increment, height);
			}
			else
			{
				graphics.drawRect(0, 0, increment, height);
			}
			
			graphics.endFill();
			increment += 6;
		}
		
		private var flag1:Boolean = false;
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (!flag1)
			{
				flag1 = true;
				
				var bg:Bitmap = new Loading() as Bitmap;
				this.addChild(bg);
				
			}
		}
		
	}
}