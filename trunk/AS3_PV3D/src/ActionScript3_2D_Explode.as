package {
	import caurina.transitions.Tweener;
	
	import com.explode.BitmapVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;


	public class ActionScript3_2D_Explode extends Sprite
	{
		private static const PIC_URL:String = "assets/queen.png";
		private static const ROW_NUM:uint = 26;
		private static const COLUMN_NUM:uint = 10;
		private static const CELL_WIDTH:Number = 15;
		private static const CELL_HEIGHT:Number = 9;
		
		private var _loader:Loader;
		private var _container:Sprite;
		private var _bitmapVOs:Array;
		private var _startX:Number;
		private var _startY:Number;
		
		public function ActionScript3_2D_Explode()
		{
			super();
			init();
		}
		
		//加载要处理的图片
		private function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_container = new Sprite();
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.load(new URLRequest(PIC_URL));
			
			_bitmapVOs = [];
			
			stage.addEventListener(MouseEvent.CLICK, clickHandler);		
		}
		
		//图片加载完成
		private function completeHandler(event:Event):void {
			_startX = (stage.stageWidth - event.target.content.width) / 2;
			_startY = (stage.stageHeight - event.target.content.height) / 2;
			addChild(_container);
			
			split();
		}
		
		//监听IOError事件，处理图片加载不了的异常
		private function ioErrorHandler(event:IOErrorEvent):void {
			//to do	
		}
		
		private var _exloded:Boolean;
		private function clickHandler(event:MouseEvent):void {
			if (_exloded) {
				_exloded = false;
				rebuild();
			} else {
				_exloded = true;
				explode();
			}
		}
		
		
		//将图片分割成5*13个30*18大小的小图片, 并存储每个小图片的原始信息，
		//包括,  所在行列row， column，初始坐标值originalX，originalY及初始的旋转度rotationX, rotationY
		private function split():void {
			for (var i:uint = 0; i < ROW_NUM; i ++) {
				for (var j:uint = 0; j < COLUMN_NUM; j ++) {
					var bmd:BitmapData = new BitmapData(CELL_WIDTH, CELL_HEIGHT, true, 0x000000);
					var matrix:Matrix = new Matrix();
					matrix.translate(- j * CELL_WIDTH, - i * CELL_HEIGHT);
					bmd.draw(_loader, matrix);
					
					var bitmap:Bitmap = new Bitmap(bmd);
					bitmap.x = j * CELL_WIDTH + _startX;
					bitmap.y = i * CELL_HEIGHT + _startY;
					_container.addChild(bitmap);
					
					var bitmapVO:BitmapVO = new BitmapVO();
					bitmapVO.originalX = bitmap.x;
					bitmapVO.originalY = bitmap.y;
					bitmapVO.rotationX = 0;
					bitmapVO.rotationY = 0;
					bitmapVO.bitmap = bitmap;
					_bitmapVOs.push(bitmapVO);
				}
			}
			trace("Split Done");
		}
		
		//随机移动图片，达到爆炸效果
		private function explode():void {
			var length:uint = _bitmapVOs.length;
			for (var i:uint = 0; i < length; i ++) {
				var bitmapVO:BitmapVO = _bitmapVOs[i] as BitmapVO;
				var newX:Number = Math.random() * stage.stageWidth;
				var newY:Number = Math.random() * stage.stageHeight;
				var newRotation:Number = Math.random() * 360;
				var delay:Number = 0;
				Tweener.addTween(bitmapVO.bitmap, {x:newX, y:newY, rotationX:newRotation, rotationX:newRotation, delay:delay, time:2});
			}
		}
		
		//根据小图片原始信息，重新组装图片
		private function rebuild():void {
			var length:uint = _bitmapVOs.length;
			for (var i:uint = 0; i < length; i ++) {
				var bitmapVO:BitmapVO = _bitmapVOs[i] as BitmapVO;
				var delay:Number = 0;
				Tweener.addTween(bitmapVO.bitmap, {x:bitmapVO.originalX, y:bitmapVO.originalY, rotationX:bitmapVO.rotationX, rotationX:bitmapVO.rotationY, delay:delay, time:2});
			}
		}
		
	}
}
