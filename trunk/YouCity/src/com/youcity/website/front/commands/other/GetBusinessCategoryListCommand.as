package com.youcity.website.front.commands.other
{
	import mx.collections.ArrayCollection;
	
	public class GetBusinessCategoryListCommand extends OtherCommand
	{
		public function GetBusinessCategoryListCommand()
		{
			super();
		}
		
		//override method
		override protected function handleResult(result:Object):void
		{
			otherModel.business_categoryList = result as ArrayCollection;
		}
	}
}