package com.youcity.maps.controls
{
	import com.youcity.maps.Map;
	import com.youcity.maps.MapEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * Draw maptype control. 
	 * @author Administrator
	 * 
	 */
	public class MapTypeControlContainer extends ControlContainer
	{
		private var mapTypeControl:MapTypeControl;
		
		public function MapTypeControlContainer(map:Map)
		{
			super(map);
			addEventListener(MouseEvent.MOUSE_DOWN, stopProHandler);
			map.addEventListener(MapEvent.MAPTYPE_ADDED, 	handleMapTypeAddedEvent);
			map.addEventListener(MapEvent.MAPTYPE_REMOVED, 	handleMapTypeRemovedEvent);
			map.addEventListener(MapEvent.MAP_SIZE_CHANGED, handleMapSizeChangedEvent);
		}
		
		/**
		 *set x and y value of the control 
		 * 
		 */		
		override protected function placeControl():void
		{
			this.x = map.size.x - 200;
			this.y = 20;
		}
		
		/**
		 * 
		 * @param map
		 * 
		 */		
		override protected function initControlWithMap(map:Map):void
		{
			super.initControlWithMap(map);
			
			mapTypeControl = new MapTypeControl(map);
			
			var mapTypeArr:Array = map.mapTypes;
			var controlWidth:Number = 0;
			for (var i:String in mapTypeArr)
			{
				var sprite:Sprite = new Sprite();
				sprite.buttonMode = true;
				sprite.mouseChildren = false;
				sprite.name = mapTypeArr[i].name;
				sprite.addEventListener(MouseEvent.CLICK, handleMouseClickEvent);
				sprite.graphics.lineStyle(1, 0x000000, 0.8);
				sprite.graphics.beginFill(0xffffff, 0.8);
				sprite.graphics.drawRect(0, 0, 60, 25);
				sprite.graphics.beginFill(0xffffff, 0.8);
				sprite.graphics.drawRect(2, 2, 56, 21);
				sprite.graphics.endFill();
				
				var textField:TextField = new TextField();
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.text = mapTypeArr[i].name;
				putChildAtCenter(textField, sprite);

				sprite.x = controlWidth;
				sprite.y = 0;
				controlWidth += sprite.width + 5;
				
				this.addChild(sprite);
				placeControl();
			}
		}
		
		private function stopProHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		private function handleMapTypeAddedEvent(event:MapEvent):void
		{
			this.initControlWithMap(event.currentTarget as Map);
		}
		
		private function handleMapTypeRemovedEvent(event:MapEvent):void
		{
			this.initControlWithMap(event.currentTarget as Map);
		}
		
		private function handleMapSizeChangedEvent(event:MapEvent):void
		{
			this.placeControl();
		}
		
		private function handleMouseClickEvent(event:MouseEvent):void
		{
			event.stopPropagation();
			var name:String = event.currentTarget.name;
			this.mapTypeControl.setMapType(name);
		}
		
		/**
		 * Put child object at the father object's center,
		 * father object should be the instance of DisplayObjectContainer.
		 *  
		 * @param child
		 * @param father
		 * 
		 */			
		private function putChildAtCenter(child:DisplayObject, father:DisplayObjectContainer):void
		{
			child.x = father.x + (father.width - child.width)/2;
			child.y = father.x + (father.height - child.height)/2;
			father.addChild(child);
		}
	}
}