package com.youcity.maps.controls
{
	import com.youcity.maps.Map;
	
	import flash.events.MouseEvent;
	
	/**
	 * Standard console include zoom controlContainer and postion controlcontainer 
	 * @author Administrator
	 * 
	 */	
	public class StandardControlContainer extends ControlContainer
	{
		private var _map:Map;
		
		private var _zoomControl:ZoomContainer;
		
		private var _positionControl:PositionContainer;
		
		public function StandardControlContainer(map:Map )
		{
			super(map);
			addEventListener(MouseEvent.MOUSE_DOWN, preventHandler);
		}
		
		private function preventHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		override protected function initControlWithMap(map:Map):void
		{
//			_positionControl = new PositionContainer(map);
//			this.addChild(_positionControl);
//			_zoomControl = new ZoomContainer(map);
//			_zoomControl.y = _positionControl.postionHeight;
//			_zoomControl.x = (_positionControl.postionWidth - _zoomControl.zoomWidth) / 2;
//			this.addChild(_zoomControl);
			_zoomControl = new ZoomContainer(map);
			_zoomControl.x = 20;
			_zoomControl.y = 20;
			addChild(_zoomControl);
		}

	}
}
