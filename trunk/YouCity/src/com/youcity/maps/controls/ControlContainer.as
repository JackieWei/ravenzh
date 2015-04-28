package com.youcity.maps.controls
{

	import com.youcity.maps.Map;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	/**
	 * Display control, also you can add more than one control to the container. 
	 * @author Administrator
	 * 
	 */	
	public class ControlContainer  extends UIComponent implements IControlContainer 
	{
		private var _map:Map;
		
		public function get map():Map
		{
			return this._map;
		}
		
		private var _controlsArray:Array;
		
		public function get controlsArray():Array
		{
			return this._controlsArray;
		}
		
		public function set  controlsArray(value:Array):void
		{
			this._controlsArray = value;
		}
		
		/**
		 * Constructor
		 *  
		 * @param map
		 * 
		 */		
		public function ControlContainer(map:Map)
		{
			super(); 
			this._map = map;
			this.initControlWithMap(map);
			addEventListener(MouseEvent.MOUSE_DOWN, stopPropagration);
			addEventListener(MouseEvent.MOUSE_UP, stopPropagration);
		}
		
		private function stopPropagration(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		protected function placeControl():void
		{
			//to be implemented by its subclass
		}
		
		protected function initControlWithMap(map:Map):void
		{
			//to be implemented by its subclass
		}
		
		public function addControl(control:IControl):void
		{
		}
		
		public function addControlAt(control:IControl, index:uint):void
		{
		}
		
		public function removeControl(control:IControl):void
		{
		}
		
		public function removeAllControls():void
		{
			  for (var i:uint = 0; i < this.numChildren; i++ )
			  {
			  		this.removeChildAt(i);
			  }
		}
		
		 
		/**
		 * Draw button with severval parameters and add the button the diplaylist
		 * 
		 * @param sprite		The sprite which loads the icon
		 * @param Icon			Icon class
		 * @param x				X coordinate for the sprite.
		 * @param y				Y coordinate for the sprite.
		 * @param buttonMode 	Sprite's buttonmode property
		 * @param handler		The handler which handles the mouse click event of the sprite
		 * @return 				Returns the sprite finished initialization.
		 * 
		 */		 	
		protected function drawButton(sprite:Sprite, Icon:Class, x:Number = 0, y:Number = 0, buttonMode:Boolean = true, handler:Function = null):Sprite
		{
			if (!sprite)
			{
				sprite = new Sprite();
			}
			
			if(this.contains(sprite))
			{
				this.removeChild(sprite);
			}		
			
			var content:* = new Icon();
			sprite.addChild(content);
			
			sprite.x = x;
			sprite.y = y;
			
			sprite.buttonMode = buttonMode;
			
			if (handler!= null)
			{
				sprite.addEventListener(MouseEvent.CLICK, handler);
			}
			this.addChild(sprite);
			return sprite;
		}		
	}
}
