package
{
	import com.Ball;
	import com.BaseSprite;
	
	import flash.events.Event;

	public class SpringSprite_2 extends BaseSprite
	{
		private var ball:Ball;
		private var spring:Number = 0.1;//弹性参数
		private var vx:Number = 0;//初始的x轴速度
		private var vy:Number = 0;//初始的y轴速度
		private var friction:Number = 0.8;//摩擦力参数
		private var gravity:Number = 5;//重力参数
		
		public function SpringSprite_2()
		{
			super();
		}
		
		override protected function init():void {
			super.init();
			ball = new Ball(10);
			addChild(ball);
			
			addEventListener(Event.EXIT_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void {
			var ax:Number = (mouseX - ball.x) * spring;
			var ay:Number = (mouseY - ball.y) * spring;
			vx += ax;
			vy += ay;
			vy += gravity;
			ball.x += vx * friction;
			ball.y += vy * friction;
			
			graphics.clear();
			graphics.lineStyle(1, 0xFF0000);
			graphics.moveTo(mouseX, mouseY);
			graphics.lineTo(ball.x, ball.y);
		}
	}
}