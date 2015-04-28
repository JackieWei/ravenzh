package com.flar
{
	import flash.display.Sprite;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.BitmapViewport3D;

	public class CardEmulator extends Sprite
	{
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var testMarkerURL:String;
		
		private var emulatorScene:Scene3D;
		private var emulatorViewport:BitmapViewport3D;
		private var emulatorRenderer:BasicRenderEngine;
		private var emulatorCamera:Camera3D;
		private var testCard:Plane;
		private var addViewportToDisplay:Boolean = false;
		
		public function get viewport():BitmapViewport3D
		{
			return this.emulatorViewport;
		}
		
		public function CardEmulator(testMarkerURL:String, w:Number = 320, h:Number = 240, addViewportToDisplay:Boolean = false)
		{
			super();
			this.testMarkerURL = testMarkerURL;
			this._width = w;
			this._height = h;
			this.addViewportToDisplay = addViewportToDisplay;
			init3D();
		}
		
		private function init3D():void
		{
			emulatorViewport = new BitmapViewport3D(_width, _height);
			emulatorScene = new Scene3D();
			emulatorCamera = new Camera3D();
			emulatorRenderer = new BasicRenderEngine();
			
			var bitmapMaterial:BitmapFileMaterial = new BitmapFileMaterial(testMarkerURL, true);
			bitmapMaterial.doubleSided = true;
			testCard = new Plane(bitmapMaterial, 300, 300, 4, 4);
			
			emulatorCamera.target = testCard;
			emulatorScene.addChild(testCard);
			
			if (addViewportToDisplay)
				addChild(emulatorViewport);
		}
		
		private function calculateMouseMovement():void
		{
			if (stage)
			{
				var rotY: Number = (mouseY-(stage.stageHeight/2))/(stage.height/2)*(2200);
				var rotX: Number = (mouseX-(stage.stageWidth/2))/(stage.width/2)*(-2200);
				emulatorCamera.x = emulatorCamera.x + (rotX - emulatorCamera.x) / 2;
				emulatorCamera.y = emulatorCamera.y + (rotY - emulatorCamera.y) / 2;
			}
		}
		
		public function render():void
		{
			calculateMouseMovement();
			emulatorRenderer.renderScene(emulatorScene, emulatorCamera, emulatorViewport);
		}
		
	}
}
