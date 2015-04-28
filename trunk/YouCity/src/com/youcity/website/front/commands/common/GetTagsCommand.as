package com.youcity.website.front.commands.common
{
	import com.youcity.website.front.common.Constants;
	import com.youcity.website.front.model.OtherModelLocator;
	import com.youcity.website.front.util.DebugUtil;
	
	import mx.collections.ArrayCollection;

	public class GetTagsCommand extends CommonCommand 
	{
		//override method
		override protected function handleResult(result:Object):void
		{
			var _result:ArrayCollection = result as ArrayCollection;
			if (Constants.BUSINESS == data.refType)
				OtherModelLocator.getInstance().business_tags = _result;
			else if (Constants.BUILDING == data.refType)
				OtherModelLocator.getInstance().building_tags = _result;
			else if (Constants.ACTIVITY == data.refType) {
				DebugUtil.debug();
			}else {
				throw new Error("Type out of range");
			}
		}
	
	}
}

 
