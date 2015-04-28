package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	
	/**
	 * 
	 * @author Administrator
	 * Fourth Papervision Example 
	 * It's about using InteractiveScence3DEvent.OBJECT_PRESS Event
	 */	
	public class PaperVision3d_4 extends Sprite
	{
		private var viewport:Viewport3D;
		private var scence:Scene3D;
		private var camera:Camera3D;
		private var renderer:BasicRenderEngine;
		
		private var colorMaterial:ColorMaterial;
		private var plane:Plane;
		
		public function PaperVision3d_4()
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
			viewport = new Viewport3D(600, 400, false, true);
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
			colorMaterial.interactive = true;
		}
		
		private function initObjects():void
		{
			plane = new Plane(colorMaterial);
			scence.addChild(plane);
		}
		
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, handleEnterFrameEvent);
			plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, handleScence3DPress);
		}
		
		//add EnterFrame Event Listener to let the plane move		
		private function handleEnterFrameEvent(event:Event):void
		{
//			plane.yaw(2);
			plane.rotationY += 2;
			renderer.renderScene(scence, camera, viewport);
		}
		
		private function handleScence3DPress(event:InteractiveScene3DEvent):void
		{
//			plane.pitch(40);
			plane.rotationY += 100;
		}
			
		
	}
}