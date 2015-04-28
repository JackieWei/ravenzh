package com.youcity.website.front.view.search.marker
{
	import com.youcity.maps.ScreenPoint;
	import com.youcity.website.front.util.DebugUtil;
	import com.youcity.website.front.view.building.BuildingProxy;
	import com.youcity.website.front.view.business.BusinessProxy;
	import com.youcity.website.front.view.marker.FrontMarker;
	import com.youcity.website.front.view.search.widgets.CharItem;
	import com.youcity.website.front.vo.BuildingVO;
	import com.youcity.website.front.vo.BusinessVO;
	
	import flash.events.MouseEvent;

	public final class SearchMarker extends FrontMarker
	{
		[Embed(source="assets/search/label_item.png")]
		public var ACTIVITY_MARKER:Class;
		
		private var _searchData:Object;
		
		private var ui:CharItem;
		
		public function SearchMarker(position:ScreenPoint, data:Object, index:int)
		{
			super(position, data);
			addEventListener(MouseEvent.MOUSE_OVER, show);
			addEventListener(MouseEvent.MOUSE_OUT, hide);
			addEventListener(MouseEvent.CLICK, onMarkerClickHandler);
			this._searchData=data;

            ui = new CharItem();
            ui.char=index;
			addChild(ui);
			mouseChildren = false;
			buttonMode = true;
		}
		
		override protected function draw():void
		{
			
		}
		
		private var _tip:*;
		private function show(event:MouseEvent):void
		{
 			if (!_tip) 
			{
				if(_searchData is BuildingVO) {
					_tip = new SearchBuildingTip();
					_tip.buildingInfo = BuildingVO (_searchData);
				} else if(_searchData is BusinessVO) {
					_tip = new SearchBusinessTip();
					_tip.businessInfo = BusinessVO (_searchData);
				} else {
				    return;
				}
				
				_tip.x = ui.width;
				_tip.y = -10;
			}
			if (!contains(_tip))
				addChild(_tip); 
		}
		
		private function hide(event:MouseEvent):void
		{
			if (_tip && contains(_tip))
			{
				removeChild(_tip);
			} 
		}
		
		private function onMarkerClickHandler(event:MouseEvent):void
		{
			if(_searchData is BuildingVO){
				BuildingProxy.instance.openBuilding(BuildingVO (_searchData).buildingId);
			}else if(_searchData is BusinessVO){
				BusinessProxy.instance.openBusinessView(BusinessVO (_searchData).id);
			}else{
			    return;
			}
		}
	}
}