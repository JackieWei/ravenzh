package com.youcity.website.front.view.common
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.managers.CursorManager;
	
	public class DragManager
	{
		private var _target:Sprite;
		private var _dispatcher:Sprite;
		private var _dragStartHandler:Function;
		private var _draggingHandler:Function;
		
		public function DragManager(target:Sprite, dispatcher:Sprite, dragStartHandler:Function, draggingHandler:Function)
		{
			_target = target;
			_dragStartHandler = dragStartHandler;
			_draggingHandler = draggingHandler;
			_dispatcher = dispatcher;
		}
		
		public function doDrag():void
		{
			_dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, dragStart);
			_dispatcher.addEventListener(MouseEvent.MOUSE_MOVE, dragging);
			_dispatcher.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_dispatcher.addEventListener(MouseEvent.MOUSE_UP, dragEnd);
		}
		
		
		private var _isDragging:Boolean;
		
		private var __x:Number;
		private var __y:Number;
		
		private function dragStart(event:MouseEvent):void
		{
//			event.stopPropagation();
			_isDragging = true;
			__x = _target.mouseX;
			__y = _target.mouseY;
			_dragStartHandler(event);
//			CursorManager.setBusyCursor();
		}
		
		private function dragging(event:MouseEvent):void
		{
			event.stopPropagation();
			if (!_isDragging) 
			return;
			_target.x += _target.mouseX - __x;
			_target.y += _target.mouseY - __y;
		}
		
		private function onEnterFrame(event:Event):void
		{
			event.stopPropagation();
			if (!_isDragging) return;
			_target.x += _target.mouseX - __x;
			_target.y += _target.mouseY - __y;
		}
		
		private function dragEnd(event:MouseEvent):void
		{
			event.stopPropagation();
			_isDragging = false;
			CursorManager.removeBusyCursor();
		}
		
		public function destruct():void
		{
			_dispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, dragStart);
			_dispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, dragging);
			_dispatcher.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_dispatcher.removeEventListener(MouseEvent.MOUSE_UP, dragEnd);
			_dispatcher = null;
			_dragStartHandler = null;
			_draggingHandler = null;
			_dispatcher = null;
		}
	}
}