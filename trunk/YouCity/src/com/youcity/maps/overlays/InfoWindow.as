package com.youcity.maps.overlays
{
	import com.youcity.maps.ScreenPoint;
	
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @author raven
	 * 
	 */	
	public class InfoWindow extends OverlayBase
	{
		public function InfoWindow(self:OverlayBase, position:ScreenPoint)
		{
			super(self, position);
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDownEvent);
		}
		
		public function setPosition(position:ScreenPoint):void
		{
			offsetX = width/2;
			offsetY = height;
			setOverlayPosition(position);
		}
		
		private function handleMouseDownEvent(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
	}
}