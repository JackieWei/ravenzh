package com.youcity.website.front.controller
{
	import com.adobe.cairngorm.control.FrontController;
	import com.youcity.website.front.commands.city.GetRouteStationListCommand;
	import com.youcity.website.front.commands.common.GetTagsByBusinessCategoryCommand;
	import com.youcity.website.front.commands.common.GetTagsCommand;
	import com.youcity.website.front.commands.other.GetADManageListCommand;
	import com.youcity.website.front.commands.other.GetBuildingBusinessListCommand;
	import com.youcity.website.front.commands.other.GetBuildingDetailInfoCommand;
	import com.youcity.website.front.commands.other.GetBusinessCategoryListCommand;
	import com.youcity.website.front.commands.other.GetBusinessDetailInfoCommand;
	import com.youcity.website.front.commands.other.GetBusinessNoteListCommand;
	import com.youcity.website.front.commands.other.GetPolyGonByRefIdCommand;
	import com.youcity.website.front.commands.search.SearchCommand;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	public class MainController extends FrontController
	{	
		GetRouteStationListCommand;
		GetTagsByBusinessCategoryCommand;
		GetTagsCommand;

		GetADManageListCommand;

		GetBuildingBusinessListCommand;
		GetBuildingDetailInfoCommand;
		
		GetBusinessCategoryListCommand;
		GetBusinessDetailInfoCommand;
		GetPolyGonByRefIdCommand;

		SearchCommand;
		
		public function MainController()
		{
			super();
		}
		
		public function initCommand(dic:Dictionary):void
		{
			for (var event:String in dic)
			{
				var command:Class;
				try
				{
					command = Class(getDefinitionByName(dic[event].command));
				}
				catch(error:Error)
				{
					trace(error.message);
				}
				addCommand(event, command, true);
			}
		}
		
	}
}