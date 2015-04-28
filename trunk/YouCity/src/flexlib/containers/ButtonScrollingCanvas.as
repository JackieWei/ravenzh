/*
Copyright (c) 2007 FlexLib Contributors.  See:
    http://code.google.com/p/flexlib/wiki/ProjectContributors

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

package flexlib.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;
	import com.youcity.website.front.view.components.controls.alert.Alert;
	import mx.controls.Button;
	import mx.core.ComponentDescriptor;
	import mx.core.IFlexDisplayObject;
	import mx.core.ScrollPolicy;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	use namespace mx_internal;
	
	public class ButtonScrollingCanvas extends Canvas
	{
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		public static const DIRECTION_VERTICAL:String = "vertical";
		
		private var _direction:String = DIRECTION_VERTICAL;
		
		[ArrayElementType(type="mx.controls.Button")]
		private var _scrollButtons:Array;
		public function set scrollButtons(value:Array):void
		{
			if (!value || 2 != value.length || !value[0] is Button || !value[1] is Button)
			{
				throw new Error("button init incorrect");
				return;
			}
			_scrollButtons = value;
		}
		
		private var _firstBtn:Button;
		private var _lastBtn:Button;
		
		private var _gap:uint = 10;
		public function set gap(value:uint):void
		{
			_gap = value;
		}
		
		private var innerCanvas:Canvas;
		
		private var timer:Timer;
		
		public var scrollSpeed:Number = 10;
	   	public var scrollJump:Number = 10;
		
		private var _childrenCreated:Boolean = false;
		
		private var _startScrollingEvent:String = MouseEvent.MOUSE_DOWN;
		
		public function get startScrollingEvent():String {
			return this._startScrollingEvent;
		}
		
		public function set startScrollingEvent(value:String):void {
			if(_childrenCreated) {
				removeListeners(_startScrollingEvent);
				addListeners(value);
			}
			_startScrollingEvent = value;
			
		}
		
		private var _stopScrollingEvent:String = MouseEvent.MOUSE_UP;
		
		public function get stopScrollingEvent():String {
			return this._stopScrollingEvent;
		}
		
		public function set stopScrollingEvent(value:String):void {
			_stopScrollingEvent = value;
		}
		
		
		public function ButtonScrollingCanvas()
		{ 
			super();
			styleName = "lockBG";
			innerCanvas = new Canvas();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			addEventListener(FlexEvent.CREATION_COMPLETE, onCompleteHandler);
		}
		
		private function onCompleteHandler(event:FlexEvent):void
		{
			setDirection(width, height);
			trace("");
		}
		
		override public function initialize():void {
			super.initialize();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			timer = new Timer(scrollSpeed);
			
			if(!_scrollButtons || _scrollButtons.length <= 0)
			{
				throw new Error("should init scroll buttons");
			}
			
			innerCanvas.document = this.document;
/* 			innerCanvas.setStyle("borderColor", 0xfafafa);
			innerCanvas.setStyle("borderStyle", "solid");
			innerCanvas.setStyle("borderThickness", "2");
			innerCanvas.setStyle("backgroundColor", 0x000000);   */
			innerCanvas.horizontalScrollPolicy = ScrollPolicy.OFF;
			innerCanvas.verticalScrollPolicy = ScrollPolicy.OFF;
			innerCanvas.clipContent = true;
			
			_firstBtn = Button(_scrollButtons[0]);
			_lastBtn = Button(_scrollButtons[1]);
			
			addChild(innerCanvas);
			addChild(_firstBtn);
			addChild(_lastBtn);
			
			_childrenCreated = true;
				
			// and of course we listen for mouseover events on our buttons.
			// if you wanted to use mousedown instead you would change these lines
			addListeners(_startScrollingEvent);
		}
		
		private var numChildrenBefore:int;
		
		override public function createComponentFromDescriptor(descriptor:ComponentDescriptor, recurse:Boolean):IFlexDisplayObject
		{
			var child:DisplayObject = DisplayObject(super.createComponentFromDescriptor(descriptor, recurse));
			innerCanvas.document = document;
			if (contains(child))
			{
				removeChild(child);
				innerCanvas.addChild(child);
			}
			return IFlexDisplayObject(child);
		}
		
		private function setDirection(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (DIRECTION_HORIZONTAL == _direction)
			{
				_firstBtn.x = 0;
				_firstBtn.y = (unscaledHeight - _firstBtn.height)/2;
				_lastBtn.x = unscaledWidth - _lastBtn.width;
				_lastBtn.y = unscaledHeight - _lastBtn.height;
				innerCanvas.x = _firstBtn.width + _gap;
				innerCanvas.width = unscaledWidth - _firstBtn.width - _lastBtn.width - 2 *_gap;
				innerCanvas.height = height;
			}
			else if (DIRECTION_VERTICAL == _direction)
			{
				_firstBtn.x = (unscaledWidth - _firstBtn.width)/2;
				_firstBtn.y = 0;
				_lastBtn.x = (unscaledWidth - _lastBtn.width)/2;
				_lastBtn.y = unscaledHeight - _lastBtn.height;
				innerCanvas.y = _firstBtn.height + _gap;
				innerCanvas.height = unscaledHeight - _firstBtn.height - _lastBtn.height - 2 *_gap;
				innerCanvas.width = width;
			}
			else
			{
				throw new Error("direction value out of range");
			}
		}
		
		private function addListeners(eventString:String):void {
			_firstBtn.addEventListener(eventString, startScrollingFirst, false, 0, true);	
			_lastBtn.addEventListener(eventString, startScrollingLast, false, 0, true);	
		}
		
		private function removeListeners(eventString:String):void {
			_firstBtn.removeEventListener(eventString, startScrollingFirst);	
			_lastBtn.removeEventListener(eventString, startScrollingLast);		
		}
		
		/**
		 * If we have already created the innerCanvas element, then we add the child to
		 * that. If not, that means we haven't called createChildren yet. So what we do
		 * is add the child to this main Canvas, and once we call createChildren we'll
		 * remove all the children and switch them over to innerCanvas.
		 */
