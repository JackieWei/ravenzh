package com.youcity.website.front.view.common
{
	import com.youcity.website.front.util.AuxUtil;
	import com.youcity.website.front.util.EventUtil;
	import com.youcity.website.front.view.building.BuildingGetlinkView;
	import com.youcity.website.front.view.building.BuildingView;
	import com.youcity.website.front.view.business.BusinessGetlinkView;
	import com.youcity.website.front.view.business.BusinessView;
	import com.youcity.website.front.view.measure.MeasureResultView;
	import com.youcity.website.front.view.search.SearchBoxView;
	import com.youcity.website.front.view.traffic.RouteView;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import gs.TweenLite;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	[Event(name = "close_view", type = "com.youcity.website.front.view.common.event")]
	public class ViewManager extends EventDispatcher
	{
	
		private var _contentVeil:ContentVeil;
		
		private var _viewWidth:Number = 0;
		/**
		 * Read-Only 
		 * @return 
		 * 
		 */		
		public function get viewWidth():Number
		{
			return _viewWidth;
		}
		
		private var _viewHeight:Number = 0;
		/**
		 * Read-Only 
		 * @return 
		 * 
		 */		
		public function get viewHeight():Number
		{
			return _viewHeight;
		}
		
		
		
		private static var _instance:ViewManager;
		
		private var viewContainer:UIComponent;
		
		private var _viewClassDictionary:Dictionary 	= new Dictionary();
		private var _viewInstanceDictionary:Dictionary = new Dictionary();
		
		
		public function ViewManager()
		{
			if (_instance)
			{
				throw new Error("ViewManager can only have one instance");
			}
		}
		
		public static function getInstance():ViewManager
		{
			if (!_instance)
			{
				_instance = new ViewManager();	
			}
			return _instance;
		}
		
		public function init(container:UIComponent):void
		{
			viewContainer = container;
			_viewWidth = viewContainer.width;
			_viewHeight = viewContainer.height;
			_contentVeil = new ContentVeil(viewContainer, null);
			//商家
			register("businessView", 		BusinessView);
			register("businessGetlinkView", 	BusinessGetlinkView);
			//建筑
			register("buildingView", 	BuildingView);
			register("buildingGetlinkView", 	BuildingGetlinkView);
			//地铁线路图
			register("routeView", 	RouteView);
			//搜索界面
			register("searchView",		SearchBoxView);
			
			register("measureResultView", 	MeasureResultView);
		}
		
		private function register(viewID:String, viewClass:Class):void
		{
//			_viewInstanceDictionary[viewID] = new viewClass();
			_viewClassDictionary[viewID] = viewClass;
		}
		
		public function openView(viewID:String, position:Point = null):Boolean
		{
			var viewInstance:DisplayObject;
			
			if (_viewInstanceDictionary[viewID])
			{
				viewInstance = _viewInstanceDictionary[viewID];
			}
			else
			{
				if (!_viewClassDictionary[viewID])
				{
					throw new Error(viewID + " has not been registered yet!");
					return;
				}
				viewInstance = new _viewClassDictionary[viewID]();
				_viewInstanceDictionary[viewID] = viewInstance;
			}
			
			if (viewContainer.contains(viewInstance))
			{
				this.focusView(viewID);
				return false;
			}
			var instance:ViewBase = ViewBase(viewInstance);
			if (position)
			{
				var _position:Point = Application.application.globalToLocal(position);
				instance.x = _position.x;
				instance.y = _position.y;
			}
			else
			{
				instance.x = (viewContainer.width - instance.width) / 2;
				instance.y = (viewContainer.height - instance.height) / 2;
			}
			
			viewContainer.addChild(instance);
			return true;
		}
		
		public function closeView(viewID:String):Boolean
		{
			var viewInstance:ViewBase;
			
			if (!_viewClassDictionary[viewID])
			{
				throw new Error(viewID + "has not been registered yet!");
				return false;
			}
			
			if (!_viewInstanceDictionary[viewID])
			{
//				throw new Error("We don't have this instance!");
				return false;
			}
			
			viewInstance = _viewInstanceDictionary[viewID];
			
			/* if (viewInstance.hasOwnProperty("removeable") && viewInstance.removeable)
			{
				delete _viewInstanceDictionary[viewID];
			} */
			
			if (!viewContainer.contains(viewInstance))
			{
				return false;
			}
			viewContainer.removeChild(viewInstance);
			delete _viewInstanceDictionary[viewID];
			viewInstance.dispatchEvent(new Event(ViewBase.EVENT_CLOSE_VIEW));	 
			return true;
		}
		
		public function clear():void
		{
			for (var obj:Object in _viewInstanceDictionary)
			{
				if (obj is String && String(obj) != "sideView")
				{
					closeView(obj as String);
				}
			}
		}
		
		public function getView(viewID:String):ViewBase
		{
			return _viewInstanceDictionary[viewID] ? _viewInstanceDictionary[viewID] as ViewBase : null;
		}
		
		public function changeView(tobeClosed:ViewBase, tobeOpened:String):Boolean
		{
			//to do
			return true;
		}
		
		public function focusView(viewID:String):void
		{
			viewContainer.setChildIndex(_viewInstanceDictionary[viewID], viewContainer.numChildren - 1);
			//to do 
		}
		
		public function showveil():void
		{
			_contentVeil.showveil();
		}
		
		public function unveil():void
		{
			_contentVeil.unveil();
		}
		
	}
}