package raven
{
	/**
	 * @author Raven
	 * Created at 2010.5.20 
	 */	
	public class SimpleTimeline extends TweenCore
	{
		protected var _firstChild:TweenCore;
		protected var _lastChild:TweenCore;
		
		public var autoRemoveChildren:Boolean;
		
		public function SimpleTimeline(vars:Object = null)
		{
			super(0, vars);
		}
		
		/**
		 * 添加Tween到TimeLine中
		 * @param tween
		 * 
		 */		
		public function addChild(tween:TweenCore):void {
			if (!tween.gc && tween.timeline) {
				tween.timeline.removeChild(tween);
			}
			tween.timeline = this;
			if (!tween.gc) {
				tween.setEnabled(true);
			}
			if (_firstChild) {
				_firstChild.prevNode = tween;
			}
			tween.nextNode = _firstChild;
			_firstChild = tween;
			tween.prevNode = null;
		}
		
		/**
		 * 移除Timeline上的Tween对象 
		 * @param tween
		 * 
		 */		
		public function removeChild(tween:TweenCore):void {
			if (tween.gc)
			return;// already removed!
			
			tween.setEnabled(false);
			if (tween.nextNode) {
				tween.nextNode.prevNode = tween.prevNode;
			} else {
				if (_lastChild == tween) {
					_lastChild = tween.prevNode;
				}
			}
			if (tween.prevNode) {
				tween.prevNode.nextNode = tween.nextNode;
			} else {
				if (_firstChild == tween) {
					_firstChild = tween.nextNode;
				}
			}
		}
		
		/**
		 * 
		 * @param time
		 * 
		 */		
		override public function renderTime(time:int, supressEvents:Boolean = false):void {
			var tween:TweenCore = _firstChild;
			var dur:Number;
			var next:TweenCore;
			this.cachedTotalTime = time;
			this.cachedTime = time;
			
			while(tween) {
				next = tween.nextNode;
				if (tween.active && time > tween.cachedStartTime && !tween.gc) {
					var actualTime:Number = (time - tween.cachedStartTime) * tween.cachedTimeScale;
					if (!tween.cachedReserved) {
						tween.renderTime(actualTime, supressEvents);
					} else {
						dur = tween.cacheIsDirty ? tween.totalDuration : tween.cachedTotalDuration; 
						tween.renderTime(dur - actualTime, supressEvents);
					}
				}
				tween = next;
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get rawTime():Number {
			return this.cachedTotalTime;
		}
		
	}
}