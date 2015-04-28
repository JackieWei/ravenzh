package com.youcity.website.front.view.building
{
	import com.youcity.maps.MapPoint;
	import com.youcity.website.front.common.Constants;
	import com.youcity.website.front.controller.OtherED;
	import com.youcity.website.front.model.OtherModelLocator;
	import com.youcity.website.front.proxy.TakeMeThere;
	import com.youcity.website.front.view.common.QueryManager;
	import com.youcity.website.front.view.common.ViewManager;
	import com.youcity.website.front.view.search.SearchProxy;
	import com.youcity.website.front.vo.BuildingVO;
	import com.youcity.website.front.vo.BusinessVO;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	public class BuildingProxy
	{
		private static var _instance:BuildingProxy;
		private static var key:Boolean;
		public static function get instance():BuildingProxy
		{
			if (!_instance)
			{
				key = true;
				_instance = new BuildingProxy();
			}
			return _instance;
		}
		
		public function BuildingProxy()
		{
			if (!key)
			{
				throw new Error("Singleton");
				return;
			}
			key = false;
		}
		
		private var _otherModel:OtherModelLocator = OtherModelLocator.getInstance();
		
		//使用一个id打开building
		public function openBuilding(buildingId:String, topIndex:uint = 0, seconIndex:uint = 0):void
		{
			_otherModel.currentBuildingId = buildingId;
			OtherED.getInstance().dispatchEvent(new Event(OtherED.CURRENT_BUILDING_CHANGED));
			internalOpenBuilding(topIndex, seconIndex);
		}
		
		//直接给building赋值打开building
		public function openBuildingView(building:BuildingVO, topIndex:uint = 0, seconIndex:uint = 0):void
		{
			BuildingModel.currentBuilding = building;
			OtherED.getInstance().dispatchEvent(new Event(OtherED.CURRENT_BUILDING_CHANGED));
			internalOpenBuilding(topIndex, seconIndex);
		}
		
		private function internalOpenBuilding(topIndex:uint = 0, seconIndex:uint = 0):void
		{
			BuildingModel.firstIndex = topIndex;
			BuildingModel.secondIndex = seconIndex;
			ViewManager.getInstance().openView("buildingView");
		}
		
		//current now no need to open building detail
		public function closeCreateBusinessView():void
		{
			ViewManager.getInstance().closeView("addBusinessView");
		}
		
		public function openCreateActivity():void
		{
			ViewManager.getInstance().openView("addBusinessView");
		}
		
		public function searchNearby():void
		{
			var point:MapPoint = new MapPoint(BuildingModel.currentBuilding.centerX, BuildingModel.currentBuilding.centerY);
			var name:String = BuildingModel.currentBuilding.buildingName;
			SearchProxy.instance.openNearBySearch(point, name);
		}
		
		private var _takeMeThere:TakeMeThere;
		public function takeMeThere():void
		{
			if (_takeMeThere && _takeMeThere.refId == BuildingModel.currentBuilding.buildingId)
			{
				_takeMeThere.locate();
				return;
			}
			if (_takeMeThere) _takeMeThere.clear();
			var centerX:Number = BuildingModel.currentBuilding.centerX;
			var centerY:Number = BuildingModel.currentBuilding.centerY;
			var id:String = BuildingModel.currentBuilding.buildingId;
			var type:String = Constants.BUILDING;
			_takeMeThere = new TakeMeThere(centerX, centerY, 790 + 80, 500 + 60, id, type);
			_takeMeThere.locate();
		}
		
		public function clearTakeMeThere():void
		{
			if (_takeMeThere) _takeMeThere.clear();
			_takeMeThere = null;
		}
		
        public function getLinkAlert(buildingId:String = null):void
        {
             if (!buildingId) buildingId = OtherModelLocator.getInstance().currentBuildingId;
             var link:String = QueryManager.instance.getRelativeLink(Constants.BUILDING, buildingId);
             BuildingModel.clipboard = link;
             ViewManager.getInstance().openView("buildingGetlinkView");
        }
		
		/**************   event delegate *****************************/
		public function getDetail(callback:Function, buildingId:String = null, container:UIComponent = null):void
		{
			if (!buildingId) buildingId = OtherModelLocator.getInstance().currentBuildingId;
			new GetDetail(buildingId, callback, container);
		}
		
		public function getBusiness(callback:Function, verifyStatus:String, buildingId:String = null, container:UIComponent = null):void
		{
			if (!buildingId) buildingId = OtherModelLocator.getInstance().currentBuildingId;
			getBusinessByBuilding(_otherModel.currentBuildingId,  callback, verifyStatus, container);
		}
		
		public function getBusinessByBuilding(buildingId:String,callback:Function, verifyStatus:String, container:UIComponent = null):void
		{
			new GetBusiness(buildingId, verifyStatus, callback, container);
		}
		
		public function getTagsByCategory(categoryId:Number, callback:Function):void
		{
			new GetTagsByCategory(categoryId, callback, null);
		}
		
		public function getTags(callback:Function, container:UIComponent = null):void
		{
			new GetTags(callback, container);
		}
	}
}

import mx.core.UIComponent;
import com.youcity.website.front.view.common.CallbackData;
import com.youcity.website.front.view.building.BuildingModel;
import com.youcity.website.front.vo.BuildingVO;
import com.youcity.website.front.event.OtherEvent;
import com.youcity.website.front.vo.BusinessVO;
import com.youcity.website.front.view.common.MapManager;
import com.youcity.website.front.event.MapManagerEvent;
import com.youcity.website.front.view.building.BuildingED;
import flash.events.Event;
import com.youcity.website.front.event.CommonEvent;
import com.youcity.website.front.common.Constants;
import com.adobe.utils.StringUtil;
import com.youcity.website.front.controller.OtherED;
import com.youcity.website.front.view.building.BuildingProxy;
import com.youcity.website.front.proxy.ProxyBase;

class GetTags extends ProxyBase
{
	public function GetTags(callback:Function, container:UIComponent)
	{
		super(callback, container);
		var event:CommonEvent = new CommonEvent(CommonEvent.GET_TAGS);
		event.data = {refType:Constants.BUILDING, listNum:0};
		dispatchEvent(event);
	}
}

class GetTagsByCategory extends ProxyBase
{
	public function GetTagsByCategory(categoryId:Number, callback:Function, container:UIComponent):void
	{
		super(callback, container);
		var event:CommonEvent = new CommonEvent(CommonEvent.GET_TAGS_BY_BUSINESS_CATEGORY);
		event.data = {categoryId:categoryId};
		dispatchEvent(event);
	}
}

class GetBusiness extends ProxyBase
{
	public function GetBusiness(buildingId:String, verifyStatus:String, callback:Function, container:UIComponent)
	{
		super(callback, container);
		var event:OtherEvent = new OtherEvent(OtherEvent.GET_BUILDING_BUSINESSLIST);
		event.data = {buildingId:buildingId, verifyStatus:verifyStatus};
		dispatchEvent(event);
	}
}


class GetDetail extends ProxyBase
{
	public function GetDetail(bid:String, callback:Function, caontainer:UIComponent)
	{
		super(callback, caontainer);
		var e:OtherEvent = new OtherEvent(OtherEvent.GET_BUILDING_DETAILINFO);
		e.data = {buildingId:bid};
		dispatchEvent(e);
	}
}

