package com.youcity.website.front.view.components
{
	import com.youcity.website.front.common.Constants;
	import com.youcity.website.front.util.AuxUtil;
	
	public class AvatorImageUI extends ImageUI
	{
		public function AvatorImageUI()
		{
			super();
			buttonMode = true;
			brokenImage = Constants.AVATOR_BROKEN_IMAGE;
		}
		
		override public function set source(value:String):void
		{
			super.source = AuxUtil.generateAvator(value);
		}
		
	}
}