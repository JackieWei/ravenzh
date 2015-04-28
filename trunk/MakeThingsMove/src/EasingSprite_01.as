package
{
	import com.Ball;
	import com.BaseSprite;
	
	import flash.events.Event;
	/**
	 * 鼠标跟随的小球缓动 
	 * @author Raven
	 * 
	 */	
	public class EasingSprite_01 extends BaseSprite
	{
		private var ball:Ball;
		private var easing:Number = 0.1;
		
		public function EasingSprite_01()
		{
			super();
		}
		
		override protected function init():void
		{
			super.init();
			ball = new Ball(20);
			addChild(ball);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			var vx:Number = (mouseX - ball.x) * easing;
			var vy:Number = (mouseY - ball.y) * easing;
			ball.x += vx;
			ball.y += vy;
		}
		
	}
}