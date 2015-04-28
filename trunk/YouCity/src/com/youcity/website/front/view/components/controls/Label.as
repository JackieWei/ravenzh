package com.youcity.website.front.view.components.controls
{
	import flash.text.TextFieldAutoSize;
	
	import mx.controls.Label;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;

	public class Label extends mx.controls.Label
	{
		public function Label()
		{
			super();
			truncateToFit = true;
			//addEventListener(ResizeEvent.RESIZE, onResizeHandler);
			//addEventListener(FlexEvent.CREATION_COMPLETE, createdHandler);
		}
		
		private function onResizeHandler(event:ResizeEvent):void
		{
			resize();
		}
		
		private function createdHandler(event:FlexEvent):void
		{
			textField.autoSize = TextFieldAutoSize.LEFT;
			resize();
		}
		
		private function resize():void
		{
			return;
			textField.width = width;
			textField.height = height;
			textField.truncateToFit();
		}
		
	}
}