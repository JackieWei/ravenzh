package
{
	import com.CPodContainer;
	
	import flash.events.Event;
	
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;

	[SWF (backgroundColor="0x000000")]
	public class CPod extends BasicView
	{
		private var baseObject:DisplayObject3D;
		private var cpodContainer:CPodContainer;

		public function CPod(viewportWidth:Number=640, viewportHeight:Number=480, scaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target")
		{
			super(viewportWidth, viewportHeight, scaleToStage, interactive, cameraType);
			init();
			startRendering();
		}
		
		private function init():void
		{
			baseObject = new DisplayObject3D();
			baseObject.rotationX = 180;
			baseObject.rotationZ = 90;
			cpodContainer = new CPodContainer();
			cpodContainer.attachTo(baseObject);

			scene.addChild(baseObject);
			
			camera.zoom = 100;
			for each(var prop:String in camera)
			{
				trace(prop);
			}
			
		}
		
		override protected function onRenderTick(event:Event=null):void
		{
			super.onRenderTick(event);
		}
		
	}
}