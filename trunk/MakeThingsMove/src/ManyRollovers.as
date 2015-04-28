package {

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;

       // After the lines have finished 
       // drawing, move your
       // mouse around the screen

	[SWF(width = 500, height = 500, frameRate = 30)]
	public class ManyRollovers extends Sprite {
       	
		private var canvas:BitmapData;
		private var indexCanvas:BitmapData;
		private var s:Shape;
		private var lineData:Array;
		private var dataIndex:int;
		private var totalLines:int;
		private var iterations:int;
		private var linesPerIter:int;
		private var xp:int;
		private var yp:int;
		private var stepAmt:Number;
		private var halfStepAmt:Number;

		public function ManyRollovers()
		{
			init();
		}
		
		private function init():void {
			stage.scaleMode =  StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			
			canvas = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xFFFFFF);
			indexCanvas = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xFFFFFF); 
			addChild(new Bitmap(canvas));
			
			s = new Shape();
			lineData = [];
			dataIndex = 0;
			totalLines = 100;
			iterations = 9;
			linesPerIter = totalLines / iterations;
			
			xp = stage.stageWidth >> 1;
			yp = stage.stageHeight >> 1;
			stepAmt = 60;
			halfStepAmt = stepAmt / 2;
			
			addEventListener(Event.ENTER_FRAME, onDraw);
		}
               // private methods

		private function onDraw(evt:Event):void {
		     if (lineData.length < totalLines){
				generateData(linesPerIter); 
			 }else{
				stage.quality = "high";
				addChild(s);
				s.x = 0;
				s.y = 0;
				 
				removeEventListener(Event.ENTER_FRAME, onDraw);
				addEventListener(Event.ENTER_FRAME, onRun);
			 }
		}
		private function onRun(evt:Event):void {
		   var currentIndex:int = indexCanvas.getPixel(mouseX, mouseY);	
		   var currentLine:Array = lineData[currentIndex];
		   
		   s.graphics.clear();
		   if (currentIndex != 0xFFFFFF){
				  s.graphics.lineStyle(3, 0xFF0000);
				  s.graphics.moveTo(currentLine[0], currentLine[1]);
				  s.graphics.lineTo(currentLine[2], currentLine[3]);  
		   }
		}
		private function generateData(num:int):void{
			var rxA:int, rxB:int, ryA:int, ryB:int;	
			var g:Graphics = s.graphics;
			for (var i:int = 0; i<num; i++){
				rxA = xp;
				ryA = yp;
				
				xp += Math.round(Math.random() * stepAmt) - halfStepAmt;
				yp += Math.round(Math.random() * stepAmt) - halfStepAmt;
				
				if (xp > stage.stageWidth){
					xp = stage.stageWidth - halfStepAmt;
				}else
				if (xp < 0){
					xp = halfStepAmt;
				}
				if (yp > stage.stageHeight){
					yp = stage.stageHeight - halfStepAmt;
				}else
				if (yp < 0){
					yp = halfStepAmt;
				}
				
				rxB = xp;
				ryB = yp;
				 
				lineData[dataIndex] = [rxA, ryA, rxB, ryB];        		
			    s.x = rxA;
				s.y = ryA;
				var endX:Number = rxB - rxA;
				var endY:Number = ryB - ryA;
				var m:Matrix = s.transform.matrix;
				g.clear();
				g.lineStyle(1, 0x000000, 0.3);
		
				g.lineTo(endX, endY);
				stage.quality = "high";
				canvas.draw(s, m);
				
				g.clear();
				g.lineStyle(3, dataIndex);
				
				g.lineTo(endX, endY);
				stage.quality = "low";
				indexCanvas.draw(s, m);
				
				dataIndex++
			}
		}
		

       }

}