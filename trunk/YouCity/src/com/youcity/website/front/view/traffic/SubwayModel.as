package com.youcity.website.front.view.traffic
{
	import com.youcity.website.front.vo.StationVO;
	
	public class SubwayModel
	{
		public static const ROUTE_PREFIX:String = "assets/traffic/routes";
		
		public static var subwayStations:Array;
		
		internal static var infoWin:SubwayInfo;
		
		[Bindable]
		public static var subWayInfo:StationVO;
		
		public static var currentRoute:String;
		
		public function SubwayModel()
		{
		}

	}
}