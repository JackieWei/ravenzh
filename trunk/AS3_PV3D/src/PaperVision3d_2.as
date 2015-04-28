package
{
	import flash.display.Sprite;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	
	/**
	 * 
	 * @author Administrator
	 * Second Papervision Example 
	 * It's about how to user material to the Plane Object
	 */	
	public class PaperVision3d_2 extends Sprite
	{
		private var viewport:Viewport3D;
		private var scence:Scene3D;
		private var camera:Camera3D;
		private var renderer:BasicRenderEngine;
		
		private var colorMaterial:ColorMaterial;
		private var plane:Plane;
		
		public function PaperVision3d_2()
		{
			super();
			init();
		}
		
		private function init():void
		{
			initPapervision();
			initMaterials();
			initObjects();
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
		}
		
		private function initObjects():void
		{
			plane = new Plane(colorMaterial);
			scence.addChild(plane);
			
			renderer.renderScene(scence, camera, viewport);
		}
		
	}
}