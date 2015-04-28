package com.youcity.maps.overlays
{

	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.util.MapUtil;
	
	import mx.core.UIComponent;
	
	/**
	 * Abstract Class
	 * @author raven
	 * 
	 */	
	public class OverlayBase extends UIComponent implements IOverlay 
	{
	
		private var _position:ScreenPoint;
		
		/**
		 * 
		 * @return 
		 * Return the exact x and y value of the overlaybase
		 */		
		public function get position():ScreenPoint
		{
			return this._position;
			
		}
		
		/**
		 * Offset value at horizontal line
		 */	
		private var _offsetX:Number = 0;
		
		public function get offsetX():Number
		{
			return this._offsetX;
		}
		
		public function set offsetX(value:Number):void
		{
			_offsetX = value;
		}
		
		/**
		 * Offset value at vertical line
		 */		
		private var _offsetY:Number = 0;
		
		public function get offsetY():Number
		{
			return this._offsetY;
		}
		
		public function set offsetY(value:Number):void
		{
			_offsetY = value;
		}
		
		/**
		 * Indicates weather the overlay was enabled to be dragged 
		 */		 
		private var _dragable:Boolean = true;
		
		public function OverlayBase(self:OverlayBase, position:ScreenPoint)
		{
			super();
			if (self != this) 
				throw new Error("Abstract Class");
			draw();
			_position = position;
			doubleClickEnabled = true;
			setOverlayPosition(this._position);
		}
		
		/**
		 * 
		 * @return 
		 * Returnt the overlay's position
		 */		
		public function getOverlayPosition():ScreenPoint
		{
			if(!_position)
			return null;
			var newSP:ScreenPoint = new ScreenPoint(_position.zoom, _position.x, _position.y - this.offsetY);
			return newSP;
		}
		
		/**
		 * 
		 * @param value
		 * Set position for the overlay
		 */		
		public function setOverlayPosition(value:ScreenPoint):void
		{
			this._position = value;
			this.x = this._position.x - this.offsetX;
			this.y = this._position.y - this.offsetY;
		}
		
		public function relocate(zoom:uint):void
		{
			this.setOverlayPosition(_position.toZoom(zoom));
		}
		
		protected function draw():void
		{
			//to be implemented by its subclass
		}
		
		public function destory():void
		{
			MapUtil.removeAllChildren(this);
			this.graphics.clear();
			this.parent.removeChild(this);
		}
		
	}
}
