package raven
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 *  
	 * @author Raven
	 * Created at 2010.5.20
	 */	
	public class TweenLite extends TweenCore
	{
		public static var rootFrame:Number;
		public static var rootTimeline:SimpleTimeline;
		public static var rootFramesTimeline:SimpleTimeline;
		public static var masterList:Dictionary = new Dictionary();
		
		
		protected static var _shape:Shape = new Shape();
		
		
		public function TweenLite(duration:Number=0, vars:Object=null) {
			super(duration, vars);
		}
		
		public static function initClass() {
			rootFrame = 0;
			rootTimeline = new SimpleTimeline();
			rootFramesTimeline = new SimpleTimeline();
			rootTimeline.cachedStartTime = getTimer() * 0.001;
			rootFramesTimeline.cachedStartTime = 0;
			rootTimeline.autoRemoveChildren = true;
			rootTimeline.autoRemoveChildren = true;
			_shape.addEventListener(Event.ENTER_FRAME, updataAll, false, 0, true);
		}
		
		protected static function updataAll(event:Event = null):void {
			var actualTime:Number = (getTimer() * 0.001 - rootTimeline.cachedStartTime ) * rootTimeline.cachedTimeScale;
			rootTimeline.renderTime(actualTime, false);
			rootFrame ++;
			actualTime = (rootFrame - rootFramesTimeline.cachedStartTime ) * rootFramesTimeline.cachedTimeScale;
			rootFramesTimeline.renderTime(actualTime, false);
			
			if (rootFrame % 60 == 0) {//gc every 60 frames
				var target:Object;
				var tweenList:Array;
				var i:int = 0;
				var length:int = 0;
				for (target in masterList) {
					tweenList = masterList[target];
					length = tweenList.length;
					while (--length > -1) {
						if (TweenLite(tweenList[i]).gc) {
							tweenList.splice(i, 1);
						}
					}
					
					if (tweenList.length == 0) {
						delete masterList[target];
					}
				}
				
			}
		}
		
	}
}