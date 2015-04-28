package com.youcity.maps.controls
{
	import com.youcity.maps.util.DisplayUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ButtonControl extends Sprite
	{
		protected var _upSkin:Bitmap;
		protected var _overSkin:Bitmap;
		protected var _selectedSkin:Bitmap;
		
		override public function get width():Number
		{
			return _upSkin.width;
		}
		
		override public function get height():Number
		{
			return _upSkin.height;
		}
		
		protected var _selected:Boolean;
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if (_selected == value) return;
			_selected = value;
			if(_selected) 
				setState("selected");
			else
				setState("over");
		}
		
		public function ButtonControl()
		{
			super();
			buttonMode = true;
			setSkins();
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
//			addEventListener(MouseEvent.CLICK, mouseClick);
			setState("normal");
		}
		
		protected function setSkins():void
		{
			//set all skins
		}
		
		protected function setUpKin(value:Class):void
		{
			_upSkin = setSkin(value); 
		}
		
		protected function setOverSkin(value:Class):void
		{
			_overSkin = setSkin(value);
		}
		
		protected function setSelectedSkin(value:Class):void
		{
			_selectedSkin = setSkin(value);
		}
		
		private function setSkin(value:Class):Bitmap
		{
			var skin:Bitmap = new value();
			return skin;
		}
		
		protected function mouseOver(event:MouseEvent):void
		{
			if (!_selected)
			{
				setState("over");
			}
		}
		
		protected function mouseOut(event:MouseEvent):void
		{
			if (!_selected)
			{
				setState("normal");
			}
		}
		
/* 		protected function mouseClick(event:MouseEvent):void
		{
			selected = !selected;
		} */
		
		protected function setState(state:String):void
		{
			DisplayUtil.removeAllChildren(this);
			if ("normal" == state)
			{
				addChild(_upSkin);
			}
			else if ("over" == state)
			{
				addChild(_overSkin);
			}
			else if ("selected" == state)
			{
				addChild(_selectedSkin);
			}
			else
			{
				throw new Error("argument out of range");
			}
		}
		
	}
}