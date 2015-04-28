package com.youcity.website.front.view.marker
{
	import com.youcity.website.front.view.common.MapManager;
	
	internal class MarkerManager
	{
		protected var map:MapManager = MapManager.getInstance();
		private var _markers:Array;
		private var _source:Array;
		public function MarkerManager()
		{
			
		}
		
		public function set source(value:Array):void
		{
			if (_source)
				hide();
			_source = value;
			show();
		}
		
		public function show():void
		{
			if (!_source) return;
			if(!map) 
			    map = MapManager.getInstance();
			_markers = [];
			var item:Object;
			var _marker:FrontMarker;
			for (var i:uint = 0; i< _source.length; i++)
			{
				item = _source[i];
				if (!item.hasOwnProperty("centerX") || !item.hasOwnProperty("centerY"))
				{
					throw new Error("Not centerX or centerY for position!");
					return;
				}
				_marker = getMarker(item,i); 
				_markers.push(_marker);
				map.addOverlay(_marker);
			}
		}
		
		public function hide():void
		{
			if (!_source) return;
			if (_markers)
			{
				while(_markers.length > 0)
					map.removeOverlay(_markers.pop());
			}
			_markers = null;
		}
		
		public function clear():void
		{
			hide();
			_markers = null;
			map = null;
			_source = null;
		}
		
		protected function getMarker(item:Object, index:int):FrontMarker
		{
			return null;
		}
	}
}