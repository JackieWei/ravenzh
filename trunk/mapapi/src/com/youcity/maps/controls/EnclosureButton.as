package com.youcity.maps.controls
{
	import com.youcity.maps.AssetsEmbed;
	import com.youcity.maps.MapEvent;
	import com.youcity.maps.MapEventDispatcher;
	
	public class EnclosureButton extends ButtonControl
	{
		private static var UP:Class = AssetsEmbed.ENCLOSURE;
		private static var OVER:Class = AssetsEmbed.ENCLOSURE;
		private static var SELECTED:Class = AssetsEmbed.ENCLOSURE;
		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
		}
		
		public function EnclosureButton()
		{
			super();
		}
		
		override protected function setSkins():void
		{
			setUpKin(UP);
			setOverSkin(OVER);
			setSelectedSkin(SELECTED);
		}
		
	}
}