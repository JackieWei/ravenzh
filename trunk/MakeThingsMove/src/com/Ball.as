package com
{
	import flash.display.Sprite;

	public class Ball extends Sprite
	{
		private var _radius:Number;
		private var _color:uint;
		private var _vx:Number;
		private var _vy:Number;
		public function get radius():Number {return this._radius;}
		public function set radius(value:Number):void {this._radius = value;}
		public function get color():uint {return this._color;}
		public function set color(value:uint):void {this._color = value}
		public function get vx():uint {return this._vx;}
		public function set vx(value:uint):void {this._vx = value}
		public function get vy():uint {return this._vy;}
		public function set vy(value:uint):void {this._vy = value}
		
		public function Ball(radius:Number = 10, color:uint = 0x000000)
		{
			super();
			this._radius = radius;
			this._color = color;
			this._vx = 0;
			this._vy = 0;
			init();
		}
		
		private function init():void {
			graphics.beginFill(this.color * Math.random());
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
		} 
		
	}
}