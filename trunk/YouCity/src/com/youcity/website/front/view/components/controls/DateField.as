package com.youcity.website.front.view.components.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.DateField;

	public class DateField extends mx.controls.DateField
	{
		public function DateField()
		{
			super();
			styleName = "ycDateField";
			yearNavigationEnabled = true;
			editable = true;
			setStyle("borderThickness", 0);
			setStyle("focusAlpha", 0);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemoveHandler);
            addEventListener(MouseEvent.CLICK, onClickHandler);
		}
		
		private function onClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		override public function open():void
		{
			if (mouseX < width - 20) return;
			super.open();
		}
		
		private function onRemoveHandler(event:Event):void
		{
			clear();
		}
		
		public function clear():void
		{
			close();
		}
		
	}
}