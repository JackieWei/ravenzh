package com.youcity.website.front.view.components
{
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;
	
	[Style(name="overBackgroundImage", type="Class", inherit = "no")]
	[Style(name="downBackgroundImage", type="Class", inherit = "no")]
	public class UserComponent extends Canvas 
	{
		private var image:Class;
		private var overImage:Class;
		private var downImage:Class;
		
		private var skinName:String = "backgroundImage";
		private var overSkinName:String = "overBackgroundImage";
		private var downSkinName:String = "downBackgroundImage";
		
		private var newStyleChanged:Boolean = false;
		
		private var selectedChanged:Boolean = false;
		private var _selected:Boolean;
		public function get selected():Boolean
		{
			return this._selected;
		}
		public function set selected(value:Boolean):void
		{
			if (value != this._selected)
			{
				this._selected = value;
				selectedChanged = true;
				invalidateProperties();
			}
		}
				
		public function UserComponent()
		{
			super();
			buttonMode = true;
			mouseChildren = false;
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
			addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
			addEventListener(MouseEvent.ROLL_OVER, handleRollOverEvent);
			addEventListener(MouseEvent.ROLL_OUT, handleRollOutEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDownEvent);
			addEventListener(MouseEvent.MOUSE_UP, handleMouseUpEvent);
//			addEventListener(MouseEvent.CLICK, handlClickEvent);
		}
		
		private function handleCreationComplete(event:FlexEvent):void
		{
			image = getStyle(skinName);	
			overImage = getStyle(overSkinName);	
			downImage = getStyle(downSkinName);	
		}
		
		private function handleRollOverEvent(event:MouseEvent):void
		{
			setStyle("backgroundImage", overImage);
		}
		
		private function handleRollOutEvent(event:MouseEvent):void
		{
			setStyle("backgroundImage", image);
		}
		
		private function handleMouseDownEvent(event:MouseEvent):void
		{
			setStyle("backgroundImage", downImage);
		}
		
		private function handleMouseUpEvent(event:MouseEvent):void
		{
			setStyle("backgroundImage", overImage);
		}
		
		private function handlClickEvent(event:MouseEvent):void
		{
			setStyle("backgroundImage", downImage);
		}
		
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			if (overSkinName == styleProp 
				|| downSkinName == styleProp 
				|| "styleName" == styleProp
				|| null == styleProp)
			{
				newStyleChanged = true;
				invalidateDisplayList();
				return;
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (selectedChanged)
			{
				selectedChanged = false;
				if (this._selected)
				{
					if (!downImage)
					{
						downImage = getStyle(downSkinName);	
					}
					setStyle("backgroundImage", downImage);
					removeEventListener(MouseEvent.ROLL_OVER, handleRollOverEvent);
					removeEventListener(MouseEvent.ROLL_OUT, handleRollOutEvent);
					removeEventListener(MouseEvent.MOUSE_UP, handleMouseUpEvent);
				}
				else
				{
					setStyle("backgroundImage", image);
					addEventListener(MouseEvent.ROLL_OVER, handleRollOverEvent);
					addEventListener(MouseEvent.ROLL_OUT, handleRollOutEvent);
					addEventListener(MouseEvent.MOUSE_UP, handleMouseUpEvent);
				}
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (newStyleChanged)
			{
				newStyleChanged =false;
				image = getStyle(skinName);
				overImage = getStyle(overSkinName);
				downImage = getStyle(downSkinName);
				setStyle("backgroundImage", image);
			}
		}
		
	}
}