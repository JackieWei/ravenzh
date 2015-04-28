package
{
	import com.Ball;
	import com.BaseSprite;
	
	import flash.events.Event;
	
	public class SpringSprite_1 extends BaseSprite
	{
		private var ball:Ball;
		private var targetX:Number = 400;
		private var targetY:Number = 200;
		private var spring:Number = 0.1;
		private var friction:Number = 0.95;
		
		private var vy:Number = 0;
		
		public function SpringSprite_1()
		{
			super();
		}
		
		override protected function init():void {
			super.init();
			graphics.lineStyle(1, 0xFFFFFF);
			graphics.moveTo(0,200);
			graphics.lineTo(500, 200);
			graphics.endFill();
			ball = new Ball();
			ball.x = targetX;
			addChild(ball);
			addEventListener(Event.ENTER_FRAME, handleEnterFrameEvent);
		}
		
		private function handleEnterFrameEvent(event:Event):void
		{
			var ay:Number = (targetY - ball.y) * spring ;
			vy += ay;
			vy *= friction;
			ball.y += vy;
		}

	}
}