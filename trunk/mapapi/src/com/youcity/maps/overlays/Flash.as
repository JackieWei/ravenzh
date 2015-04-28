package com.youcity.maps.overlays
{
	import com.youcity.maps.ScreenPoint;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	/**
	 * 
	 * @author raven
	 * 
	 */
	public final class Flash extends OverlayBase 
	{
		private static const BALLOON:String ="assets/flash/balloon.swf";
		
	 	public function Flash(point:ScreenPoint)
	 	{
	 		super(this, point);
	 	}
	 	
	 	override protected function draw():void
	 	{
	 		var loader:Loader = new Loader();
	 		loader.load(new URLRequest(BALLOON));
	 		
			this.addChild(loader);
		}
	}
}
