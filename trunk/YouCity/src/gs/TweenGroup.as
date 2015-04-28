/*
VERSION: 0.8
DATE: 10/4/2008
ACTIONSCRIPT VERSION: 3.0 (AS2 version is also available)
UPDATES & MORE DETAILED DOCUMENTATION AT: http://blog.greensock.com/tweengroup/
DESCRIPTION:
	TweenGroup is a very powerful, flexible tool for managing groups of TweenLite/TweenFilterLite/TweenMax tweens.
	Here are a few of the features:
		
		- pause(), resume(), reverse(), or restart() the group as a whole. This is an easy way to add
		  these capabilities to TweenLite instances without the extra Kb of TweenMax!
		  
		- Treat a TweenGroup instance just like an Array, so you can push(), splice(), unshift(), pop(),
		  slice(), shift(), loop through the elements, access them directly like myGroup[1], and set them directly 
		  like myGroup[2] = new TweenLite(mc, 1, {x:300}) and it'll automatically adjust the timing
		  of the tweens in the group to honor the alignment and staggering effects you set with 
		  the "align" and "stagger" properties (more on that next...)
		  
		- Easily set the alignment of the tweens inside the group, like:
				- myGroup.align = TweenGroup.ALIGN_SEQUENCE; //stacks them end-to-end, one after the other
				- myGroup.align = TweenGroup.ALIGN_START; //tweens will start at the same time
				- myGroup.align = TweenGroup.ALIGN_END; //tweens will end at the same time
				- myGroup.align = TweenGroup.ALIGN_INIT; //same as ALIGN_START except that it honors any delay set in each tween.
				- myGroup.align = TweenGroup.ALIGN_NONE; //no special alignment
				
		- Stagger aligned tweens by a set amount of time (in seconds). For example, if the stagger value is 0.5 and 
		  the align property is set to ALIGN_START, the second tween will start 0.5 seconds after the first one starts, 
		  then 0.5 seconds later the third one will start, etc. If the align property is ALIGN_SEQUENCE, there would 
		  be 0.5 seconds added between each tween.
		  
		- Have precise control over the progress of the group by getting/setting the "progress" property anytime. 
		  For example, to skip to half-way through the entire group of tweens, simply do this:
		  		myGroup.progress = 0.5
		  You can even tween the progress property with another tween to fastforward/rewind an entire group!
		  
		- Only about 3.5Kb added to your SWF.
		
		- Performance-wise, TweenGroup has no effect whatsoever on the actual rendering speed of the tweens it
		  contains, so you don't have to worry about lots of extra overhead. TweenGroup only uses CPU cycles
		  when you perform management tasks (getting/setting properties or calling methods).
		
	At first glance, it may be difficult to see the value of using TweenGroup, but once you wrap your head around
	it, you'll probably find all kinds of uses for it and wonder how you lived without it. For example, what if you 
	have a menu that flies out and unfolds using several sequenced tweens but when the user clicks elsewhere, you 
	want the menu to fold back into place. With TweenGroup, it's as simple as calling myGroup.reverse(). Or if you
	have a bunch of tweens that play and then you want to loop them back to the beginning, just call myGroup.restart()
	or set myGroup.progress = 0. 
	

METHODS:
	- pause():void
	- resume():void
	- restart(includeDelay:Boolean):void
	- reverse(forcePlay:Boolean):void
	- getActive():Array
	- updateTimeSpan():void
	- clear(killTweens:Boolean):void
	

PROPERTIES:
	- length : uint
	- progress : Number	
	- progressWithDelay : Number
	- paused : Boolean
	- reversed : Boolean
	- duration : Number
	- durationWithDelay : Number
	- align : String
	- stagger : Number
	

EXAMPLES: 
	
	To set up a simple sequence of 3 tweens that should be sequenced one after the other:
		
		import gs.*;
		
		OverwriteManager.init(OverwriteManager.AUTO); //AUTO mode ensures that only overlapping tweens of the same property are overwritten. If you prefer, however, you can manage this manually with the "overwrite" special property on each tween.
		
		var tween1:TweenLite = new TweenLite(mc, 1, {x:300});
		var tween2:TweenLite = new TweenLite(mc, 3, {y:400});
		var tween3:TweenMax = new TweenMax(mc, 2, {blurFilter:{blurX:10, blurY:10}});
		
		var myGroup:TweenGroup = new TweenGroup([tween1, tween2, tween3]);
		myGroup.align = TweenGroup.ALIGN_SEQUENCE;
		
		
	Or if you don't mind all your tweens being the same type (TweenMax in this case as opposed to TweenLite or TweenFilterLite), 
	you can do the same thing in less code like this:
	
		var myGroup:TweenGroup = new TweenGroup([{target:mc, time:1, x:300}, {target:mc, time:3, y:400}, {target:mc, time:2, blurFilter:{blurX:10, blurY:10}}], TweenMax, TweenGroup.ALIGN_SEQUENCE);
	
	
	If you have an existing TweenGroup that you'd like to splice() a new tween into, it's as simple as:
		
		myGroup.splice(2, 0, new TweenLite(mc, 3, {alpha:0.5}));
	
	
	To pause the group and skip to half-way through the overall progress, do:
		
		myGroup.pause();
		myGroup.progress = 0.5;
	

NOTES:
	- This class adds about 3.5kb to your SWF (in addition to TweenLite which is about 3kb)
	- The TweenMax.sequence() and TweenMax.multiSequence() methods have been deprecated in favor of
	  using TweenGroup because it is far more powerful and flexible. 
	- When you remove a tween from a group or replace it, that tween does NOT get killed automatically.
	  It will continue to run, so you need to use TweenLite.removeTween() to kill it.
	- If you're running into problems with tweens simply not playing, it may be an overwriting issue. 
	  Check out http://blog.greensock.com/overwritemanager/ for help.
	- This is a brand new class, so please check back regularly for updates and let me know if
	  you run into any bugs/problems.
	  

CODED BY: Jack Doyle, jack@greensock.com
Copyright 2008, GreenSock (This work is subject to the terms in http://www.greensock.com/terms_of_use.html.)
*/

