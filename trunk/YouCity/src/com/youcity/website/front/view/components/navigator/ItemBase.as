package com.youcity.website.front.view.components.navigator
{
	import flash.events.Event;
	
	import gs.TweenLite;
	import gs.utils.tween.TweenLiteVars;
	
	import mx.containers.Canvas;

	public class ItemBase extends Canvas implements IItemBase
	{
		public static const MAXMIZE:String = "maxmize";
		public static const MINIMIZE:String = "minimize";
		
		protected var _state:String;
		protected function set state(value:String):void
		{
			_state = value;
		}
		
		public function ItemBase()
		{
			super();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveHandler);
		}
		
		private function onRemoveHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveHandler);
			clear();
		}
		
		public var index:uint;
		
		public function clear():void
		{
			
		}
		
		protected var _hideDelay:uint = 300;
		public final function set hideDelay(value:uint):void
		{
			_hideDelay = value;
		}
		public function hide():void
		{
			visible =false;
			alpha = 0;
			return;
			var param:TweenLiteVars = new TweenLiteVars();
			param.onComplete = onHideHandler;
			param.alpha = 0;
			TweenLite.to(this, _hideDelay/1000, param);
		}
		
		protected function onHideHandler():void
		{
			visible = false;
		}
		
		private var _showDelay:uint = 300;
		public final function set showDelay(value:uint):void
		{
			_showDelay = value;
		}
		public function show():void
		{
			visible = true;
			alpha = 1;
			return;
			var param:TweenLiteVars = new TweenLiteVars();
			param.onComplete = onShowHandler;
			param.alpha = 1;
			TweenLite.to(this, _showDelay/1000, param);
		}
		
		protected function onShowHandler():void
		{
			
		}
		
		//set the container to minimize state
		public function minimize():void
		{
			state = MINIMIZE;
		}
		
		//set the container to maxmize state
		public function maxmize():void
		{
			state = MAXMIZE;
		}
		
		//state transfer to minimize with effects
		public function toMinimize():void
		{
			
		}
		
		//state transfer to maxmize with effects
		public function toMaxmize():void
		{
			
		}
		
		//when first time click, go get data
		public function getDataAtFirstSelected():void
		{
			
		} 
	}
}