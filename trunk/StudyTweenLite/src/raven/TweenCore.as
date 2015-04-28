package raven
{
	import flash.display.SimpleButton;
	
	/**
	 * 
	 * @author Raven
	 * Created at 2010.5.20 
	 */	
	public class TweenCore
	{
		protected static var _classInitted:Boolean;
		
		protected var _delay:Number;
		
		public var gc:Boolean;
		public var active:Boolean;
		public var vars:Object;
		public var data:*;
		
		public var cachedStartTime:Number;
		
		public var cachedDuration:Number;
		public var cachedTotalDuration:Number;
		
		public var cachedTotalTime:Number;
		
		public var cachedTime:Number;
		
		public var cachedReversed:Boolean;
		public var cachedPaused:Boolean;
		public var cachedTimeScale:Number;
		
		public var cacheIsDirty:Boolean;
		
		public var timeline:SimpleTimeline;
		public var prevNode:TweenCore;
		public var nextNode:TweenCore;
		
		//=======================================================================
		public function get duration():Number { 
			return this.cachedDuration; 
		}
		public function set duration(value:Number):void {
			this.cachedDuration = this.cachedTotalDuration = value;
			setDirtyCache(false);
		}
		
		//=======================================================================
		public function get totalDuration():Number { 
			return this.cachedTotalDuration; 
		}
		public function set totalDuration(value:Number):void { 
			this.cachedDuration = this.cachedTotalDuration = value;
		}
		
		//=======================================================================
		public function get startTime():Number {
			return this.cachedStartTime;
		}		
		public function set startTime(value:Number):void {
			var adjust:Boolean = (this.timeline != null) && (value !=  this.cachedStartTime || this.gc)
			this.cachedStartTime = value;
			if (adjust) {
				this.timeline.addChild(this);
			}
		}
		
		//=======================================================================
		public function get currentTime():Number {
			return this.cachedTime;
		}
		public function set currentTime(value:Number):void {
			setTotalTime(value, false);
		}
		
		//=======================================================================
		public function get paused():Boolean {
			return this.cachedPaused;
		}
		public function set paused(value:Boolean):void {
			//todo
		}
		
		//=======================================================================
		public function get reversed():Boolean {
			return this.cachedReversed;
		}
		public function set reversed(value:Boolean):void {
			if (value != this.cachedReversed) {
				this.cachedReversed = value;
				setTotalTime(this.cachedTotalTime, true);
			}
		}
		
		
		public function TweenCore(duration:Number = 0, vars:Object = null) {
			this.vars = vars ? vars : {};
			this.cachedDuration = this.cachedTotalDuration = duration;
			this._delay = this.vars.delay ? Number(this.vars.delay) : 0;
			this.cachedTimeScale = this.vars.timeScale ? Number(this.vars.timeScale) : 1;
			this.active = (this.duration == 0 && this._delay == 0);
			this.cachedTime = this.cachedTotalTime = 0;
			this.data = this.vars.data;
			
			if (!_classInitted) {
				if (isNaN(TweenLite.rootFrame)) {
					TweenLite.initClass();
					_classInitted = true;
				} else {
					return;
				}
			} 
			
			var tl:SimpleTimeline = (this.vars.timeline is SimpleTimeline) ? this.vars.timeline : (this.vars.useFrames ? TweenLite.rootFramesTimeline : TweenLite.rootTimeline)
			this.cachedStartTime = tl.cachedTotalTime + this._delay;
			tl.addChild(this);
			
			this.cachedReversed = this.vars.reversed;
			this.paused = this.vars.paused;
		}

		/**
		 * 播放缓动
		 * 
		 */		
		public function play():void {
			this.cachedReversed = false;
			this.paused = false;
		}
		
		/**
		 * 暂停播放 
		 * 
		 */		
		public function pause():void {
			this.paused = true;
		}
		
		/**
		 * 继续播放 
		 * 
		 */		
		public function resume():void {
			this.paused = false;
		}
		
		public function reverse(forceResumed:Boolean):void {
			//todo
		}

		/**
		 *  
		 * @param includeSelf
		 * 
		 */
		public function setDirtyCache(includeSelf:Boolean = true):void {
			var tween:TweenCore = includeSelf ? this : this.timeline;
			while (tween) {
				tween.cacheIsDirty = true;
				tween = tween.timeline;
			}
		}
		
		/**
		 * 
		 * @param time
		 * @param supressEvents
		 * 
		 */		
		public function setTotalTime(time:Number, supressEvents:Boolean = false):void {
			//todo
		}

		/**
		 *  
		 * @param enabled
		 * @return 
		 * 
		 */		
		public function setEnabled(enabled:Boolean):Boolean {
			if (enabled) {
				this.active = true;
				if (gc) {
					this.timeline.addChild(this);
				}
			} else {
				this.active = false;
				this.timeline.removeChild(this);
			}
			this.gc = !enabled;
			return false;
		}
		
		/**
		 *  
		 * @param time
		 * @param superess
		 * 
		 */		
		public function renderTime(time:int, superess:Boolean = false):void {
			//todo
		}

	}
}