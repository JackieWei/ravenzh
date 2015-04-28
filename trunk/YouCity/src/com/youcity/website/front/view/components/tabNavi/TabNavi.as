
package com.youcity.website.front.view.components.tabNavi
{
	import com.youcity.website.front.view.components.controls.Button;
	import com.youcity.website.front.view.useraccounts.widgets.SettingItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;

	[Event(name = "leftButtonClick",	type = "flash.events.MouseEvent")]
	[Event(name = "middleButtonClick",  type = "flash.events.MouseEvent")]
	[Event(name = "rightButtonClick",  type = "flash.events.MouseEvent")]
	[Event(name = "tabClick",  type = "flash.events.Event")]
	[Style(name = "tabStyleName", type="String", inherit="no")]
	public class TabNavi extends Canvas
	{
		public static const LEFT_BUTTON_CLICK:String = "leftButtonClick";
		public static const MIDDLE_BUTTON_CLICK:String = "middleButtonClick";
		public static const RIGHT_BUTTON_CLICK:String = "rightButtonClick";
		public static const TAB_CLICK:String = "tabClick";
		
		public static const LEFT:String = "left";
		public static const MIDDLE:String = "middle";
		public static const RIGHT:String = "right";
		
		private var _leftButton:Button;
		private var _middleButton:Button;
		private var _rightButton:Button;
		
		private var _leftContainer:SettingItem;
		private var _rightContainer:SettingItem;
		private var _middleContainer:SettingItem;
		
		private var _leftClicked:Boolean = false;
		private var _middleClicked:Boolean = false;
		private var _rightClicked:Boolean = false;
		
		private var _buttonContainer:Canvas;
		public function get buttoBar():Canvas
		{
			return _buttonContainer;
		}
		
		private var _buttonWidth:uint = 97;
		
		private var _selectedIncrease:uint = 3;
		
		private var _isCompleted:Boolean = false;
		
		private var _innerContainer:Canvas;
		
		private var _scale:Canvas;
		
		private var _selectedItem:String = LEFT;
		public function get selectedItem():String
		{
			return _selectedItem;
		}
		public function set selectedItem(value:String):void
		{
			_selectedItem = value;
			if (_isCompleted) setItem(value);
		}
		
		public function hasSelected():Boolean
		{
			if (LEFT == _selectedItem || MIDDLE == _selectedItem || RIGHT == _selectedItem)
			{
				return true;
			}
			return false;
		}
		
		private function setItem(value:String):void
		{
			var flag:Boolean = true;
			if (LEFT == value)
			{
				setButtonFoucs(_leftButton);
			}
			else if (MIDDLE == value)
			{
				setButtonFoucs(_middleButton);
			}
			else if (RIGHT == value)
			{
				setButtonFoucs(_rightButton);
			}
			else
			{
				return;
			}
		}
		
		public function set bgVisible(value:Boolean):void
		{
			_scale.visible = value;
		}
		public function get bgVisible():Boolean
		{
			return _scale.visible;
		}
		
		public function TabNavi()
		{
			super();
			
			
			_buttonContainer = new Canvas();
			_buttonContainer.horizontalScrollPolicy = "off";
			_buttonContainer.verticalScrollPolicy = "off";
			_buttonContainer.percentWidth = 100;
			_buttonContainer.height = 100;
			
			_leftButton = new Button();
			_leftButton.setStyle("paddingLeft", 5);
			_leftButton.setStyle("paddingRight", 5);
			_leftButton.id = "leftButton"
			_leftButton.toggle = true;
			_leftButton.y = _selectedIncrease;
			_leftButton.width = 97;
			_leftButton.height = 27;
			_middleButton = new Button();
			_middleButton.id = "middleButton"
			_middleButton.toggle = true;
			_middleButton.width = 97;
			_middleButton.height = 27;
			_middleButton.x = _buttonWidth + 1;
			_middleButton.y = _selectedIncrease;
			_rightButton = new Button();
			_rightButton.id = "rightButton"
			_rightButton.toggle = true;
			_rightButton.x = _middleButton.x + _buttonWidth;
			_rightButton.y = _selectedIncrease;
			_rightButton.width = 97;
			_rightButton.height = 27;
			
			_buttonContainer.addChild(_leftButton);
			_buttonContainer.addChild(_middleButton);
			_buttonContainer.addChild(_rightButton);
			addChild(_buttonContainer);
			
			_scale = new Canvas();
			_scale.x = 0;
			_scale.y = 25;
			_scale.percentWidth = 100;
			_scale.height = 29;
			_scale.styleName = "settingSelected";
			_buttonContainer.addChild(_scale);
			
			_leftButton.addEventListener(MouseEvent.CLICK, onClickHandler);
			_middleButton.addEventListener(MouseEvent.CLICK, onClickHandler);
			_rightButton.addEventListener(MouseEvent.CLICK, onClickHandler);
			
			addEventListener(FlexEvent.CREATION_COMPLETE, onCompletedHandler);
		}
		
		private function onCompletedHandler(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCompletedHandler);
			_isCompleted = true;
			if (label)
			{
				var tArr:Array = label.split(",");
				if (tArr.length == 3)
				_leftButton.label = tArr[0];
				_middleButton.label = tArr[1];
				_rightButton.label = tArr[2];
			}
			if (numChildren == 4)
			{
				_leftContainer = SettingItem(getChildAt(1));
				_middleContainer = SettingItem(getChildAt(2));
				_rightContainer = SettingItem(getChildAt(3));
			}
			else
			{
				throw new Error("Child Num uncorrect");
			}
			setAll(false);
			selectedItem = _selectedItem;
		}
		
		private function onClickHandler(event:MouseEvent):void
		{
			var target:Button = Button(event.currentTarget);
			setButtonFoucs(target);
		}
		
		private function setButtonFoucs(target:Button):void
		{
			setAll(false);
			target.selected = true;
			target.y = 0;
			
			if (-1 != _buttonContainer.getChildIndex(target)) _buttonContainer.setChildIndex(target, _buttonContainer.numChildren - 1);
			if (-1 != _buttonContainer.getChildIndex(_scale)) _buttonContainer.setChildIndex(_scale, _buttonContainer.numChildren - 2);
			
			
			if ("leftButton" == target.id) 
			{
				dispatchEvent(new MouseEvent("leftButtonClick"));
				_selectedItem = LEFT;
				_leftContainer.visible = true;
				if (!_leftClicked)
				{
					_leftContainer.getData();
//					_leftClicked = true;
				}
			}
			else if ("middleButton" == target.id)
			{
				dispatchEvent(new MouseEvent("middleButtonClick"));
				_selectedItem = MIDDLE;
				_middleContainer.visible = true;
				if (!_middleClicked)
				{
					_middleContainer.getData();
//					_middleClicked = true;
				}
			}
			else if ("rightButton" == target.id)
			{
				dispatchEvent(new MouseEvent("rightButtonClick"));
				_selectedItem = RIGHT;
				_rightContainer.visible = true;
				if (!_rightClicked)
				{
					_rightContainer.getData();
//					_rightClicked = true;
				}
			}
			else return;	
			dispatchEvent(new Event("tabClick"));
			
		}
		
		
		public function setAll(flag:Boolean):void
		{
			_leftButton.selected = flag;
			_leftButton.y = _selectedIncrease;
			_leftContainer.visible = flag;
			_middleButton.selected = flag;
			_middleButton.y = _selectedIncrease;
			_middleContainer.visible = flag;
			_rightButton.selected = flag;
			_rightButton.y = _selectedIncrease;
			_rightContainer.visible = flag;
		}
		
		private var styleChangedFlag:Boolean;
		public override function styleChanged(styleProp:String):void 
		{
			super.styleChanged(styleProp);
			if ("tabStyleName" == styleProp || 
				"leftStyleName" == styleProp || 
				"middleStyleName" == styleProp || 
				"rightStyleName" == styleProp || 
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
				if (getStyle("tabStyleName"))
				{
					_leftButton.styleName = getStyle("tabStyleName");
					_middleButton.styleName = getStyle("tabStyleName");
					_rightButton.styleName = getStyle("tabStyleName");
				}
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
		}
		
	}
}