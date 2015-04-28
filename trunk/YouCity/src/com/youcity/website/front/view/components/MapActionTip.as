package com.youcity.website.front.view.components
{
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.controls.Label;

	public class MapActionTip extends Canvas
	{
		private var _tipLabel:Label;
		
		private var dataChanged:Boolean = false;
		private var _tip:String;
		public function get tip():String
		{
			return this.tip;
		}
		public function set tip(value:String):void
		{
			if (value != null && value != this._tip)
			{
				this._tip = value;
				dataChanged = true;
				invalidateProperties();
			}
		}
		
		public function MapActionTip()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			_tipLabel = new Label();
			_tipLabel.styleName = "hintText";
			_tipLabel.x = 1;
			_tipLabel.y = 1;
			_tipLabel.setStyle("verticalCenter", 0);
			this.addChild(_tipLabel); 
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (dataChanged)		
			{
				dataChanged = false;
				this._tipLabel.text = this._tip;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			graphics.clear();
			graphics.lineStyle(1,0x0099CC);
			graphics.lineTo(_tipLabel.width + 2, 0);
			graphics.lineTo(_tipLabel.width + 2, _tipLabel.height + 2);
			graphics.lineTo(0, _tipLabel.height + 2);
			graphics.lineTo(0, 0);
			graphics.beginFill(0xFFFFFF, 1);
			graphics.drawRect(1, 1, _tipLabel.width, _tipLabel.height);
			graphics.endFill();
		}
		
	}
}