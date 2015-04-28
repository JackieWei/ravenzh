package com.youcity.maps.controls
{
	import flash.events.Event;

	public class ControlEvent extends Event
	{
		public static const FORWARD_WEST:String 	= "forwardWest";
		public static const FORWARD_NORTH:String	= "forwardNorth";
		public static const FORWARD_EAST:String	= "forwardEast";
		public static const FORWARD_SOUTH:String	= "forwardSouth";
		public static const MEASURE_START:String	= "measureStart";
		public static const MEASURE_END:String		= "measureEnd";
		public static const ZOOM_IN:String 		= "zoomIn";
		public static const ZOOM_OUT:String 		= "zoomOut";
		
		
		public function ControlEvent(type:String)
		{
			super(type, true);
//			stopPropagation();
		}
	}
}