package com.youcity.maps.overlays
{
	import com.youcity.maps.ScreenPoint;
	
	import flash.events.MouseEvent;
	
	/**
	 * To draw Line
	 * @author Jackie Wei
	 * 
	 */
	public final class LineDrawer extends GraphicDrawer//画线的类
	{
		private var _startPoint:ScreenPoint;//记录开始的点
		private var _endPoint:ScreenPoint;//记录结束的点
		
		/**
		 * @Constructor
		 * @param position
		 * 
		 */		
		public function LineDrawer(position:ScreenPoint)
		{
			super(this, position, GraphicDrawer.LINE);
			_startPoint = position;
			//addEventListener(MouseEvent.MOUSE_WHEEL, stopProHandler);
		}
		
		/**
		 * draw line to endPoint
		 * @param endPoint
		 * 
		 */		
		public function drawLine(endPoint:ScreenPoint):void//绘制图形，供外界调用的函数。
		{
			if (LINE != _type) return;
			clear();
			_endPoint = endPoint;
			graphics.lineStyle(5, 0xAADDFF, 0.8);
			graphics.beginFill(0xAADDFF);
			graphics.lineTo(_endPoint.x - _startPoint.x, _endPoint.y - _startPoint.y);
			graphics.endFill();
		}
		
		private function stopProHandler(event:MouseEvent):void
		{
			
		}
		
		/**
		 * redraw shape according to zoom
		 * @param zoom
		 * 
		 */		
		public override function reDraw(zoom:uint):void//定义当zoom变化的时候应该怎么重新绘制。供map调用
		{
			if (!_endPoint) return;
			_startPoint = position.toZoom(zoom);
			drawLine(_endPoint.toZoom(zoom));
		}
		
	}
}