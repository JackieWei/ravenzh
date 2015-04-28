package com.youcity.website.front.view.search.widgets
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;

	[Event(name="itemClick", type="flash.events.Event")]
	public class SearchResultMenu extends Canvas
	{
		private var _totalChildrenHeight:Number = 0
		
		private var selectedChild:Button;
		
		private var _selectedIndex:int = -1;
		public function get selectedIndex():int
		{
			return this._selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			if (this._selectedIndex != value)
			{
				this._selectedIndex = value;
				if (numChildren == 0)
				return;

				if (_selectedIndex == -1)
				{
					if (selectedChild)
						selectedChild.selected = false;
				}
				else
				{
					if (selectedChild)
					{
						selectedChild.selected = false;
						selectedChild = getChildAt(_selectedIndex) as Button;
						selectedChild.selected = true;
					}
					else
					{
						selectedChild = getChildAt(_selectedIndex) as Button;
						selectedChild.selected = true;
					}
				}
			}
		}
		
		private var updated:Boolean = false;
		
		public function SearchResultMenu()
		{
			super();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			addEventListener(FlexEvent.UPDATE_COMPLETE, handleUpdateCompleteEvent);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();

		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			child.x = 0;
			child.y = this.height - child.height;
			updated = false;
			return super.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			_totalChildrenHeight -= child.height;
			return super.removeChild(child);
		}
		
		private var index:uint = 1;
		private function handleUpdateCompleteEvent(event:FlexEvent):void
		{
			if (numChildren == 0)
			return;
			
			updated = true;
			for (var i:String in this.getChildren())
			{
				var targetChild:Button = this.getChildren()[i] as Button;
				targetChild.addEventListener(MouseEvent.CLICK, handleMenuClick);
				targetChild.addEventListener(Event.CHANGE, handleChangeEvent);
				var newX:Number = 0;
				var newY:Number = numChildren == 1 ? 0 : getTotalChildrenHeight(uint(i));
				TweenLite.to(targetChild, 0.5, {x:newX, y:newY});
			}
		}
		
		private function getTotalChildrenHeight(num:Number):Number
		{
			_totalChildrenHeight = 0;
			for (var i:uint = 0; i < num; i++)
			{
				_totalChildrenHeight += getChildAt(i).height;
			}
			return _totalChildrenHeight;
		}
		
		private function handleMenuClick(event:MouseEvent):void
		{
			if (!Button(event.currentTarget).selected)
			return;
			selectedIndex = this.getChildIndex(event.currentTarget as Button);
			dispatchEvent(new Event("itemClick"));
		}
		
		private function handleChangeEvent(event:Event):void
		{
			if (!Button(event.currentTarget).selected)
			return;
			selectedIndex = this.getChildIndex(event.currentTarget as Button);
			dispatchEvent(new Event("itemClick"));
		}
		
	}
}