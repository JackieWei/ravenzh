package 
{

	import com.raven.PhotoProxy;
	
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	   
	public class RemoteProxyExample extends Sprite 
	{
		public function RemoteProxyExample() 
		{
			super();

//			/**
//			* PhotoSearchProxy
//			*/			
//			var flickr:PhotoSearchProxy = new PhotoSearchProxy();
//			flickr.addEventListener(Event.COMPLETE, onComplete);
//			flickr.search("", "yellow");

			/**
			* PhotoProxy
			*/
			var flickr:PhotoProxy = new PhotoProxy();
			flickr.addEventListener(Event.COMPLETE, onComplete);
			flickr.getRecent();
		}
	      
		private function onComplete(event:DataEvent):void 
		{
			trace(event.data);
		}
	}
}