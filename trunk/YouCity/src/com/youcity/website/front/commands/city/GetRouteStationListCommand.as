package com.youcity.website.front.commands.city
{
	import mx.collections.ArrayCollection;
	
	public class GetRouteStationListCommand extends CityCommand 
	{
	 	//override method
		override protected function handleResult(result:Object):void
		{
			cityModel.routStations = result as ArrayCollection;
		}		
		 
	}

}
