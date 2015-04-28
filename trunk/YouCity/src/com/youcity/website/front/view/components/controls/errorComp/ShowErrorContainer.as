package com.youcity.website.front.view.components.controls.errorComp
{
	import flash.display.DisplayObject;
	import flash.utils.setTimeout;
	
	import gs.TweenLite;
	
	import mx.containers.Canvas;
	import mx.core.ComponentDescriptor;
	import mx.core.IFlexDisplayObject;
	import mx.events.ResizeEvent;

	public class ShowErrorContainer extends Canvas
	{
		protected var _Info:Canvas;
		private var _contentCanvas:Canvas;

		private var _position:String = "top";
		
		private var _autoDisappear:Boolean = true;
		public function set autoDisappear(value:Boolean):void
		{
			_autoDisappear = value;
		}
		
		public function ShowErrorContainer()
		{
			super();
			_contentCanvas = new Canvas();
			_contentCanvas.percentWidth = 100;
			addChild(_contentCanvas);
//			addEventListener(ResizeEvent.RESIZE, onResizeHandler);
		}
		
		private var _init:Boolean;
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (_init) return;
			_contentCanvas.height = _show ? unscaledHeight - _Info.height : unscaledHeight;
			_init = true;
		}
		
		private var _show:Boolean;
		protected function showInfo():void
		{
			if (_show) return;
			if (!_Info)
			{
				_Info = new ErrorInfo();
				_Info.alpha = 0;
			}
			if (contains(_Info)) removeChild(_Info);
			_Info.percentWidth = 100;
			_Info.y = 0;
			addChildAt(_Info, 0);
			TweenLite.to(_Info, .2, {alpha:1});
			TweenLite.to(_contentCanvas, .5, {y:_Info.height, height:height-_Info.height});
			if (_autoDisappear) setTimeout(hideError, 3800);
			_show = true;
		}
		
		protected function hideError():void
		{
			if (!contains(_Info)) return;
			removeChild(_Info);
			TweenLite.to(_contentCanvas, .5, {y:0, height:height});
			_show = false;
//			TweenLite.to(_errorInfo, 1, {alpha:0});
//			setTimeout(removeError, 1000);
		}
		
		private function removeError():void
		{
			//removeChild(_errorInfo);
		}
		
		override public function createComponentFromDescriptor(descriptor:ComponentDescriptor, recurse:Boolean):IFlexDisplayObject
		{
			var item:IFlexDisplayObject = super.createComponentFromDescriptor(descriptor, recurse);
			super.removeChild(DisplayObject(item));
			_contentCanvas.addChild(DisplayObject(item));
			return item;
		}
		
		public function addContentChild(child:DisplayObject):DisplayObject
		{
			_contentCanvas.addChild(child);
			return child;
		}
		
	}
}