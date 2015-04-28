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
		private var iconChanged:Boolean = false;
		private var _icon:Class;
		public function get icon():Class
		{
			return this._icon;
		}
		public function set icon(value:Class):void
		{
			if (value != null && value != this._icon)
			{
				this._icon = value;
				iconChanged = true;
				invalidateProperties();
			}
		}
					
		/**
		 * Create a new marker of map with a screenpoint
		 * 
		 * @param point
		 * 
		 */		
		public function Marker(point:ScreenPoint, icon:Class = null)
		{
			super(this, point);
			this.icon = icon ? icon : AssetsEmbed.OVERLAY_MARKER_ICON;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDownEvent);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (iconChanged)		
			{
				iconChanged = false;
				draw();
			}
		}
		
		/**
		 *use graphics to draw the marker 
		 */		
		override protected function draw():void
		{
			super.draw();
			if (!_icon)
			return;
			
			var icon:* = new _icon();
			this.graphics.beginBitmapFill(icon.bitmapData, null, false);
			this.graphics.drawRect(0, 0, icon.width, icon.height);
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
