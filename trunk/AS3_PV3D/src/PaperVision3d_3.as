package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	
	/**
	 * 
	 * @author Administrator
	 * Third Papervision Example 
	 * It's about using Event.EnterFrame event
	 */	
	public class PaperVision3d_3 extends Sprite
	{
		private var viewport:Viewport3D;
		private var scence:Scene3D;
		private var camera:Camera3D;
		private var renderer:BasicRenderEngine;
		
		private var colorMaterial:ColorMaterial;
		private var plane:Plane;
		
		public function PaperVision3d_3()
		{
			super();
			init();
		}
		
		private function init():void
		{
			initPapervision();
			initMaterials();
			initObjects();
			initListeners();
		}
		
		private function initPapervision():void
		{
			viewport = new Viewport3D();
			addChild(viewport);
			
			scence = new Scene3D();
			camera = new Camera3D();
			renderer = new BasicRenderEngine();
		}
		
		private function initMaterials():void
		{
			//three parameters 
			//the value the color, alpha, and interactive
			colorMaterial = new ColorMaterial(0xFF0000, 0.9, false);
			colorMaterial.doubleSided = true;
		}
		
		private function initObjects():void
		{
			plane = new Plane(colorMaterial);
			scence.addChild(plane);
		}
		
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, handleEnterFrameEvent);
		}
		
		//add EnterFrame Event Listener to let the plane move		
		private function handleEnterFrameEvent(event:Event):void
		{
//			plane.yaw(2);
			plane.rotationY += 2;
			renderer.renderScene(scence, camera, viewport);
		}
			
		
	}
}