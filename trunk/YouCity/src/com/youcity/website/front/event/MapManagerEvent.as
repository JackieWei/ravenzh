package com.youcity.website.front.event
{
	public class MapManagerEvent extends EventBase
	{
		public static const HOTSPOT_CLIKED:String = "hotspot_clicked";
		
		public static const ENCLOSURE:String = "enclosure";
		
		public static const ENCLOSURE_END:String = "enclosure_end";
		
		public static const END_ADDING_MARKER:String = "end_adding_marker";
		
		public static const END_DRAWING_LINE :String = "end_drawing_line";
		
		public function MapManagerEvent(type:String)
		{
			super(type);
		}
		
	}
}