/*  		override public function addChild(child:DisplayObject):DisplayObject {
			if(_childrenCreated) {
				return innerCanvas.addChild(child);
			}
			else {
				return super.addChild(child);
			}
		}  */
		
		override public function get horizontalScrollPosition():Number {
			return innerCanvas.horizontalScrollPosition;
		}
		
		override public function set horizontalScrollPosition(value:Number):void {
			innerCanvas.horizontalScrollPosition = value;
			
			callLater(enableOrDisableButtons);
		}
		
		override public function get verticalScrollPosition():Number {
			return innerCanvas.verticalScrollPosition;
		}
		
		override public function set verticalScrollPosition(value:Number):void {
			innerCanvas.verticalScrollPosition = value;
			
			callLater(enableOrDisableButtons);
		}
		
		override public function get maxHorizontalScrollPosition():Number {
			return innerCanvas.maxHorizontalScrollPosition;
		}
		
		override public function get maxVerticalScrollPosition():Number {
			return innerCanvas.maxVerticalScrollPosition;
		}
		
		public function set explicitButtonHeight(value:Number):void {
			invalidateDisplayList();
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//setDirection(unscaledWidth, unscaledHeight);
			
			callLater(enableOrDisableButtons);
		}
		
		private function startScrollingFirst(event:Event):void {
	    	if(!(event.currentTarget as Button).enabled) return;
	    	if (DIRECTION_HORIZONTAL == _direction)
				startScrolling(scrollLeft, event.currentTarget as Button);
			else
				startScrolling(scrollUp, event.currentTarget as Button);
	    }
	    
	    private function startScrollingLast(event:Event):void {
	    	if(!(event.currentTarget as Button).enabled) return;
	    	if (DIRECTION_HORIZONTAL == _direction)
				startScrolling(scrollRight, event.currentTarget as Button);
			else
				startScrolling(scrollDown, event.currentTarget as Button);
		}
	
		private function startScrolling(scrollFunction:Function, button:Button):void {
			if(_stopScrollingEvent == MouseEvent.MOUSE_UP) {
				stage.addEventListener(_stopScrollingEvent, stopScrolling);
			}
			else {
				button.addEventListener(_stopScrollingEvent, stopScrolling);
			}
			
			if(timer.running) {
				timer.stop();
			}
			
			timer = new Timer(this.scrollSpeed);
			timer.addEventListener(TimerEvent.TIMER, scrollFunction);
			
			timer.start();
	    }
	    
	    private function stopScrolling(event:Event):void {
	    	if(timer.running) {
				timer.stop();
			}
	    }
	    
	    private function scrollLeft(event:TimerEvent):void {
	    	innerCanvas.horizontalScrollPosition -= scrollJump;
	    	enableOrDisableButtons();
	    }
	    
	    private function scrollRight(event:TimerEvent):void {
			innerCanvas.horizontalScrollPosition += scrollJump;
			enableOrDisableButtons();
		}
		
		private function scrollUp(event:TimerEvent):void {
	    	innerCanvas.verticalScrollPosition -= scrollJump;
	    	enableOrDisableButtons();
	    }
	    
	    private function scrollDown(event:TimerEvent):void {
			innerCanvas.verticalScrollPosition += scrollJump;
			enableOrDisableButtons();
		}
	    
	   
	    /**
	     * We check to see if the buttons should be shown. If we can't scroll in
	     * one direction then we don't show that particular button.
	     */ 
	    protected function enableOrDisableButtons():void {
	    	return;
	    	var leftButton:Button = _firstBtn;
	    	var rightButton:Button = _lastBtn;
	    	var upButton:Button = _firstBtn;
	    	var downButton:Button = _lastBtn;
	    	if (DIRECTION_HORIZONTAL == _direction)
	    	{
				if(this.horizontalScrollPolicy == ScrollPolicy.OFF) {
					leftButton.visible = rightButton.visible = leftButton.includeInLayout = rightButton.includeInLayout = false;
				}
				else {
					leftButton.visible = leftButton.enabled = innerCanvas.horizontalScrollPosition > 0;
					rightButton.visible = rightButton.enabled = innerCanvas.horizontalScrollPosition < innerCanvas.maxHorizontalScrollPosition;
				}
			}
			else
			{
				if(this.verticalScrollPolicy == ScrollPolicy.OFF) {
					upButton.visible = downButton.visible = upButton.includeInLayout = downButton.includeInLayout = false;
				}
				else {
					upButton.visible = upButton.enabled = upButton.includeInLayout = innerCanvas.verticalScrollPosition > 0;
					downButton.visible = downButton.enabled = downButton.includeInLayout = innerCanvas.verticalScrollPosition < innerCanvas.maxVerticalScrollPosition;
				}
			}	
		}
	    
/* 	    override public function getChildAt(index:int):DisplayObject {
	    	return _childrenCreated ? innerCanvas.getChildAt(index) : super.getChildAt(index);
	    } */
	    
/* 	    override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
	    	if(_childrenCreated) {
	    		return innerCanvas.addChildAt(child, index);
	    	}
	    	else {
	    		return super.addChildAt(child, index);
	    	}
	    } */
	    
/* 	    override public function getChildByName(name:String):DisplayObject {
	    	return _childrenCreated ? innerCanvas.getChildByName(name) : super.getChildByName(name);
	    }
	    
	    override public function getChildIndex(child:DisplayObject):int {
	    	return _childrenCreated ? innerCanvas.getChildIndex(child) : super.getChildIndex(child);
	    }
	    
	    override public function getChildren():Array {
	    	return _childrenCreated ? innerCanvas.getChildren() : super.getChildren();
	    } */
		
	}
}