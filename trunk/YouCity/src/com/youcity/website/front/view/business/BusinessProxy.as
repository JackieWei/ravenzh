package com.youcity.website.front.view.business
{
	import com.youcity.website.front.common.Constants;
	import com.youcity.website.front.controller.OtherED;
	import com.youcity.website.front.model.OtherModelLocator;
	import com.youcity.website.front.proxy.TakeMeThere;
	import com.youcity.website.front.view.common.QueryManager;
	import com.youcity.website.front.view.common.ViewManager;
	import com.youcity.website.front.vo.BuildingVO;
	import com.youcity.website.front.vo.BusinessVO;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	public class BusinessProxy
	{
		private static var _instance:BusinessProxy;
		private static var key:Boolean;
		public static function get instance():BusinessProxy
		{
			if (!_instance)
			{
				key = true;
				_instance = new BusinessProxy();
			}
			return _instance;
		}
		
		public function BusinessProxy()
		{
			if (!key)
			{
				throw new Error("Singleton");
				return;
			}
			key = false;
		}
		
		public function openBusiness(business:BusinessVO, firstIndex:uint = 0, secondIndex:uint = 0):void
		{
			if (BusinessModel.currentBusiness != business)
			{
				BusinessModel.currentBusiness = business;
				OtherModelLocator.getInstance().currentBusinessId = business.id;
				OtherED.getInstance().dispatchEvent(new Event(OtherED.CURRENT_BUSINESS_CHANGED));
			}
			BusinessModel.firstIndex = firstIndex;
			BusinessModel.secondIndex = secondIndex;
			ViewManager.getInstance().openView("businessView");
		}
		
		public function openBusinessView(businessId:String, firstIndex:uint = 0, secondIndex:uint = 0):void
		{
			if (OtherModelLocator.getInstance().currentBusinessId != businessId)
			{
				OtherModelLocator.getInstance().currentBusinessId = businessId;
				OtherED.getInstance().dispatchEvent(new Event(OtherED.CURRENT_BUSINESS_CHANGED));
			}
			BusinessModel.firstIndex = firstIndex;
			BusinessModel.secondIndex = secondIndex;
			ViewManager.getInstance().openView("businessView");
		}
		
		public function closeBusinessView():void
		{
			BusinessModel.firstIndex = 0;
			BusinessModel.secondIndex = 0;
			BusinessModel.currentBusiness = null;
		}
		
		private var _takeMeThere:TakeMeThere;
		public function takeMeThere():void
		{
			if (_takeMeThere && _takeMeThere.refId == BusinessModel.currentBusiness.id)
			{
				_takeMeThere.locate();
				return;
			}
			if (_takeMeThere) _takeMeThere.clear();
			var centerX:Number = BusinessModel.currentBusiness.centerX;
			var centerY:Number = BusinessModel.currentBusiness.centerY;
			var id:String = BusinessModel.currentBusiness.id;
			var type:String = Constants.BUSINESS;
			_takeMeThere = new TakeMeThere(centerX, centerY, 650 + 80, 500 + 60, id, type);
			_takeMeThere.locate();
		}
		public function clearTakeMeThere():void
		{
			if (_takeMeThere) _takeMeThere.clear();
			_takeMeThere = null;
		}
		      
        public function getLinkAlert(businessId:String = null):void
        {
             if (!businessId) businessId = OtherModelLocator.getInstance().currentBusinessId;
             var link:String = QueryManager.instance.getRelativeLink(Constants.BUSINESS, businessId);
             BusinessModel.clipboard = link;
             ViewManager.getInstance().openView("businessGetlinkView");
        }
		
		/*********************************  event wrapper ********************************************************/
		public function getTags(callback:Function, container:UIComponent = null):void
		{
			new GetTags(callback, container);
		}
		
		public function getCategory(callback:Function, container:UIComponent = null):void
		{
			new GetCategory(callback, container);
		}
		
		public function getDetail(callback:Function, businessId:String = null, container:UIComponent = null):void
		{
			if (!businessId) businessId = OtherModelLocator.getInstance().currentBusinessId;
			new GetDetail(businessId, callback, container);
		}
		
		/*********************************  event wrapper end ********************************************************/
	}
}

import com.youcity.website.front.common.Constants;
import com.youcity.website.front.event.CommonEvent;
import mx.core.UIComponent;
import com.youcity.website.front.event.OtherEvent;
import com.youcity.website.front.view.common.CallbackData;
import flash.utils.Dictionary;
import mx.collections.ArrayCollection;
import com.youcity.website.front.model.OtherModelLocator;
import com.youcity.website.front.vo.BusinessCategoryVO;
import com.youcity.website.front.view.business.BusinessModel;
import com.youcity.website.front.controller.OtherED;
import com.youcity.website.front.vo.BusinessVO;
import com.youcity.website.front.view.common.MapManager;
import com.youcity.website.front.event.MapManagerEvent;
import com.youcity.website.front.view.business.BusinessProxy;
import com.youcity.website.front.view.building.BuildingProxy;
import com.youcity.website.front.proxy.ProxyBase;

class GetDetail extends ProxyBase
{
	public function GetDetail(businessId:String, callback:Function, container:UIComponent)
	{
		super(callback, container);
		var event:OtherEvent = new OtherEvent(OtherEvent.GET_BUSINESS_DETAILINFO);
		event.data = {businessId:businessId};
		dispatchEvent(event);
	}
}

class GetCategory extends ProxyBase
{
	public function GetCategory(callback:Function, container:UIComponent)
	{
		super(callback, container);
		var event:OtherEvent = new OtherEvent(OtherEvent.GET_BUSINESS_CATEGORYLIST);
		dispatchEvent(event)
	}
	
	override protected function callbackHandler(callbackData:CallbackData):void
	{
		super.callbackHandler(callbackData);
		if (CallbackData.SUCCEED == callbackData.code)
		{
			BusinessModel.categoryDict = new Dictionary();
			var list:ArrayCollection = OtherModelLocator.getInstance().business_categoryList;
			var item:BusinessCategoryVO;i
			for (var i:uint = 0; i < list.length; i++)
			{
				item = list[i] as BusinessCategoryVO;
				BusinessModel.categoryDict[item.categoryId] = item.categoryName;
			}
		}
	}
	
}

class GetTags extends ProxyBase
{
	public function GetTags(callback:Function, container:UIComponent)
	{
		super(callback, container);
		var event:CommonEvent = new CommonEvent(CommonEvent.GET_TAGS);
		event.data = {refType:Constants.BUSINESS, listNum:0};
		dispatchEvent(event);
	}
}
