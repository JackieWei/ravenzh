package {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	import raven.TweenLite;

	public class StudyTweenLite extends Sprite
	{
		private var sprite1:Sprite;
		private var sprite2:Sprite;
		
		public function StudyTweenLite()
		{
			super();
			init();
		}
		
		private function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			sprite1 = new Sprite();
			draw(sprite1, 0x000000, 50, 20)
			addChild(sprite1);
			sprite1.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			sprite2 = new Sprite();
			sprite2.x = 100;
			sprite2.y = 100;
			draw(sprite2, 0x000000, 100, 100)
			addChild(sprite2);
		}
		
		private function draw(sprite:Sprite, color:int, w:int, h:int):void {
			var g:Graphics = sprite.graphics;
			g.beginFill(color);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		private function onMouseClick(event:MouseEvent):void {
		}
	}
}
