package {
	import com.flar.ARDector;
	import com.flar.CardEmulator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.pv3d.FLARCamera3D;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	public class FLARVision extends Sprite
	{
		private var scence:Scene3D;
		private var viewPort:Viewport3D;
		protected var camera:Camera3D;
		private var renderer:BasicRenderEngine;
		private var plane:Plane;
		
		protected var emulatorCard:CardEmulator;
		private var arDetector:ARDector;
		private var capturedSrc:Bitmap;
		
		private var isActive:Boolean = false;
		protected var baseNode:FLARBaseNode;
		private var resultMat:FLARTransMatResult = new FLARTransMatResult();	
		
		protected var webcam:Camera;
		protected var video:Video;
		protected var debug:Boolean = false;
		
		public function FLARVision()
		{
			super();
			initStage();
			initFlarDetector();
		}
		
		protected function initStage():void
		{
			stage.quality = StageQuality.HIGH;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, handleStagetResizeEvent);
		}
		
		private function handleStagetResizeEvent(event:Event):void
		{
			if (capturedSrc)
				resize(capturedSrc, stage.stageWidth, stage.stageHeight);
			
			if (viewPort)
				resize(viewPort, stage.stageWidth, stage.stageHeight);
		}
		
		private function resize(target:DisplayObject, areaWidth:Number, areaHeight:Number, aspectRatio:Boolean = true, autoCenter:Boolean = true):void
		{
			if (aspectRatio)
			{
				var sw:Number = areaWidth;
				var sh:Number = areaHeight;
				var tw:Number = target.width;
				var th:Number = target.height;
				
				var si:Number;
				if (sw > sh)
				{
					si = sw / tw;
					if (th * si > sh)
					si = sh / th;
				}
				else
				{
					si = sh / th;
					if (tw * si > sw)
					si = sw / tw;
				}
				
				var wn:Number = tw * si;
				var hn:Number = th * si;
				
				target.width = wn;
				target.height = hn;
			}
			else
			{
				target.width = areaWidth;
				target.height = areaHeight;
			}
			
			if (autoCenter)
			{
				target.x = (areaWidth - target.width) * 0.5;
				target.y = (areaHeight - target.height) * 0.5;
			}	
		}
		
		private function initFlarDetector():void
		{
			arDetector = new ARDector();
			arDetector.addEventListener(Event.COMPLETE, handleARDectorReady, false, 0, true);
			arDetector.setup("assets/data/camera_para.dat", "assets/data/flarlogo.pat");
		}
		
		private function handleARDectorReady(event:Event):void
		{
			arDetector.removeEventListener(Event.COMPLETE, handleARDectorReady);
			initCapturedSource();
			init3DObject();
			init3DScene();
			initCardEmulator();
			addEventListener(Event.ENTER_FRAME, renderView);
		}
		
		private function initCapturedSource():void
		{
			capturedSrc = new Bitmap(new BitmapData(arDetector.width, arDetector.height, false, 0),PixelSnapping.AUTO, true);
			arDetector.src = capturedSrc.bitmapData;
			addChild(capturedSrc);
		}
		
		protected function init3DObject():void
		{
			plane = new Plane(new WireframeMaterial(0xFF0000), 500, 500, 4, 4);
			baseNode = new FLARBaseNode();
			baseNode.rotationX = 180;
			baseNode.addChild(plane);
		}
		protected function init3DScene():void
		{
			scence = new Scene3D();
			scence.addChild(baseNode);

			viewPort = new Viewport3D(stage.width,stage.height);
			addChild(viewPort);
			
			camera = new FLARCamera3D(arDetector.flarParam);
			renderer = new BasicRenderEngine();
		}
		
		private function initCardEmulator():void
		{
			emulatorCard = new CardEmulator("assets/images/flarlogo.gif");
			addChild(emulatorCard);
		}
		
		protected function initWebCam():void
		{
			if (debug || !Camera.getCamera())
			{
				initCardEmulator();
			}
			else
			{
				webcam = Camera.getCamera();
				webcam.setMode(arDetector.width, arDetector.height, 30);
				video = new Video(arDetector.width, arDetector.height);
				video.attachCamera(webcam);
			}
		}
		
		protected function updateCapturedSource():void
		{
			if (debug || !Camera.getCamera())
			{
				emulatorCard.render();
				capturedSrc.bitmapData.draw(emulatorCard.viewport);
			}
			else
			{
				capturedSrc.bitmapData.draw(video);
			}
		}
		
		private function renderView(event:Event):void
		{
			updateCapturedSource();
			try
			{
				if (arDetector.detectMarker())
				{
					arDetector.calculateTransformMatrix(resultMat);
					baseNode.setTransformMatrix(resultMat);
					active();
				}
				else
				{
					deactive();
				}
			}catch(error:Error)
			{
				trace(error.getStackTrace());
			}
			renderer.renderScene(scence, camera, viewPort);
		}
		
		private function active():void
		{
			if (!isActive)
			{
				isActive = true;
				baseNode.visible = true;
			}
		}
		
		private function deactive():void
		{
			if (isActive)
			{
				isActive = false;
				baseNode.visible = false;
			}
		}
			
	}
}

