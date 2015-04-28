package com.youcity.website.front.commands.search
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.youcity.website.front.business.SearchServiceDelegate;
	import com.youcity.website.front.commands.CommandBase;
	import com.youcity.website.front.common.Constants;
	import com.youcity.website.front.event.EventBase;
	import com.youcity.website.front.model.SearchModelLocator;
	import com.youcity.website.front.util.AuxUtil;
	import com.youcity.website.front.util.DebugUtil;
	import com.youcity.website.front.vo.BuildingVO;
	import com.youcity.website.front.vo.BusinessVO;
	import com.youcity.website.front.vo.ResultVO;
	
	public class SearchCommand extends CommandBase
	{
		public var searchModel:SearchModelLocator = SearchModelLocator.getInstance();
		
		public function SearchCommand()
		{
			super();
		}
		
		override public function execute(event:CairngormEvent):void
		{
			if (!(event is EventBase))
				throw new Error("Event Type Mismatch, It should be a type of EventBase");
			
			callback = EventBase(event).callback;
			data = EventBase(event).data;
			
			if (event_mapping[event.type] == undefined)
				throw new Error("Event Mapping Not Found, PLS Check");
				
			if (searchModel.area_start)
			{
				this.data.startX = searchModel.area_start.x;
				this.data.startY = searchModel.area_start.y;
				this.data.endX = searchModel.area_end.x;
				this.data.endY = searchModel.area_end.y;
			}
			
			var mapping:Object = event_mapping[event.type];
			
	 		delegate = new SearchServiceDelegate(this, mapping.service);	
			delegate.call("", [this.data]);
			trace ("Event " + "\t" + event.type);
			trace ("Service" + "\t" + mapping.service);
			for (var prop:String in this.data)
			{
				trace(prop + "\t" + this.data[prop]);
			}
			trace("=============================================================");	
		}
		
		override protected function handleResult(result:Object):void
		{
			super.handleResult(result);
			
			switch (this.data.cl)
			{
				case Constants.SEARCHTYPE_BUILDING:
					searchModel.buildingResult = parseBuildingXML(result.buildingList);
					break;
				case Constants.SEARCHTYPE_BUSINESS:
					searchModel.businessResult = parseBusinessXML(result.businessList);
					break;
				case Constants.SEARCHTYPE_ACTIVITY:
					//todo 
					DebugUtil.debug();
					break;
			}
		}
		
		override protected function invokeCallback(result:Object):void
		{
			switch (this.data.cl)
			{
				case Constants.SEARCHTYPE_BUILDING:
					result = searchModel.buildingResult;
					break;
				case Constants.SEARCHTYPE_BUSINESS:
					result = searchModel.businessResult;
					break;
				case Constants.SEARCHTYPE_ACTIVITY:
					result = searchModel.activityResult;
					break;
			}
			super.invokeCallback(result);
		}
		
		
		override protected function appFault(errorCode:String, serverAppException:Object):void {
			super.appFault(errorCode, serverAppException);
			searchModel.buildingResult = new ResultVO();
			searchModel.businessResult = new ResultVO();
			searchModel.activityResult = new ResultVO();
		}
		
		private function parseBusinessXML(businessXML:XMLList):ResultVO {
			var businessResult:ResultVO = new ResultVO();
			businessResult.totalNum = businessXML.totalPage;
			businessResult.resultList = new Array();
			
			var business:XMLList = businessXML.business;
			for each (var item:XML in business) {
				var vo:BusinessVO = new BusinessVO();
				vo.id 	= item.@id;
				vo.businessName = item.@name;
				vo.businessContent = item.content;
				vo.buildingId = item.building.@id;
				vo.buildingName = item.building.@name;
				vo.centerX = item.location.@centerX;
				vo.centerY = item.location.@centerY;
				vo.phoneNumber = item.phoneNumber;
				vo.address = item.address;
				vo.website = item.website;
				businessResult.resultList.push(vo);
			}
			return businessResult;
		}
		
		private function parseBuildingXML(buildingXML:XMLList):ResultVO {
			var buildingResult:ResultVO = new ResultVO();
			buildingResult.totalNum = buildingXML.totalPage;
			buildingResult.resultList = new Array();
			
			var building:XMLList = buildingXML.building;
			for each (var item:XML in building) {
				var vo:BuildingVO = new BuildingVO();
				vo.buildingId = item.@id;
				vo.buildingName = item.@name;
				vo.buildingContent = item.content;
				vo.centerX = item.location.@centerX;
				vo.centerY = item.location.@centerY;
				vo.phoneNumber = item.phoneNumber;
				vo.address = item.address;
				
				buildingResult.resultList.push(vo);
			}
			return buildingResult;
		}
		
	}
}