package gs {
	import flash.utils.*;
	
	import gs.TweenLite;

	dynamic public class TweenGroup extends Proxy {
		public static const version:Number = 0.8;
		public static const ALIGN_INIT:String = "init";
		public static const ALIGN_START:String = "start";
		public static const ALIGN_END:String = "end";
		public static const ALIGN_SEQUENCE:String = "sequence";
		public static const ALIGN_NONE:String = "none";
		protected static var _TweenFilterLite:Class;
		protected static var _TweenMax:Class;
		protected static var _classInitted:Boolean;
		protected var _tweens:Array;
		protected var _pauseTime:int;
		protected var _startTime:Number; //time at which the first tween in the group begins (AFTER any delay)
		protected var _endTime:Number; //time at which the last tween finishes
		protected var _initTime:Number; //same as _startTime except it factors in the delay, so it's basically _startTime minus the first tween's delay.
		protected var _reversed:Boolean;
		protected var _align:String;
		protected var _stagger:Number; //time (in seconds) to stagger each tween in the group/sequence
		
		/**
		 * Constructor 
		 * 
		 * @param $tweens An Array of either TweenLite/TweenFilterLite/TweenMax instances or Objects each containing at least a "target" and "time" property, like [{target:mc, time:2, x:300},{target:mc2, time:1, alpha:0.5}]
		 * @param $DefaultTweenClass Defines which tween class should be used when parsing objects that are not already TweenLite/TweenFilterLite/TweenMax instances. Choices are TweenLite, TweenFilterLite, or TweenMax.
		 * @param $align Controls the alignment of the tweens within the group. Options are TweenGroup.ALIGN_SEQUENCE, TweenGroup.ALIGN_START, TweenGroup.ALIGN_END, TweenGroup.ALIGN_INIT, or TweenGroup.ALIGN_NONE
		 * @param $stagger Amount of time (in seconds) to offset each tween according to the current alignment. For example, if the align property is set to ALIGN_SEQUENCE and stagger is 0.5, this adds 0.5 seconds between each tween in the sequence. If align is set to ALIGN_START, it would add 0.5 seconds to the start time of each tween (0 for the first tween, 0.5 for the second, 1 for the third, etc.)
		 * */
		public function TweenGroup($tweens:Array=null, $DefaultTweenClass:Class=null, $align:String="none", $stagger:Number=0) {
			super();
			if (!_classInitted) {
				if (TweenLite.version < 9) {
					trace("TweenGroup error! Please update your TweenLite class or try deleting your ASO files. TweenGroup requires a more recent version. Download updates at http://www.TweenLite.com.");
				}
				try {
					_TweenMax = (getDefinitionByName("gs.TweenMax") as Class); //Checking "if (tween is _TweenMax)" is twice as fast as "if (tween.hasOwnProperty("combinedTimeScale"))". Storing a reference to the class this way prevents us from having to import the whole TweenMax class, thus saves a lot of Kb.
				} catch ($e:Error) {
					_TweenMax = Array;
				}
				try {
					_TweenFilterLite = (getDefinitionByName("gs.TweenFilterLite") as Class);//Checking "if (tween is TweenFilterLite)" is twice as fast as "if (tween.hasOwnProperty("combinedTimeScale"))". Storing a reference to the class this way prevents us from having to import the whole TweenFilterLite class, thus saves a lot of Kb.
				} catch ($e:Error) {
					_TweenFilterLite = Array;
				}
				_classInitted = true;
			}
			_pauseTime = -1;
			_align = $align;
			_stagger = $stagger;
			if ($tweens != null) {
				_tweens = parse($tweens, $DefaultTweenClass);
				updateTimeSpan();
				realign();
			} else {
				_tweens = [];
				_initTime = _startTime = _endTime = 0;
			}
		}
		
		
//---- PROXY FUNCTIONS ------------------------------------------------------------------------------------------
				
		flash_proxy override function callProperty($name:*, ...$args:Array):* {
			var returnValue:* = _tweens[$name].apply(null, $args);
			realign();
			return returnValue;
		}
		
		flash_proxy override function getProperty($prop:*):* {
			return _tweens[$prop];
		}
		
		flash_proxy override function setProperty($prop:*, $value:*):void {
			onSetProperty($prop, $value);
		}
		
		protected function onSetProperty($prop:*, $value:*):void {
			if (!isNaN($prop) && !($value is TweenLite)) {
				trace("TweenGroup error: an attempt was made to add a non-TweenLite element.");
			} else {
				_tweens[$prop] = $value;
				realign();
			}
		}
		
		
//---- PUBLIC FUNCTIONS ----------------------------------------------------------------------------------------
		
		/**
		 * Pauses the entire group of tweens
		 */
		public function pause():void {
			if (_pauseTime == -1) {
				_pauseTime = TweenLite.currentTime;
				for (var i:int = _tweens.length - 1; i > -1; i--) {
					if (_tweens[i] is _TweenMax) {
						_tweens[i].pause();
					} else {
						_tweens[i].startTime = 99999999999; //for OverwriteManager
						TweenLite.removeTween(_tweens[i], false);
					}
				}
			}
		}
		
		/**
		 * Resumes the entire group of tweens
		 */
		public function resume():void {
			if (_pauseTime != -1) {
				var offset:Number = (TweenLite.currentTime - _pauseTime) / 1000;
				var a:Array = []; //store only the TweenLite and TweenFilterLite instances in this Array because TweenMax instances already have a resume().
				for (var i:int = _tweens.length - 1; i > -1; i--) {
					if (_tweens[i] is _TweenMax) {
						_tweens[i].resume();
					} else {
						_tweens[i].startTime = _tweens[i].initTime + (_tweens[i].delay * 1000);
						a[a.length] = _tweens[i];
					}
				}
				_pauseTime = -1;
				offsetTime(a, offset);
			}
		}
		
		/**
		 * Restarts the entire group of tweens, optionally including any delay from the first tween.
		 *  
		 * @param $includeDelay If true, any delay from the first tween (chronologically) is taken into account. 
		 */
		public function restart($includeDelay:Boolean=false):void {
			setProgress(0, $includeDelay);
			resume();
		}
		
		/**
		 * Reverses the entire group of tweens so that they appear to run backwards. If the group of tweens is partially finished when reverse() 
		 * is called, the timing is automatically adjusted so that no skips/jumps occur. For example, if the entire group of tweens would take 
		 * 10 seconds to complete (start to finish), and you call reverse() after 8 seconds, it will run the tweens backwards for another 8 seconds
		 * until the values are back to where they began. You may call reverse() as many times as you want and it will keep flipping the direction.
		 * So if you call reverse() twice, the group of tweens will be back to the original (forward) direction. 
		 * 
		 * @param $forcePlay Forces the group to resume() if it hasn't completed yet or restart() if it has.
		 */
		public function reverse($forcePlay:Boolean=true):void {
			_reversed = !_reversed;
			var i:int, tween:TweenLite, proxy:ReverseProxy, endTime:Number, prog:Number, timeScale:Number, timeOffset:Number = 0, isFinished:Boolean = false;
			var time:Number = (_pauseTime != -1) ? _pauseTime : TweenLite.currentTime;
			if (_endTime < time) {
				timeOffset = (_startTime - time) - (time - _endTime); //if the group has finished tweening, we don't want it to reverse() and start playing again, so we offset the time values back to where they should be
				isFinished = true;
			}
			for (i = _tweens.length - 1; i > -1; i--) {
				tween = _tweens[i];
				
				if (tween is _TweenMax) { //TweenMax instances already have a "reverseEase()" function. I don't us "if (tween is TweenMax)" because it would bloat the file size by having to import TweenMax, so developers can just use this class with TweenLite to keep file size to a minimum if they so choose.
					(tween as Object).reverse(false);
				} else if (tween.ease != tween.vars.ease) {
					tween.ease = tween.vars.ease;
				} else {
					proxy = new ReverseProxy(tween);
					tween.ease = proxy.reverseEase;
				}
				
				if (tween is _TweenFilterLite) {
					timeScale = (tween as Object).combinedTimeScale;
					prog = (((time - tween.initTime) / 1000) - tween.delay / timeScale) / tween.duration * timeScale;
					tween.startTime = time - ((1 - prog) * tween.duration * 1000 / timeScale) + timeOffset;
					tween.initTime = tween.startTime - (tween.delay * (1000 / timeScale));
				} else {
					prog = (((time - tween.initTime) / 1000) - tween.delay) / tween.duration;
					tween.startTime = time - ((1 - prog) * tween.duration * 1000) + timeOffset;
					tween.initTime = tween.startTime - (tween.delay * 1000);
				}
				
				if (getEndTime(tween) >= time) {
					enableTween(tween); //make sure they're in the rendering queue in case they were already completed!
				}
				if (tween.startTime > time) { //don't allow tweens with delays that haven't expired yet to be active
					tween.forceActive = false;
				}
				
			}
			updateTimeSpan();
			if ($forcePlay) {
				if (isFinished) {
					restart();
				} else {
					resume();
				}
			}
		}
		
		/**
		 * Provides an easy way to determine which tweens (if any) are currently active. Active tweens are not paused and are in the process of tweening values.
		 * 
		 * @return An Array of TweenLite/TweenFilterLite/TweenMax instances from the group that are currently active (in the process of tweening)
		 */
		public function getActive():Array {
			var a:Array = [];
			if (_pauseTime == -1) {
				var i:int, time:Number = TweenLite.currentTime;
				for (i = _tweens.length - 1; i > -1; i--) {
					if (_tweens[i].startTime <= time && getEndTime(_tweens[i]) >= time) {
						a[a.length] = _tweens[i];
					}				
				}
			}
			return a;
		}
		
		/**
		 * Removes all tweens from the group and kills the tweens using TweenLite.removeTween()
		 * 
		 * @param $killTweens Determines whether or not all of the tweens are killed (as opposed to simply being removed from this group but continuing to remain in the rendering queue)
		 */
		public function clear($killTweens:Boolean=true):void {
			for (var i:int = _tweens.length - 1; i > -1; i--) {
				if ($killTweens) {
					TweenLite.removeTween(_tweens[i], true);
				}
				_tweens[i] = null;
				_tweens.splice(i, 1);
			}
		}
		
		/**
		 * Parses an Array that contains either TweenLite/TweenFilterLite/TweenMax instances or Objects that are meant to define tween instances.
		 * Specifically, they must contain at LEAST "target" and "time" properties. For example: TweenGroup.parse([{target:mc1, time:2, x:300},{target:mc2, time:1, y:400}]);
		 *  
		 * @param $tweens An Array of either TweenLite/TweenFilterLite/TweenMax instances or Objects that are meant to define tween instances. For example [{target:mc1, time:2, x:300},{target:mc2, time:1, y:400}]
		 * @param $BaseTweenClass Defines which tween class should be used when parsing objects that are not already TweenLite/TweenFilterLite/TweenMax instances. Choices are TweenLite, TweenFilterLite, or TweenMax.
		 * @return An Array with only TweenLite/TweenFilterLite/TweenMax instances
		 */
		public static function parse($tweens:Array, $DefaultTweenClass:Class=null):Array {
			if ($DefaultTweenClass == null) {
				$DefaultTweenClass = TweenLite;
			}
			var a:Array = [], i:int, target:Object, duration:Number;
			for (i = 0; i < $tweens.length; i++) {
				if ($tweens[i] is TweenLite) {
					a[a.length] = $tweens[i];
				} else {
					target = $tweens[i].target;
					duration = $tweens[i].time;
					delete $tweens[i].target;
					delete $tweens[i].time;
					a[a.length] = new $DefaultTweenClass(target, duration, $tweens[i]);
				}
			}
			return a;
		}
		
		/** 
		 * Analyzes all of the tweens in the group and determines the overall init, start, and end times as well as the overall duration which 
		 * are necessary for accurate management. Normally a TweenGroup handles this internally, but if tweens are manipulated independently
		 * of TweenGroup or if a tween has its "loop" or "yoyo" special property set to true, it can cause these variables to become uncalibrated
		 * in which case you can use updateTimeSpan() to recalibrate. 
		 */
		public function updateTimeSpan():void {
			var i:int, start:Number, init:Number, end:Number, tween:TweenLite, timeScale:Number;
			if (_tweens.length == 0) {
				_endTime = _startTime = _initTime = 0;
			} else {
				tween = _tweens[0];
				_initTime = tween.initTime;
				if (tween is _TweenFilterLite) {
					timeScale = (tween as Object).combinedTimeScale;
					_startTime = _initTime + (tween.delay * (1000 / timeScale));
					_endTime = _startTime + (tween.duration * (1000 / timeScale));
				} else {
					_startTime = _initTime + (tween.delay * 1000);
					_endTime = _startTime + (tween.duration * 1000);
				}
				
				for (i = _tweens.length - 1; i > 0; i--) {
					tween = _tweens[i];
					init = tween.initTime;
					if (tween is _TweenFilterLite) { //TweenFilterLite and TweenMax must take into account the timeScale. I don't say "if (tween is TweenMax)" because it would necessitate importing TweenMax which requires more Kb and many developers will only use this class with TweenLite to conserve file size.
						timeScale = (tween as Object).combinedTimeScale;
						start = init + (tween.delay * (1000 / timeScale));
						end = start + (tween.duration * (1000 / timeScale));
					} else {
						start = init + (tween.delay * 1000);
						end = start + (tween.duration * 1000);
					}
					if (init < _initTime) {
						_initTime = init;
					}
					if (start < _startTime) {
						_startTime = start;
					}
					if (end > _endTime) {
						_endTime = end;
					}
				}
			}
		}
		
		
//---- PROTECTED FUNCTIONS ---------------------------------------------------------------------------------------
		
		protected function realign():void {
			if (_align != ALIGN_NONE && _tweens.length > 1) {
				var l:uint = _tweens.length, i:int, offset:Number = _stagger * 1000;
				
				if (_align == ALIGN_SEQUENCE) {
					setTweenInitTime(_tweens[0], _initTime);
					for (i = 1; i < l; i++) {
						setTweenInitTime(_tweens[i], getEndTime(_tweens[i - 1]) + (offset * i));
					}
					
				} else if (_align == ALIGN_INIT) {
					for (i = 0; i < l; i++) {
						setTweenInitTime(_tweens[i], _initTime + (offset * i));
					}
					
				} else if (_align == ALIGN_START) {
					for (i = 0; i < l; i++) {
						setTweenStartTime(_tweens[i], _startTime + (offset * i));
					}
					
				} else { //ALIGN_END
					for (i = 0; i < l; i++) {
						if (_tweens[i] is _TweenFilterLite) {
							setTweenInitTime(_tweens[i], _endTime - ((_tweens[i].delay + _tweens[i].duration) * 1000 / _tweens[i].combinedTimeScale) - (offset * i));
						} else {
							setTweenInitTime(_tweens[i], _endTime - ((_tweens[i].delay + _tweens[i].duration) * 1000) - (offset * i));
						}
					}
				}
				
			}
			updateTimeSpan();
		}
		
		protected function offsetTime($tweens:Array, $offset:Number):void {
			var ms:Number = $offset * 1000; //offset in milliseconds
			var time:Number = (_pauseTime == -1) ? TweenLite.currentTime : _pauseTime;
			var tweens:Array = getRenderOrder($tweens, time);
			var isPaused:Boolean, tween:TweenLite, renderTime:Number, endTime:Number, i:int, timeScale:Number;
			for (i = tweens.length - 1; i > -1; i--) {
				tween = tweens[i];
				tween.initTime += ms;
				isPaused = Boolean(tween.startTime == 99999999999);
				if (tween is _TweenFilterLite) {
					tween.startTime = tween.initTime + (tween.delay * (1000 / (tween as Object).combinedTimeScale)); //this forces paused tweens with false start times to adjust to the normal one temporarily so that we can render it properly.
				} else {
					tween.startTime = tween.initTime + (tween.delay * 1000); //this forces paused tweens with false start times to adjust to the normal one temporarily so that we can render it properly.
				}
				endTime = getEndTime(tween);
				
				if (_pauseTime == -1 && endTime >= time) {
					enableTween(tween); //make sure they're in the rendering queue in case they were already completed!
				}
				if (tween.startTime > time) { //don't allow tweens with delays that haven't expired yet to be active
					tween.forceActive = false;
				}
				if ((tween.startTime <= time || tween.startTime - ms <= time) && (endTime >= time || endTime - ms >= time)) { //only render what's necessary
					renderTween(tween, time);
				}
				
				if (isPaused) {
					tween.startTime = 99999999999;
				}
			}
			if (tweens.length != 0) {
				_endTime += ms;
				_startTime += ms;
				_initTime += ms;
			}
		}
		
		/**
		 * If there are multiple tweens in the same group that control the same property of the same property, we need to make sure they're rendered in the correct
		 * order so that the one(s) closest in proximity to the current time is rendered last. Feed this function an Array of tweens and the time and it'll return
		 * an Array with them in the correct render order.
		 *  
		 * @param $tweens An Array of tweens to get in the correct render order
		 * @param $time Time (in milliseconds) which defines the proximity point for each tween (typically the render time)
		 * @return An Array with the tweens in the correct render order
		 */
		protected function getRenderOrder($tweens:Array, $time:Number):Array {
			var i:int, tween:TweenLite, postTweens:Array = [], preTweens:Array = [], a:Array = [];
			for (i = $tweens.length - 1; i > -1; i--) {
				if ($tweens.startTime >= $time) {
					postTweens[postTweens.length] = {start:$tweens[i].startTime, tween:$tweens[i]};
				} else {
					preTweens[preTweens.length] = {end:getEndTime($tweens[i]), tween:$tweens[i]};
				}
			}
			postTweens.sortOn("start", Array.NUMERIC);
			preTweens.sortOn("end", Array.NUMERIC | Array.DESCENDING);
			for (i = postTweens.length - 1; i > -1; i--) {
				a[i] = postTweens[i].tween;
			}
			for (i = preTweens.length - 1; i > -1; i--) {
				a[a.length] = preTweens[i].tween;
			}
			return a;
		}
		
		protected function renderTween($tween:TweenLite, $time:Number):void {
			var endTime:Number = getEndTime($tween), tempInit:Boolean, renderTime:Number, originalStart:Number;
			if (!$tween.initted) {
				if ($tween is _TweenMax && ($tween as Object).paused) {
					$tween.initTweenVals();
					if ($tween.vars.onStart != null) {
						$tween.vars.onStart.apply(null, $tween.vars.onStartParams);
					}
				} else {
					tempInit = $tween.active; //triggers the initTweenVals and fires the onStart() if necessary
				}
			}
			
			if ($tween.startTime > $time) { //don't allow tweens with delays that haven't expired yet to be active
				renderTime = $tween.startTime;
			} else if (endTime < $time) {
				renderTime = endTime;
			} else {
				renderTime = $time;
			}
			
			if (renderTime < 0) { //render time is uint, so it must be zero or greater. 
				originalStart = $tween.startTime;
				$tween.startTime -= renderTime;
				$tween.render(0);
				$tween.startTime = originalStart;
			} else {
				$tween.render(renderTime);
			}
		}
		
		protected function getEndTime($tween:TweenLite):Number {
			if ($tween is _TweenFilterLite) {
				return $tween.initTime + (($tween.delay + $tween.duration) * (1000 / ($tween as Object).combinedTimeScale));
			} else {
				return $tween.initTime + (($tween.delay + $tween.duration) * 1000);
			}
		}
		
		protected function getStartTime($tween:TweenLite):Number {
			if ($tween is _TweenFilterLite) {
				return $tween.initTime + ($tween.delay * 1000 / ($tween as Object).combinedTimeScale);
			} else {
				return $tween.initTime + ($tween.delay * 1000);
			}
		}
		
		protected function setTweenInitTime($tween:TweenLite, $initTime:Number):void {
			var offset:Number = $initTime - $tween.initTime;
			$tween.initTime = $initTime;
			if ($tween.startTime != 99999999999) { //required for OverwriteManager (indicates a tween has been paused)
				$tween.startTime += offset;
			}
		}
		
		protected function setTweenStartTime($tween:TweenLite, $startTime:Number):void {
			var offset:Number = $startTime - getStartTime($tween);
			$tween.initTime -= offset;
			if ($tween.startTime != 99999999999) { //required for OverwriteManager (indicates a tween has been paused)
				$tween.startTime = $startTime;
			}
		}
		
		protected function enableTween($tween:TweenLite):void {
			var m:Dictionary = TweenLite.masterList;
			if (m[$tween.target] == undefined) {
				m[$tween.target] = new Dictionary(true);
			}
			m[$tween.target][$tween] = $tween;
			if ($tween is _TweenFilterLite) {
				($tween as Object).timeScale *= 1; //Just forces it to combine with the globalTimeScale in case it changed since it was dropped from the master list.
			}
		}
		
		protected function getProgress($includeDelay:Boolean=false):Number {
			if (_tweens.length == 0) {
				return 0;
			} else {
				var time:Number = (_pauseTime == -1) ? TweenLite.currentTime : _pauseTime;
				var min:Number = ($includeDelay) ? _initTime : _startTime;
				var p:Number = ((time / 1000) - min) / (_endTime - min);
				if (p < 0) {
					return 0;
				} else if (p > 1) {
					return 1;
				} else {
					return p;
				}
			}
		}
		
		protected function setProgress($progress:Number, $includeDelay:Boolean=false):void {
			if (_tweens.length != 0) {
				var time:Number = (_pauseTime == -1) ? TweenLite.currentTime : _pauseTime;
				var min:Number = ($includeDelay) ? _initTime : _startTime;
				offsetTime(_tweens, (time - (min + ((_endTime - min) * $progress))) / 1000);
			}
		}
		
		
//---- GETTERS / SETTERS --------------------------------------------------------------------------------------------------
		
		/**
		 * @return Number of tweens in the group 
		 */
		public function get length():uint {
			return _tweens.length;
		}
		
		/**
		 * @return Overall progress of the group of tweens (not including any initial delay) as represented numerically between 0 and 1 where 0 means the group hasn't started, 0.5 means it is halfway finished, and 1 means it has completed.
		 */
		public function get progress():Number {
			return getProgress(false);
		}
		/**
		 * Controls the overall progress of the group of tweens (not including any initial delay) as represented numerically between 0 and 1.
		 * 
		 * @param $n Overall progress of the group of tweens (not including any initial delay) as represented numerically between 0 and 1 where 0 means the group hasn't started, 0.5 means it is halfway finished, and 1 means it has completed.
		 */
		public function set progress($n:Number):void {
			setProgress($n, false);
		}
		
		/**
		 * @return Overall progress of the group of tweens (including any initial delay) as represented numerically between 0 and 1 where 0 means the group hasn't started, 0.5 means it is halfway finished, and 1 means it has completed.
		 */
		public function get progressWithDelay():Number {
			return getProgress(true);
		}
		/**
		 * Controls the overall progress of the group of tweens (including any initial delay) as represented numerically between 0 and 1.
		 * 
		 * @param $n Overall progress of the group of tweens (including any initial delay) as represented numerically between 0 and 1 where 0 means the group hasn't started, 0.5 means it is halfway finished, and 1 means it has completed.
		 */
		public function set progressWithDelay($n:Number):void {
			setProgress($n, true);
		}
		
		/**
		 * @return Duration (in seconds) of the group of tweens NOT including any initial delay
		 */
		public function get duration():Number {
			if (_tweens.length == 0) {
				return 0;
			} else {
				return (_endTime - _startTime) / 1000;
			}
		}
		/**
		 * @return Duration (in seconds) of the group of tweens including any initial delay
		 */
		public function get durationWithDelay():Number {
			if (_tweens.length == 0) {
				return 0;
			} else {
				return (_endTime - _initTime) / 1000;
			}
		}
		
		/**
		 * @return If the group of tweens is paused, this value will be true. Otherwise, it will be false.
		 */
		public function get paused():Boolean {
			return (_pauseTime != -1);
		}
		/**
		 * Sets the paused state of the group of tweens
		 * 
		 * @param $b Sets the paused state of the group of tweens.
		 */
		public function set paused($b:Boolean):void {
			if ($b) {
				pause();
			} else {
				resume();
			}
		}
		
		/**
		 * @return If the group of tweens is reversed, this value will be true. Otherwise, it will be false.
		 */
		public function get reversed():Boolean {
			return _reversed;
		}
		/**
		 * Sets the reversed state of the group of tweens
		 * 
		 * @param $b Sets the reversed state of the group of tweens.
		 */
		public function set reversed($b:Boolean):void {
			if (_reversed != $b) {
				reverse();
			}
		}
		
		/**
		 * @return Alignment of the tweens within the group. possible values are "sequence", "start", "end", "init", and "none"
		 */
		public function get align():String {
			return _align;
		}
		/**
		 * Controls the alignment of the tweens within the group. Typically it's best to use the constants TweenGroup.ALIGN_SEQUENCE, TweenGroup.ALIGN_START, TweenGroup.ALIGN_END, TweenGroup.ALIGN_INIT, or TweenGroup.ALIGN_NONE
		 * 
		 * @param $s Sets the alignment of the tweens within the group. Typically it's best to use the constants TweenGroup.ALIGN_SEQUENCE, TweenGroup.ALIGN_START, TweenGroup.ALIGN_END, TweenGroup.ALIGN_INIT, or TweenGroup.ALIGN_NONE
		 */
		public function set align($s:String):void {
			_align = $s;
			realign();
		}
		
		/**
		 * @return Amount of time (in seconds) to offset each tween according to the current alignment. For example, if the align property is set to ALIGN_SEQUENCE and stagger is 0.5, this adds 0.5 seconds between each tween in the sequence. If align is set to ALIGN_START, it would add 0.5 seconds to the start time of each tween (0 for the first tween, 0.5 for the second, 1 for the third, etc.)
		 */
		public function get stagger():Number {
			return _stagger;
		}
		/**
		 * Controls the amount of time (in seconds) to offset each tween according to the current alignment. For example, if the align property is set to ALIGN_SEQUENCE and stagger is 0.5, this adds 0.5 seconds between each tween in the sequence. If align is set to ALIGN_START, it would add 0.5 seconds to the start time of each tween (0 for the first tween, 0.5 for the second, 1 for the third, etc.)
		 * 
		 * @param $s Amount of time (in seconds) to offset each tween according to the current alignment. For example, if the align property is set to ALIGN_SEQUENCE and stagger is 0.5, this adds 0.5 seconds between each tween in the sequence. If align is set to ALIGN_START, it would add 0.5 seconds to the start time of each tween (0 for the first tween, 0.5 for the second, 1 for the third, etc.)
		 */
		public function set stagger($n:Number):void {
			_stagger = $n;
			realign();
		}
		
	}
}
	
import gs.TweenLite;

internal class ReverseProxy {
	private var _tween:TweenLite;
	
	public function ReverseProxy($tween:TweenLite) {
		_tween = $tween;
	}
	
	public function reverseEase($t:Number, $b:Number, $c:Number, $d:Number):Number {
		return _tween.vars.ease($d - $t, $b, $c, $d);
	}
	
}