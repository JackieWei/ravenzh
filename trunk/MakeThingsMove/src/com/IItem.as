package com
{
	import flash.display.BitmapData;
	
	public interface IItem
	{
		//物品数据getter和setter
		function get itemData():BaseItemData;
		function set itemData(value:BitmapData):void;
		
		
	}
}