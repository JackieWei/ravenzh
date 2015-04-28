package com.youcity.maps
{
	/**
	 * 资源的集合，这个可能需要修改。目前没有想到更好的方式管理这些潜入资源，不过从技术上看，Flex肯定不会做这么重复的工作，所以即使
	 * 在一个工程的很多地方潜入相同的资源，也应该不会浪费的，前提是路径，文件名都一样，复制的不可以。
	 * */
	public class AssetsEmbed
	{
		[Embed(source="assets/console/maptype_2d.png")]
		public static var MAPTYPE_2D:Class;
		
		[Embed(source="assets/console/maptype_3d.png")]
		public static var MAPTYPE_3D:Class;
		
		[Embed(source="assets/console/maptype_sat.png")]
		public static var MAPTYPE_SAT:Class;
		
		[Embed(source="assets/console/measure.png")]
		public static var MEASURE:Class;
		
		[Embed(source="assets/console/subway.png")]
		public static var SUBWAY:Class;
		
		[Embed(source="assets/console/enclosure.png")]
		public static var MAPTYPE_CLARITY:Class;
		
		[Embed(source="assets/console/enclosure.png")]
		public static var ENCLOSURE:Class;
		
		[Embed(source="assets/console/minimap_hidebutton_up.png")]
		public static var MINIMAP_HIDEBUTTON_UP:Class;
		
		[Embed(source="assets/console/minimap_hidebutton_down.png")]
		public static var MINIMAP_HIDEBUTTON_DOWN:Class;
		
		[Embed(source="assets/console/position_control_2d.png")]
		public static var POSITION_CONTROL_2D:Class;
		
		[Embed(source="assets/console/position_control_3d.png")]
		public static var POSITION_CONTROL_3D:Class;
		
		[Embed(source="assets/console/zoom_tree.png")]
		public static var ZOOMCONTROL_TREE:Class;

		[Embed(source="assets/console/zoom_level.png")]
		public static var ZOOMCONTROL_LEVEL:Class;

		[Embed(source="assets/console/zoom_slider.png")]
		public static var ZOOMCONTROL_SLIDE:Class;
		
		[Embed(source="assets/console/flag.gif")]
		public static var OVERLAY_MARKER_ICON:Class;
		
		[Embed(source="assets/tile_default_bg.jpg")]
		public static var MAP_TILE_DEFAULT_BG:Class;
	}
}