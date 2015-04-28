package com.youcity.maps.overlays
{
	import com.youcity.maps.AssetsEmbed;
	import com.youcity.maps.ScreenPoint;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	

	/**
	 * Marker of the map 
	 * @author Administrator
	 * 
	 */
	public final class Marker extends OverlayBase 
	{
		private var Icon:Class = AssetsEmbed.OVERLAY_MARKER_ICON;
					
		/**
		 * Create a new marker of map with a screenpoint
		 * 
		 * @param point
		 * 
		 */		
		public function Marker(point:ScreenPoint)
		{
			super(this, point);
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDownEvent);
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void
		{
			super.draw();
			var icon:* = new Icon();
			this.graphics.beginBitmapFill(icon.bitmapData, null, false);
			this.graphics.drawRect(0, 0, icon.width, icon.height);
//			this.graphics.drawRect(-icon.width, -icon.height, icon.width, icon.height);
			this.graphics.endFill();
			addShadow(this);
			
			offsetY = icon.height;
		}
		
		
		/**
		 * 
		 * @private
		 * 
		 */		
		private function handleMouseDownEvent(event:MouseEvent):void
		{
			// to do
			event.stopPropagation();
		}
		
		
		private function addShadow(target:DisplayObject):void
		{
			var arr:Array = new Array();
			var shadowFilter:DropShadowFilter = new DropShadowFilter();
			shadowFilter.angle = 360;
			shadowFilter.color = 0x000000;
			shadowFilter.distance = 5;
			shadowFilter.knockout = false;
			shadowFilter.alpha = 1;
			shadowFilter.hideObject = false;
			arr.push(shadowFilter);
			target.filters = arr;
		}
		
	}
}
