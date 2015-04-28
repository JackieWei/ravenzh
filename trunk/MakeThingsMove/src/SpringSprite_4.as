package
{
	import com.Ball;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="1024", height="768")]
	public class SpringSprite_4 extends Sprite
	{
		private var ballNum:uint = 10;
		private var ballArr:Array = [];
		private var spring:Number = 0.1;
 		private var friction:Number = 0.6;
 		private var gravity:Number = 5;
		
		public function SpringSprite_4()
		{
			super();
			init();
		}
		
		protected function init():void {
			for (var i:uint = 0; i < ballNum; i ++) {
				var ball:Ball = new Ball();
				ballArr.push(ball);
				addChild(ball);
			}
			addEventListener(Event.ENTER_FRAME, eventFrameHandler);
		}
		
		private function eventFrameHandler(event:Event):void {
			graphics.clear();
			graphics.lineStyle(1);
			graphics.moveTo(mouseX, mouseY);
			
			for (var i:uint = 0; i < ballNum; i ++) {
				if (i == 0) {
					moveBall(ballArr[i], mouseX, mouseY);
				} else {
					moveBall(ballArr[i], ballArr[i - 1].x, ballArr[i - 1].y)
				}
				graphics.lineTo(ballArr[i].x, ballArr[i].y);
			}
		}
		
		private function moveBall(ball:Ball, targetX:Number, targetY:Number):void {
			ball.vx += (targetX - ball.x) * spring;
			ball.vy += (targetY - ball.y) * spring;
			ball.vy += gravity;
			ball.vx *= friction;
			ball.vy *= friction;
			ball.x += ball.vx;
			ball.y += ball.vy;
			
		}
		
	}
}