package com.youcity.website.front.commands.other
{
	import com.youcity.website.front.vo.BusinessVO;
	import mx.collections.ArrayCollection;
	
	public class GetBuildingBusinessListCommand extends OtherCommand
	{
		public function GetBuildingBusinessListCommand()
		{
			super();
		}
		
		//override method
		override protected function handleResult(result:Object):void
		{
			var _result:ArrayCollection = result as ArrayCollection;
			if (BusinessVO.VERIFIED == data.verifyStatus)
				otherModel.building_businessList_normal = _result;
			else if (BusinessVO.ADDED == data.verifyStatus)
				otherModel.building_businessList_added = _result;
			else if (BusinessVO.RELOCATE == data.verifyStatus)
				otherModel.building_businessList_relocated = _result;
			else
				throw new Error("out of range");
		}
	}
}