package com.youcity.website.front.view.ads.base
{
	import com.youcity.maps.Map;
	import com.youcity.maps.MapBound;
	import com.youcity.maps.MapEvent;
	import com.youcity.maps.MapPoint;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.overlays.OverlayBase;
	import com.youcity.website.front.event.OtherEvent;
	import com.youcity.website.front.model.OtherModelLocator;
	import com.youcity.website.front.view.ads.ADItem;
	import com.youcity.website.front.view.ads.ImgBillBoard;
	import com.youcity.website.front.view.common.CallbackData;
	import com.youcity.website.front.vo.AdManageVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	
	public final class AdsManager
	{
		private static var _instance:AdsManager;
		private static var key:Boolean;
		public static function get instance():AdsManager
		{
			if (!_instance)
			{
				key = true;
				_instance = new AdsManager();
			}
			return _instance;
		} 
		public function AdsManager()
		{
			if (!key) 
			{
				throw new Error("Singleton");
				return;
			}
			key = false;
		}
		
		private var map:Map;
		
		private var _adsDictionary:Dictionary = new Dictionary(true);
		
		private var _leftTop:ScreenPoint;
		private var _rightBottom:ScreenPoint;
		
		private function setBound():void
		{
			_leftTop = map.bound.ltPoint;
			_leftTop.offset(-500, -500);
			_rightBottom = map.bound.rbPoint;
			_rightBottom.offset(500, 500);
		}
		
		public function initialize(map:Map):void
		{
//			return;
			this.map = map;
			setBound();
			_adsDictionary = new Dictionary(true);
			_adsDictionary.length = 0;
			map.addEventListener(MapEvent.MAP_DIRECTION_CHANGED,changeHandler);
			map.addEventListener(MapEvent.MAP_MOVE,changeHandler);
			map.addEventListener(MapEvent.MAP_SIZE_CHANGED,changeHandler);
			map.addEventListener(MapEvent.ZOOM_CHANGED,changeHandler);
		}
		
		private function changeHandler(event:Event):void
		{
			if (!checkBound())
			{
				setBound();
//				loadNewData();
			}
		}
		
		private function loadNewData():void
		{
			var event:OtherEvent = new OtherEvent(OtherEvent.GET_AD_MANAGE_LIST);
			var bound:MapBound = map.bound;
			event.data = {zoom:map.zoom, max_x:bound.rbMapPoint.x, min_x:bound.ltMapPoint.x, max_y:bound.rbMapPoint.y,min_y:bound.ltPoint.y};
		    event.callback = getAdsDataCallbackHandler;
		    event.dispatch();
		}
		
		private function getAdsDataCallbackHandler(callbackData:CallbackData):void
		{
			if (CallbackData.SUCCEED == callbackData.code)
			{
				compareLists(OtherModelLocator.getInstance().ads_list.source);
			}
			else
			{
				compareLists([]);
			}
		}
		
		private function compareLists(toCompareList:Array):void
		{
			var item:AdManageVO;
		    for (var i:uint = 0; i < toCompareList.length; i++)
		    {
		    	item = toCompareList[i] as AdManageVO;
		    	if (null == _adsDictionary[item.id]) addAd(item)
		    }
		}
		
		private function removeAd(item:AdManageVO):void
		{
			map.removeOverlay(OverlayBase(_adsDictionary[item.id]))
			_adsDictionary.length --;
			delete _adsDictionary[item.id];
		}
		
		private function addAd(item:AdManageVO):void
		{
			_adsDictionary[item.id] = item;
			_adsDictionary.length ++;
			var position:MapPoint = new MapPoint(item.left,item.top);
			var ads:ADItem = new ADItem(position.toScreenPoint(map.zoom), item.url);
			map.addOverlay(ads);
		}
		
		private function checkBound():Boolean
		{
			var bound:MapBound = map.bound;
			if (bound.ltPoint.x > _leftTop.x && bound.ltPoint.y > _leftTop.y && bound.rbPoint.x < _rightBottom.x && bound.rbPoint.y < _rightBottom.y)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function initAds():void
		{
//			return;
			addBMWCar(new ScreenPoint(0, 36015 * 2, 8039 * 2), "assets/ads/bmwCar_antiClock.png");
			addBMWCar(new ScreenPoint(0, 67668, 16425), "assets/ads/bmwCar_clock.png");
			
			var position:ScreenPoint = map.center.toScreenPoint(map.zoom);
			position.offset(-205, -160);
//			trace(position.toHashKey() + position.toMapPoint().toHashKey());
			map.addOverlay(new ADItem(position, "assets/ads/ad_moving_car.swf"));
			
			//will add later
//			var aaa:ADItem = new ADItem(position, "assets/ads/car.swf");
//			map.addOverlay(aaa);
//			aaa.addEventListener(MouseEvent.CLICK, onClickHandler);
			
//			var newMovingCars:ADItem = new ADItem(new ScreenPoint(0,63801,13803),"assets/ads/newCar.swf");
//			map.addOverlay(newMovingCars);
			
			var starbucks:ImgBillBoard = new ImgBillBoard(new MapPoint(43085, 27355).toScreenPoint(map.zoom), "assets/ads/starbucks.png");
			map.addOverlay(starbucks);
			starbucks.addEventListener(MouseEvent.CLICK, onStarBuckHandler);
			
			position = (new MapPoint(50380, 24000)).toScreenPoint(map.zoom);
			var airship:ImgBillBoard = new ImgBillBoard(position, "assets/ads/airship.swf", 1);
			map.addOverlay(airship);
			airship.addEventListener(MouseEvent.CLICK, onAirshipClickHandler);
		}
		
		private function onClickHandler(event:MouseEvent):void
		{
			var target:ADItem = event.currentTarget as ADItem;
			target.rotation += 50;
		}
		
		private function onAirshipClickHandler(event:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.salliemae.com/"), "_blank");
		}
		
		private function onStarBuckHandler(event:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.starbucks.com/"), "_blank");
		}
		
		private function addBMWCar(position:ScreenPoint, asset:String):void
		{
			var bmw:ImgBillBoard = new ImgBillBoard(position, asset);
			bmw.addEventListener(MouseEvent.CLICK, onBMWClickHandler);
			map.addOverlay(bmw);
		}
		
		private function onBMWClickHandler(event:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.universalsubaru.net/ "), "_blank");
		}
	}
}