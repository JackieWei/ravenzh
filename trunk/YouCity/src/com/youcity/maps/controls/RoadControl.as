package com.youcity.maps.controls
{
	import com.youcity.maps.MapEvent;
	import com.youcity.maps.MapEventDispatcher;
	
	import flash.events.MouseEvent;

	public final class RoadControl extends ButtonControl
	{
/* 		[Embed(source="assets/console/road_normal.png")]
		public static var NORMAL:Class;
		[Embed(source="assets/console/road_over.png")]
		public static var OVER:Class;
		[Embed(source="assets/console/road_selected.png")]
		public static var SELECTED:Class;
		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
		}
		
		public function RoadControl()
		{
			super();
			addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
	 	protected function mouseClick(event:MouseEvent):void
		{
			selected = !selected;
		}
		
		override protected function setSkins():void
		{
			setUpKin(NORMAL);
			setOverSkin(OVER);
			setSelectedSkin(SELECTED);
		} */
		
/* 		override protected function mouseOver(event:MouseEvent):void
		{
			super.mouseOver(event);
			visible = true;
		}
		
		override protected function mouseOut(event:MouseEvent):void
		{
			super.mouseOut(event);
			visible = false;
		} */
	}
}