package com.youcity.maps.overlays
{
	import com.youcity.maps.ScreenPoint;

	/**
	 * Abstract Class to draw graphics
	 * @author Jackie Wei
	 * 
	 */
	public class GraphicDrawer extends OverlayBase//画图的类
	{
		/**
		 * Constants Line
		 */		
		public static const LINE:String = "line";//类型line
		/**
		 * Constants Rect
		 */		
		public static const RECT:String = "rectangle";//类型矩形

		/**
		 * read only property type
		 */		
		protected var _type:String;
		public function get type():String//当前的drawer的类型。注意这个其实并没有实现什么。
		{
			return _type;
		}
		
		/**
		 * Constructor
		 * @param self : For Abstract Class Check
		 * @param position : For overlay position
		 * @param type : drawer type
		 * 
		 */		
		public function GraphicDrawer(self:GraphicDrawer, position:ScreenPoint, type:String)//绘制图形的工具，基类
		{
			super(self, position);
			if (self != this) throw new Error("Abstarct Class");
			_type = type;
		}
		
		/**
		 * 
		 * @param start
		 * remove line from mark
		 */		
		public function clear():void//清楚图形
		{
			graphics.clear();
		}
		
		/**
		 * redraw
		 * @param zoom
		 * 
		 */		
		public function reDraw(zoom:uint):void
		//重新绘制，这个是接口函数，
		//主要是为了各个子类在zoom变化时重新绘制其图形所做的处理。
		//本身没有任何的动作。
		//这个就是传说中的多态的实现
		{
			
		}
	}
}