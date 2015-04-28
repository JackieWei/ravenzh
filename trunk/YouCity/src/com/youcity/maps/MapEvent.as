package com.youcity.maps
{
	import flash.events.Event;

	/**
	 * Map Event Class
	 * @author Jackie Wei
	 * Map的事件类型，主要供Map内部使用以及对外提供
	 * 有一个属性data，为object类型，主要用来在某些时候传输
	 * 数据的
	 * 另外一个selected属性应当是没有了
	 */	
	public class MapEvent extends Event
	{
		public static const MAP_READY:String = "map_ready";//dispatch when map is ready to show
		public static const MAP_PROGRESS:String = "map_progress";//dispatch when map images loading
		public static const MAP_LOADED:String = "map_loaded";//dispatch when map images load completed
		public static const MAP_MOVE:String = "map_move";//dispatch when center point changed
		public static const MAP_SIZE_CHANGED:String = "size_changed";//dispatch when map container's size changed
		public static const MAP_DRAG_BEGIN:String = "drag_begin";//dispatch when map container's size changed
		public static const MAP_DRAGGING:String = "dragging";//dispatch when map container's size changed
		public static const MAP_DRAG_END:String = "drag_end";//dispatch when map container's size changed
		public static const MAP_DIRECTION_CHANGED:String = "direction_changed";
		
		public static const MAPTYPE_CHANGED:String = "maptype_changed";//dispatch when maptype point changed
		public static const MAPTYPE_ADDED:String = "maptype_added";//new maptype added
		public static const MAPTYPE_REMOVED:String = "maptype_removed";
		
		public static const ZOOM_CHANGED:String = "zoom_changed";//dispatch when center point changed
		
		public static const CONTROL_ADDED:String = "control_added";//
		public static const CONTROL_REMOVED:String = "control_removed";//new control added
		
		public static const OVERLAY_CHANGED:String = "overlay_changed";//overlay变化
		public static const OVERLAY_ADDED:String = "overlay_added";//添加overlay
		public static const OVERLAY_REMOVED:String = "overlay_removed";//移除overlay
		
		public static const INFOWINDOW_CLOSED:String = "infowindow_closed";//infowin 关闭
		public static const INFOWINDOW_CLOSING:String = "infowindow_closing";
		public static const INFOWINDOW_OPENDED:String = "infowindow_opened";
		
		public static const HOTSPOT_CLICKED:String = "hotspot_clicked";
		public static const SUBWAY_CLICKED:String = "subway_clicked";
		
		public static const ENCLOSURE_START:String = "enclosure_start";
		public static const ENCLOSURE_STOP:String = "enclosure_stop";
		
		public static const MEASURE_START:String = "measure_start";
		public static const MEASURE_END:String = "measure_end";
		
		public static const CITY_CHANGED:String = "city_changed";
		
		private var _data:Object;
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
		}	
		
		public var selected:Boolean;
		
		/**
		 * @Constructor
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function MapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super(type, bubbles, cancelable);
		}
	}
}