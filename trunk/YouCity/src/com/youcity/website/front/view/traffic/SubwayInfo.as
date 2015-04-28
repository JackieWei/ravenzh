package com.youcity.website.front.view.traffic
{
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.overlays.InfoWindow;
	
	public class SubwayInfo extends InfoWindow
	{
		private var _subwayInfo:SubwayInfoContent;
		
		public function SubwayInfo(position:ScreenPoint)
		{
			super(this, position);
			_subwayInfo = new SubwayInfoContent();
			addChild(_subwayInfo);
			
			offsetX = -18;
			offsetY = 50;
			setOverlayPosition(position);
		}
	}
}