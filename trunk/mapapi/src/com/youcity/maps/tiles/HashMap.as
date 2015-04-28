package com.youcity.maps.tiles
{
	import com.youcity.maps.tiles.layers.tiles.Tile;
	
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author Administrator
	 * HashMap主要的功能就是提供像Hash表一样的可以通过索引来添加，删除，检测，查找项的功能、
	 * 因为是一级的目录索引，所以会效率很高
	 * 
	 * 实现的时候主要通过Dictonary实现，相当于一般的Object
	 */	
	public class HashMap
	{
		private var _obj:Dictionary;
		private var _tilesNum:uint;
		public function get tilesNum():uint
		{
			return _tilesNum;
		}
		
		public function HashMap()
		{
			super();
			_obj = new Dictionary();
			_tilesNum = 0;
		}
		
		/**
		 * 
		 * @param value
		 * @param index
		 * 添加新项
		 */		
		public function putItem(value:Tile, index:String):void
		{
			if (hasOwnProperty(index)) return;
			_obj[index] = new HashMapItem();
			HashMapItem(_obj[index]).value = value;
			_tilesNum++;
		}
		
		/**
		 * 
		 * @param index
		 * @return 
		 * 通过索引得到某个值
		 */		
		public function getItem(index:String):HashMapItem
		{
			if (contains(index)) return _obj[index];
			else return null;
		}
		
		/**
		 * 
		 * @param index
		 * @return 
		 * 检测是否包含某个索引
		 */		
		public function contains(index:String):Boolean
		{
			if (_obj.hasOwnProperty(index)) return true;
			else return false;
		}
		
		/**
		 * 
		 * @param index
		 * @return 
		 * 根据key删除某项
		 */		
		public function deleteItem(index:String):HashMapItem
		{
			var t:HashMapItem;
			if (contains(index))
			{
				t = HashMapItem(_obj[index]);
				delete _obj[index];
				_tilesNum --;
			}
			return t;
		}
		
		/**
		 * 
		 * @return 
		 * 将哈希表里面的元素导入数组
		 */		
		public function toArray():Array
		{
			var rtn:Array = [];
			for each (var item:Object in _obj)
			{
				rtn.push(item);
			}
			return rtn;
		}
	}
}