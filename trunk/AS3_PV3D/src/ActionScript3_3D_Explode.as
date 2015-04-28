package {
	import com.explode.PlaneVO;
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;


	public class ActionScript3_3D_Explode extends BasicView
	{
		private static const PIC_URL:String = "assets/queen.gif";
		private static const ROW_NUM:uint = 13;
		private static const COLUMN_NUM:uint = 5;
		private static const CELL_WIDTH:Number = 30;
		private static const CELL_HEIGHT:Number = 18;
		
		private var _loader:Loader;
		private var _container:DisplayObject3D;
		private var _planeVOs:Array;
		
		public function ActionScript3_3D_Explode()
		{
			super();
			init();
		}
		
		//加载要处理的图片
		private function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_container = new DisplayObject3D();
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.load(new URLRequest(PIC_URL));
			
			_planeVOs = [];
			
			stage.addEventListener(MouseEvent.CLICK, clickHandler);		
		}
		
		//图片加载完成
		private function completeHandler(event:Event):void {
			split();
			startRendering();
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
					bmd.draw(_loader.content, matrix);
					
					var metarial:BitmapMaterial = new BitmapMaterial(bmd);
					metarial.smooth = true;
					
					var plane:Plane = new Plane(metarial, CELL_WIDTH, CELL_HEIGHT);
					plane.x = j * CELL_WIDTH; 
					plane.y = - i * CELL_HEIGHT;
					_container.addChild(plane);
					
					var planeVO:PlaneVO = new PlaneVO();
					planeVO.originalX = plane.x;
					planeVO.originalY = plane.y;
					planeVO.originalZ = plane.z;
					planeVO.rotationX = plane.rotationX;
					planeVO.rotationY = plane.rotationY;
					planeVO.rotationZ = plane.rotationZ;
					planeVO.planeRef = plane;
					_planeVOs.push(planeVO);
				}
			}
			scene.addChild(_container);
			camera.zoom = 100;
			_container.rotationX = 30;
			_container.rotationY = 30;
		}
		
		//随机移动图片，达到爆炸效果
		private function explode():void {
			var length:uint = _planeVOs.length;
			for (var i:uint = 0; i < length; i ++) {
				var planeVO:PlaneVO = _planeVOs[i] as PlaneVO;
				var newX:Number = Math.random() * 4000 - 6000 + planeVO.originalX;
				var newY:Number = Math.random() * 8000 - 1000 + planeVO.originalZ;
				var newZ:Number = Math.random() * 5000 - 1000 + planeVO.originalZ + 150;
				var newRotation:Number = Math.random() * 360;
				var delay:Number = i * 0.05 * 0.6;
				TweenLite.to(planeVO.planeRef, 2, {x:newX, y:newY, z:newZ, rotationX:newRotation, rotationX:newRotation, delay:delay});
			}
			TweenLite.delayedCall(3, rebuild);
		}
		
		//根据小图片原始信息，重新组装图片
		private function rebuild():void {
			var length:uint = _planeVOs.length;
			for (var i:uint = 0; i < length; i ++) {
				var planeVO:PlaneVO = _planeVOs[i] as PlaneVO;
				var delay:Number = 0;
				TweenLite.to(planeVO.planeRef, 2, {x:planeVO.originalX, y:planeVO.originalY, z:planeVO.originalZ, rotationX:planeVO.rotationX, rotationX:planeVO.rotationY, delay:delay});
			}
			TweenLite.delayedCall(3, explode);
		}
	}
}
