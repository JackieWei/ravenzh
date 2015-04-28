package
{
	import com.CPodContainer;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	[SWF (backgroundColor="#000000", framerate="31")]
	public class ARcPod extends FLARVision
	{
		private var label:TextField;
		private static const defaultText:String = "Click to change to debug mode - Debug is currently to ";
		
		public function ARcPod()
		{
			super();
		}
		
		override protected function initStage():void
		{
			super.initStage();
			stage.addEventListener(MouseEvent.CLICK, handleStageClickEvent);
		}
		
		private function handleStageClickEvent(event:MouseEvent):void
		{
			switchSource();
		}
		
		override protected function init3DObject():void
		{
			super.init3DObject();
			var cPod:CPodContainer = new CPodContainer();
			cPod.attachTo(baseNode);
		}
		
		override protected function init3DScene():void
		{
			super.init3DScene();
			createDebugDisplay();
		}
		
		private function createDebugDisplay():void
		{
		   	label = new TextField();
   			label.defaultTextFormat = new TextFormat("Arial", 12, 0x000000, true);
   			label.autoSize = "left";
   			label.selectable = false;
   			label.background = true;
   			label.text = defaultText + debug;
   			addChild(label);
		}
		
		private function switchSource():void
		{
			if (debug)
			{
				if (contains(emulatorCard))
				{
					removeChild(emulatorCard);
					emulatorCard = null;
				}
			}
			else
			{
				video = null;
    			webcam = null;	
			}
			
			debug = !debug;
			label.text = defaultText + debug;
			initWebCam();
		}
	}
}

