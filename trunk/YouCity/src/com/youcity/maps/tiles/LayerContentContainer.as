package com.youcity.maps.tiles
{
	import com.youcity.maps.MapConstants;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.tiles.layers.tiles.Tile;
	
	import flash.events.Event;
	
	import gs.TweenLite;
	
	import mx.core.UIComponent;

	/**
	 * 
	 * @author Administrator
	 * LayerContentContainer的实现的功能只有一个，就是在zoom变化时候找到自己新的位置
	 * 同时实现相应的scale
	 */    
	public class LayerContentContainer extends UIComponent
	{
		private var _position:ScreenPoint;
		public function get position():ScreenPoint
		{
			return _position;
		}
		public function set position(value:ScreenPoint):void
		{
			_position = value;
			x = value.x;
			y = value.y;
		}
		
		public function LayerContentContainer(containerWidth:Number = 0, containerHeight:Number = 0)
		{
			super();
			addEventListener(Event.REMOVED_FROM_STAGE, clearContent);
		}
		
		/**
		 * 
		 * @param zoom
		 * 当zoom变化时候找到正确的位置，并且缩放或者放大
		 */		
		public function accordToZoom(zoom:uint):void
		{
			var item:ScreenPoint = _position.toZoom(zoom);
			var scale:Number = Math.pow(2, _position.zoom - zoom);
			TweenLite.to(this, MapConstants.ZOOM_CHANGED_EFFECT_TIME, {x:item.x, y:item.y, scaleX:scale, scaleY:scale, alpha:0.99});
		}
		
		/**
		 * 
		 * @param event
		 * 清楚所有孩子
		 */		
		private function clearContent(event:Event):void
		{
			while(numChildren > 0)
			{
				var item:Tile = Tile(getChildAt(0));
				item.clear();
				removeChildAt(0);
			}
		}
		
	}
}