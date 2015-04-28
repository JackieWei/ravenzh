package com.youcity.website.front.view.components.controls
{
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.effects.Glow;
	import mx.events.FlexEvent;
	import mx.managers.ToolTipManager;
	
	public class TextInput extends mx.controls.TextInput
	{
		private var _bg:UIComponent;

		private var glow:Glow;

		public function TextInput()
		{
			super();
			this.styleName = "ycTextInput";
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreateCompletedHandler);
			_bg = new UIComponent();
			//addChild(_bg);
			ToolTipManager.hideDelay = 1000 * 60;
		}
		
		private function onCreateCompletedHandler(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreateCompletedHandler);
			//setStyle("color", 0xeffccd);
			
			_bg.graphics.beginFill(0xCFFFFF, 1);
			_bg.graphics.drawRoundRectComplex(0, 0, width, height, 4, 4, 4, 4);
			_bg.graphics.endFill();
			applyGlow(_bg);
		}
		
		override protected function focusInHandler(event:FocusEvent):void
		{
			super.focusInHandler(event);
			setStyle("backgroundColor", 0xFFFFFF);
			addChildAt(_bg, 0);
			glow.play();
		}
		
		override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusOutHandler(event);
			setStyle("backgroundColor", 0xc7e2cc);
			if (contains(_bg))
			{
				removeChild(_bg);
			}
			//glow.resume();
		}

		private function applyGlow(target:DisplayObject):void
		{
			//var glow:Glow = new Glow();
			glow = new Glow();
			glow.target = _bg;
			glow.alphaFrom = 0;
			glow.alphaTo = 0.38
			glow.blurXFrom = 0;
			glow.blurXTo = 30;
			glow.blurYFrom = 0;
			glow.blurYTo = 30;
			glow.color = 0xd3ff6a;
			glow.inner = false;
			glow.knockout = true;
			//glow.play([target]);
		}
	}
}