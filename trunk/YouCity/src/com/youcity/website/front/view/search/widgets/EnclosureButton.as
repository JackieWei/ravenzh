package com.youcity.website.front.view.search.widgets
{
	import com.youcity.maps.Map;
	import com.youcity.maps.controls.ControlContainer;
	import com.youcity.website.front.event.MapManagerEvent;
	import com.youcity.website.front.view.common.MapManager;
	import com.youcity.website.front.view.common.ViewManager;
	import com.youcity.website.front.view.components.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;

	public class EnclosureButton extends ControlContainer
	{
		private var _button:Button;
		
		public function get selected():Boolean
		{
			return _button.selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_button.selected = value;
		}
		
		public function EnclosureButton(map:Map)
		{
			super(map);
			mouseChildren = false;
			buttonMode = true;
			var canvas:Canvas = new Canvas();
			_button = new Button();
			_button.label = "enclosure";
			canvas.addChild(_button);
			addChild(canvas);
			canvas.width = 100;
			canvas.height = 20;
			addEventListener(MouseEvent.CLICK, onClickHandler);
			addEventListener(Event.ADDED_TO_STAGE, onAddedHandler);
		}
		
		private function onAddedHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedHandler);
			var p:UIComponent = UIComponent(parent);
			setPosition(p);
			p.addEventListener(ResizeEvent.RESIZE, onresizeHandler);
		}
		
		private function onresizeHandler(event:ResizeEvent):void
		{
			setPosition(event.currentTarget as UIComponent);
		}
		
		private function setPosition(p:UIComponent):void
		{
			y = 20;
			x = p.width - 100 - 10;
		}
		
		private function onClickHandler(event:MouseEvent):void
		{
			selected = !selected;
			if (selected)
			{
				MapManager.getInstance().addEventListener(MapManagerEvent.ENCLOSURE, handleEnClosureEvent);
				MapManager.getInstance().startEnclosure();
			}
			else
			{
				MapManager.getInstance().removeEventListener(MapManagerEvent.ENCLOSURE, handleEnClosureEvent);
				MapManager.getInstance().stopEnclosure(true);
			}
		}
		
		private function handleEnClosureEvent(event:MapManagerEvent):void
		{
			ViewManager.getInstance().openView("searchView");
		}
	}
}