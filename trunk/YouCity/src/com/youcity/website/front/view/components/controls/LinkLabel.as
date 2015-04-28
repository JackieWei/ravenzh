package com.youcity.website.front.view.components.controls
{
	import flash.events.MouseEvent;
	
	import mx.controls.Label;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	[Style(name = "textOverColor", type = "Number", format = "Color", inherit = "no")]
	[Style(name = "textDownColor", type = "Number", format = "Color", inherit = "no")]
	public class LinkLabel extends Label
	{
		private var normalColor:Number;
		
		public function LinkLabel()
		{
			super();
			
			//make the label be a button
			buttonMode = true;
			mouseChildren = false;
			//add listeners
			addEventListener(MouseEvent.ROLL_OVER, 	handleRollOver);
			addEventListener(MouseEvent.ROLL_OUT, 	handleRollOut);
			addEventListener(MouseEvent.CLICK, 		handleMouseClick);
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			mouseEnabled = value;
		}
			
		
		//Indicates whether style changed, default value is "false"	
		private var styleChangedFlag:Boolean = false;
		
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			if ("textOverColor"  == styleProp|| "textDownColor" == styleProp || "styleName" == styleProp)
			{
				styleChangedFlag = true;
				invalidateDisplayList();
				return;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//style changed
			if (styleChangedFlag)
			{
				styleChangedFlag = false;
			}
		}
		
		private function handleRollOver(event:MouseEvent):void
		{
			normalColor = getStyle("color");
			setStyle("color", getStyle("textOverColor"));
		}
		
		private function handleRollOut(event:MouseEvent):void
		{
			setStyle("color", normalColor);
			
		}
		
		private function handleMouseClick(event:MouseEvent):void
		{
			setStyle("color", getStyle("textDownColor"));
		}
	}
}