package com.youcity.website.front.commands.other
{
	import mx.collections.ArrayCollection;
	
	public class GetADManageListCommand extends OtherCommand
	{
		public function GetADManageListCommand()
		{
			super();
		}
		
		//override method
		override protected function handleResult(result:Object):void
		{
			otherModel.ads_list = result as ArrayCollection;
		}
	}
}