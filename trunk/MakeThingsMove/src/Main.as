package {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Main extends Sprite
	{
		
		public function Main()
		{
			super();
			init();
		}
		
		private var rot:Number = 32700;
		private var boxA:Shape;
		private var boxB:Shape;
		private function init():void
		{
			boxA = Shape(addChild(new Shape()));
			with (boxA.graphics) beginFill(0), drawRect(-10,-10,20,20);
			 
			boxB = Shape(addChild(new Shape()));
			with (boxB.graphics) beginFill(0), drawRect(-10,-10,20,20);
			 
			boxA.x = 100;
			boxA.y = 100;
			 
			boxB.x = 200;
			boxB.y = 100;
			addEventListener(Event.ENTER_FRAME, onLoop);
		}
		
		private function onLoop(evt:Event):void {
		  rot += 1
		  // will stop rotating
		  boxA.rotation = rot
		  trace(boxA.rotation);
		  // will keep rotating
		  boxB.rotation = rot % 360;
		}
		
	}
}
