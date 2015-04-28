package com.youcity.website.front.view.components.controls
{
	import flash.events.Event;
	
	import mx.controls.ComboBox;

	public class ComboBox extends mx.controls.ComboBox
	{
		public function ComboBox()
		{
			super();
			this.styleName = "ycComboBox";
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveHandler);
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