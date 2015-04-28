package com.youcity.website.front.view.building.base
{
	import com.youcity.website.front.controller.OtherED;
	import com.youcity.website.front.view.components.navigator.EDItemBase;

	public class BuildingItemBase extends EDItemBase
	{
		public function BuildingItemBase()
		{
			super(OtherED.getInstance(), OtherED.CURRENT_BUILDING_CHANGED);
		}
		
	}
}