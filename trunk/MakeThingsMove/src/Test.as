package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Test extends Sprite
	{
		private var square:Sprite = new Sprite();
		
		public function Test()
		{
			super();
			init();
		}
		
		private function init():void {
			square.graphics.beginFill(0xFF0000);
			square.graphics.drawRect(0, 0, 200, 200);
			addChild(square);
			square.addEventListener(MouseEvent.CLICK, traceCoordinates);
		}
		
		private function traceCoordinates(event:MouseEvent):void {
		    trace(square.mouseX, square.mouseY);
		}
	}
}