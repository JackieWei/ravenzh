package com.youcity.website.front.util
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	import mx.core.UIComponent;

	public class Loading extends UIComponent
	{
		[Embed(source="assets/preloader/loading.swf")]
		public var LOADING:Class;
		
		private var _mc:MovieClip;
		public function Loading()
		{
			super();
			_mc = new LOADING();
			_mc.x = _mc.width/2;
			_mc.y = _mc.height/2;
			addChild(_mc);
			var ui:Shape = new Shape();
			ui.graphics.beginFill(0x000000,0);
			ui.graphics.drawRect(0,0,_mc.width,_mc.height);
			ui.graphics.endFill();
			addChild(ui);
			mask = ui;
		}
		
		override public function get width():Number
		{
			return _mc.width;
		}
		
		override public function get height():Number
		{
			return _mc.height;
		}
		
		override public function set width(value:Number):void
		{
			_mc.width = value;
		}
		
		override public function set height(value:Number):void
		{
			_mc.height = value;
		}
		
	}
}