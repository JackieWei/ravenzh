package com.youcity.website.front.view.components.tabNavi
{
	import com.youcity.website.front.view.components.controls.Button;
	
	import flash.display.DisplayObject;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	
	[Style(name="naviStyleName", type="String", inherit="no")]
	public class TabNaviItem extends Canvas
	{
		public static const POSITION_LEFT:String = "left";
		public static const POSITION_MIDDLE:String = "middle";
		public static const POSITION_RIGHT:String = "right";
		
		private var _naviBtn:Button;
		private var _innerContainer:Canvas;
		
		private var _position:String;
		public function set position(value:String):void
		{
			_position = value;
		}
		public function get position():String
		{
			return _position;
		}
		
		private var _selected:Boolean = false;
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			_selected = value;
			_naviBtn.selected = _selected;
		}
		
		public var naviItemLabel:String;

		public function TabNaviItem()
		{
			super();
			_naviBtn = new Button();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCompletedHandler);
		}
		
		private function onCompletedHandler(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCompletedHandler);
			_naviBtn.id = "naviBtn";
			_naviBtn.label = naviItemLabel;
			_naviBtn.y = 0;
			_naviBtn.toggle = true;
			super.addChild(_naviBtn);
			setPosition();
		}
		
		private function setPosition():void
		{
			if (POSITION_LEFT == position)
			{
				_naviBtn.x = 1;
			}
			else if (POSITION_MIDDLE == position)
			{
				_naviBtn.x = width * 1 / 3;
			}
			else if (POSITION_RIGHT == position)
			{
				_naviBtn.x = width * 2 / 3;
			}
			else
			{
				return;
			}
		}
		
		private var styleChangedFlag:Boolean;
		public override function styleChanged(styleProp:String):void 
		{
			super.styleChanged(styleProp);
			if ("naviStyleName" == styleProp || 
				null == styleProp
			)
			{
				styleChangedFlag = true;
				invalidateDisplayList();
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (styleChangedFlag)
			{
				if (getStyle("naviStyleName"))
				{
					_naviBtn.styleName = getStyle("naviStyleName");
				}
			}
		}

	}
}