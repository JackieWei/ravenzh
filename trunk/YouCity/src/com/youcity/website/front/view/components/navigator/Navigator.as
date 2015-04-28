package com.youcity.website.front.view.components.navigator
{
	import com.youcity.website.front.util.AuxUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flexlib.controls.CanvasButton;
	
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;
	import mx.events.ResizeEvent;

	[Exclude(name="focusOutEffect", kind="effect")]
	[Exclude(name="paddingBottom", kind="style")]
	[Exclude(name="cornerRadius", kind="style")]
	[Exclude(name="creationComplete", kind="event")]
	[Style(name="padding", type="Number", format="Length", inherit="no")]
	[Style(name="contentStyleName", type="String",inherit="no")]
	[Event(name="change", type="flash.events.Event")]
	public class Navigator extends Canvas
	{
		import mx.containers.Box;
		import mx.core.UIComponent;
		import mx.core.UIComponentGlobals;
		import mx.containers.HBox;
		import mx.events.FlexEvent;
		
		public static const CHANGE:String = "change";
		
		private var _icons:Array;
		[ArrayElementType("mx.core.UIComponent")] 
		public function set icons(value:Array):void
		{
			_icons = value;
		}
		public function get icons():Array
		{
			return _icons;
		}
		
		private var _contents:Array;
		[ArrayElementType("com.youcity.website.front.view.components.navigator.ItemBase")] 
		public function set contents(value:Array):void
		{
			_contents = value;
		}
		public function get contents():Array
		{
			return _contents;
		}
		
		public function refresh():void
		{
			setDisplay();
		}
		
		private var _selectedHistory:Array;
		private var _selectedCount:Array;
		
		private var _isInit:Boolean;
		
		private var _iconHeight:Number;
		public function set iconHeight(value:Number):void
		{
			_iconHeight = value;
		}
		public function get iconHeight():Number
		{
			return _iconHeight;
		}
		
		[Inspectable(category="General",defaultValue=0)]
		private var _marginStart:int;
		public function set marginStart(value:int):void
		{
			if (!_isInit)
			{
				_marginStart = value;
				return;
			}
			if (_marginStart == value) return;
			_marginStart = value;
			setDisplay();
		}
		
		[Inspectable(category="General",defaultValue=0)]
		private var _marginEnd:uint;
		public function set marginEnd(value:uint):void
		{
			if (!_isInit)
			{
				_marginEnd = value;
				return;
			}
			if (_marginEnd == value) return;
			_marginEnd = value;
			setDisplay();
		}
		
		private var _iconWidth:Number;
		public function set iconWidth(value:Number):void
		{
			_iconWidth = value;
		}
		public function get iconWidth():Number
		{
			return _iconWidth;
		}
		
		private var _iconGap:Number = 0;
		public function set iconGap(value:String):void
		{
/* 			if (!_isInit)
			{
				_iconGap = AuxUtil.parseStringToNumber(value);
				return;
			} */
//			if (_iconGap == parseStringToNumber(value)) return;
			_iconGap = AuxUtil.parseStringToNumber(value);
		}
		
		[Inspectable(category="General", defaultValue=0)]
		private var _innerGap:Number = 0;
		public function set innerGap(value:Number):void
		{
			if (!_isInit)
			{
				_innerGap = value;
				return;
			}
			if (_innerGap == value) return;
			_innerGap = value;
			setContainers();
		}
		public function get innerGap():Number
		{
			return _innerGap;
		}
		
		//private var _iconsContainer:Canvas = new Canvas;
		private var _contentsContainer:Canvas;
		
		private var _selectedIndex:int;
		public function set selectedIndex(value:int):void
		{
			if (!_isInit)
			{
				_selectedIndex = value;
				return;
			}
			//if (value == _selectedIndex) return;
			if (number > 0)
				if (value >= number)
					value = number;
				else if (value <= 0)
					value = 0;
				else {}
			setIndex(value);
			_selectedIndex = value;
			dispatchEvent(new Event(CHANGE));
		}
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function get selectedContent():ItemBase
		{
			if (_contentsContainer.numChildren > _selectedIndex)
				return ItemBase(_contentsContainer.getChildAt(_selectedIndex));
			else
				return null;
		}
		
		public static const TOP:String = "top";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const BOTTOM:String = "bottom";
		
		private var _location:String;
		[Inspectable(category="General", enumeration="top,left,right,bottom", defaultValue="top")]
		public function set location(value:String):void
		{
			if (_location == value) return;
			_location = value;
		}
		public function get location():String
		{
			return _location;
		}
		
		private function get number():uint
		{
			if (!icons || !naviCheck()) 
				return 0;
			else 
				return icons.length;
		}
		
		public function get length():uint
		{
			if (!_icons || !_contents) return 0;
			if (_icons.length != _contents.length)
			{
				throw new Error("lables and contents not match exactly!");
				return 0;
			}
			return _icons.length;
		}
		
		public function Navigator()
		{
			super();
			
			_contentsContainer = new Canvas();
			_contentsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
			_contentsContainer.verticalScrollPolicy = ScrollPolicy.OFF;
//			addChild(_contentsContainer);
//			_iconsContainer = new Canvas();
//			_iconsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
//			_iconsContainer.verticalScrollPolicy = ScrollPolicy.OFF;
//			addChild(_iconsContainer);
			addEventListener(FlexEvent.CREATION_COMPLETE, onInit);
			verticalScrollPolicy = ScrollPolicy.OFF;
			horizontalScrollPolicy=ScrollPolicy.OFF;
			
			addEventListener(ResizeEvent.RESIZE, onResizeChangedHandler);
		}
		
		private function onResizeChangedHandler(event:ResizeEvent):void
		{
			setContainers();
		}
		
		private function onInit(event:FlexEvent):void
		{
			if (numChildren > 2) throw new Error("Not allowed to add children in editor!");
			_isInit = true;
			setDisplay();
			selectedIndex = _selectedIndex;
			innerGap = _innerGap;
//			iconGap = _iconGap.toString();
		}
		
		private function naviCheck():Boolean
		{
			if (!icons || icons.length <= 0) return false;;
			if (!contents || contents.length <= 0 || contents.length != icons.length) 
			{
				throw new Error("Icons and contents's children number are not the same");
				return false;
			}
			for (var i:uint = 0; i < icons.length; i++)
			{
				if (! icons[i] is UIComponent || !contents[i] is ItemBase)
					return false;
				if ((UIComponent(icons[i]).id != null && UIComponent(icons[i]).id != "icons_" + String(i)) ||
					(ItemBase(contents[i]).id != null && ItemBase(contents[i]).id != "contents_" + String(i)))
					//throw new Error("Not allowed id property");
					continue;
			}
			return true;
		}
		
		private var _iconStartX:Number;
		private var _iconStartY:Number;
		
		private function setContainers():void
		{
			if (TOP == _location || BOTTOM == _location)
			{
//				_iconsContainer.x = 0;
//				_iconsContainer.y = _location == TOP ? 0 : height - _iconHeight;
//				_iconsContainer.percentWidth = 100;
//				_iconsContainer.height = _iconHeight;
				_iconStartX = 0;
				_iconStartY = _location == TOP ? 0 : height - _iconHeight;
				_contentsContainer.x = 0;
				_contentsContainer.y = _location == TOP ? _iconHeight + _innerGap : 0;
				_contentsContainer.percentWidth = 100;
				_contentsContainer.height = height - _iconHeight - _innerGap;
			}
			else if (LEFT == _location || RIGHT == _location)
			{
/* 				_iconsContainer.x = _location == LEFT ? 0 : width - _iconWidth;
				_iconsContainer.y = 0;
				_iconsContainer.percentHeight = 100;
				_iconsContainer.width = _iconWidth; */
				_iconStartX = _location == LEFT ? 0 : width - _iconWidth;
				_iconStartY = 0;
				
				_contentsContainer.x = _location == LEFT ? _iconWidth + _innerGap : 0;
				_contentsContainer.y = 0;
				_contentsContainer.percentHeight = 100;
				_contentsContainer.width = width - _iconWidth - _innerGap;
			}
			else
			{
				throw new Error("Should specify location property!");
			}
		}
		
		private function setDisplay():void
		{
			if (!naviCheck()) return;
			_contentsContainer.removeAllChildren();
			removeAllChildren();
//			_iconsContainer.removeAllChildren();
			setContainers();
			_selectedHistory = new Array();
			_selectedCount = new Array();
			
			for (var i:uint = 0; i < icons.length; i++)
			{
				var iconItem:UIComponent = icons[i] as UIComponent;
//				iconItem.selected = false;
				iconItem.id = "icons_" + String(i);
				iconItem.buttonMode = true;
				setIconPosition(iconItem, i);
				iconItem.addEventListener(MouseEvent.CLICK, iconClickedHandler);
//				_iconsContainer.addChild(iconItem);
				addChild(iconItem);
				var contentsItem:ItemBase = contents[i] as ItemBase;
				contentsItem.alpha = 0;
				contentsItem.index = i;
				contentsItem.visible = false;
				contentsItem.percentWidth = 100;
				contentsItem.percentHeight = 100;
				contentsItem.id = "contents_" + String(i);
				_contentsContainer.addChild(contentsItem);
				
				_selectedHistory.push(false);
				_selectedCount.push(0);
			}
			addChildAt(_contentsContainer, length -1);
		}
		
		private function setIconPosition(icon:UIComponent, i:uint):void
		{
			if (i >= _icons.length) return;
			
//			var w:Number = _iconsContainer.width;
//			var h:Number = _iconsContainer.height;
			
			var w:Number = width; 
			var h:Number = height;
			
			var gap:Number;
			
			if (TOP == _location || BOTTOM == _location)
			{
				if (0 == _iconGap)
					gap = (w - _marginStart -  _marginEnd- (_icons.length * icon.width)) / (_icons.length - 1);
//					gap = (w - _marginStart -  _marginEnd- (_icons.length * _iconWidth)) / (_icons.length - 1);
				else
					gap = _iconGap;
				icon.x = _iconStartX + _marginStart + i * (gap + _iconWidth); 
			}
			else
			{
				if (0 == _iconGap)
					gap = (h - _marginStart - _marginEnd - (_icons.length * icon.height)) / (_icons.length - 1);
//					gap = (h - _marginStart - _marginEnd - (_icons.length * _iconHeight)) / (_icons.length - 1);
				else
					gap = _iconGap;
				icon.y = _iconStartY +  _marginStart + i * (gap + _iconHeight); 
			}
			
		}
		
		private function setIndex(index:uint):void
		{
			if (index <0 || index >= number)
				return;
			var beforeIcon:CanvasButton = CanvasButton(icons[_selectedIndex]);
			if (beforeIcon) beforeIcon.selected = false;
			var beforeContent:ItemBase = ItemBase(contents[_selectedIndex]);
			if (beforeContent)
			{
//				beforeContent.visible = false;
				beforeContent.hide();
			}
			var selectedIcon:CanvasButton = CanvasButton(icons[index]);
			selectedIcon.selected = true;
			setChildIndex(selectedIcon, length);
//			_iconsContainer.setChildIndex(selectedIcon, _iconsContainer.numChildren - 1);
			_selectedCount[index] ++;
			var selectedItem:ItemBase = ItemBase(contents[index]);
			if (_selectedHistory[index] == false)
			{
				selectedItem.getDataAtFirstSelected();
				_selectedHistory[index] = true;
			}
//			selectedItem.visible = true;
			selectedItem.show();
			setIconsIndex();
		}
		
		private function setIconsIndex():void
		{
			var j:uint = length - 2;
			for (var i:uint = 0; i < icons.length; i++)
			{
				var icon:CanvasButton = CanvasButton(icons[i]);
				if(icon.selected)
				{
					continue;
				}
				setChildIndex(icon, j);
//				_iconsContainer.setChildIndex(icon, j);
				j--;
			}
		}
		
		private function iconClickedHandler(event:MouseEvent):void
		{
			var icon:CanvasButton = event.currentTarget as CanvasButton;
			selectedIndex = uint(icon.id.charAt(icon.id.length - 1));
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (getStyle("contentStyleName") != _contentsContainer.styleName)
				_contentsContainer.styleName = getStyle("contentStyleName");
		}
		
	}
}