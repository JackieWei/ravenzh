package com.youcity.maps.tiles
{
	import com.youcity.maps.tiles.layers.tiles.Tile;
	
	/**
	 * 
	 * @author Administrator
	 * 哈希表的项，本来是应当作为父类可以呗扩展的，但是没有相关的需求所以直接在一个类里写完了，主要是添加了
	 * 一个标志位，needRemove，标识是否可以被移除
	 */	
	public class HashMapItem
	{
		private var _needRemove:Boolean;
		public function get needRemove():Boolean
		{
			return _needRemove;
		}
		public function set needRemove(value:Boolean):void
		{
			_needRemove = value;
		}
		
		private var _value:Tile;
		public function get value():Tile
		{
			return _value;
		}
		public function set value(value:Tile):void
		{
			_value = value;
		}
		
		public function HashMapItem()
		{
		}

	}
}