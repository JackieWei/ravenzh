package com.youcity.website.front.view.business.base
{
	import com.youcity.website.front.controller.OtherED;
	import com.youcity.website.front.view.components.navigator.EDItemBase;

	public class BusinessItemBase extends EDItemBase
	{
		public function BusinessItemBase()
		{
			super(OtherED.getInstance(), OtherED.CURRENT_BUSINESS_CHANGED);
		}
		
	}
}