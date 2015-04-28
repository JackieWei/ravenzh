package {

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;


	 

       public class ManyButtons extends Sprite {
		private var canvas:BitmapData;
		private var indexCanvas:BitmapData;
		private var btnNum:int;
		private var info:Array;
		private var brush:BitmapData;
		private var border:Shape;
		private var txt:TextField;
		private var tf:TextFormat;
		private var redRect:Shape;
		private var pnt:Point;
		private var r:Rectangle;


			[SWF (width = 500, height = 500)]
               public function ManyButtons(){
                  // init
             
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			canvas = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xFFFFFF);
			addChild(new Bitmap(canvas));
			
			indexCanvas = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xFFFFFF);
			
			btnNum = 5000;
			info = [];
			
			brush = new BitmapData(10,10,false, 0xCCCCCC);
			border = new Shape();
			border.graphics.lineStyle(2, 0x000000);
			border.graphics.drawRect(0,0,10,10);
			brush.draw(border);
			
			txt = TextField(addChild(new TextField()));
			with (txt) height = 20, width = 50, background = 0xFFFFFF, selectable = false
			tf = new TextFormat();
			tf.align = TextFormatAlign.RIGHT;
			txt.border= true;
			txt.defaultTextFormat = tf;
			
			redRect = Shape(addChild(new Shape()));
			with (redRect.graphics) beginFill(0xFF0000), drawRect(0,0,10,10);
														  
			pnt = new Point();
			r = new Rectangle(0,0,10,10);
			for (var i:int = 0; i < btnNum; i++){
				pnt.x = r.x = int(Math.random() * stage.stageWidth);
				pnt.y = r.y = int(Math.random() * stage.stageHeight); 
				indexCanvas.fillRect(r, i);
				canvas.copyPixels(brush, brush.rect, pnt)
				info[i] = [r.x, r.y, i];	
			}
			
			addEventListener(Event.ENTER_FRAME, onCheckBtns);
			

               }
               // private methods

		private function onCheckBtns(evt:Event):void{
		   var currentIndex:int = indexCanvas.getPixel(mouseX, mouseY);
		   if (currentIndex != 0xFFFFFF){
			 var currentBox:Array = info[currentIndex]
			 redRect.visible = true;
			 redRect.x = currentBox[0];
			 txt.y = redRect.y = currentBox[1];
			 if (mouseX < txt.width){
				 tf.align = TextFormatAlign.LEFT;
				 txt.defaultTextFormat = tf;
				 txt.x = redRect.x + 10;
			 }else{
				 tf.align = TextFormatAlign.RIGHT;
				 txt.defaultTextFormat = tf;
				 txt.x = redRect.x - txt.width;
			 }
			 txt.text = currentBox[2];
			 txt.visible = true;
		   }else{
			 redRect.visible = false; 
			 txt.visible = false;
		   }
		}
		

       }

}