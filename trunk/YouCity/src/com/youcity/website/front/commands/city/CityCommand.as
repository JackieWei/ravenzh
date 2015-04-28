package com.youcity.website.front.commands.city
{
	import com.youcity.website.front.commands.CommandBase;
	import com.youcity.website.front.model.CityModelLocator;
	
	public class CityCommand extends CommandBase
	{
		protected var cityModel:CityModelLocator = CityModelLocator.getInstance();
		public function CityCommand()
		{
			super();
		}
		
	}
}