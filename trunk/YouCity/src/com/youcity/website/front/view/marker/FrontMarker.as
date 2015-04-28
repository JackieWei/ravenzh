package com.youcity.website.front.view.marker
{
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.overlays.OverlayBase;

	public class FrontMarker extends OverlayBase
	{
		protected var _data:Object;
		public function FrontMarker(position:ScreenPoint, data:Object)
		{
			super(this, position);
			_data = data;
		}
		
	}
}