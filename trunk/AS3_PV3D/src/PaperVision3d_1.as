package
{
	import flash.display.Sprite;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	
	/**
	 * 
	 * @author Administrator
	 * First Papervision Example 
	 * It's about how to user the basic Papervison3D API 
	 */	
	public class PaperVision3d_1 extends Sprite
	{
		private var viewport:Viewport3D;
		private var scence:Scene3D;
		private var camera:Camera3D;
		private var renderer:BasicRenderEngine;
		
		private var plane:Plane;
		
		public function PaperVision3d_1()
		{
			super();
			init();
		}
		
		private function init():void
		{
			initPapervision();
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
		
		private function initObjects():void
		{
			plane = new Plane();
			scence.addChild(plane);
			
			renderer.renderScene(scence, camera, viewport);
		}
		
	}
}