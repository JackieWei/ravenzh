package com.youcity.website.front.commands.city
{
	import com.youcity.website.front.vo.CityVO;
	import mx.collections.ArrayCollection;
	
	public class GetCityListCommand extends CityCommand 
	{
	 	//override method
		override protected function handleResult(result:Object):void
		{
			cityModel.cityList = result as ArrayCollection;
			if (cityModel.cityList != null && cityModel.cityList.length > 0)
			{
				cityModel.currentCity = cityModel.cityList.getItemAt(0) as CityVO;
			}
		}		
		 
	}

}
