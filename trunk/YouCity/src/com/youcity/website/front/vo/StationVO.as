package com.youcity.website.front.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	[Bindable]
	[RemoteClass(alias="com.youcity.website.back.vo.RouteVO")]
	public class StationVO implements IValueObject
	{
 		public var routeId:String;
		
		public var name:String;
		
		private var _description:String;
		public function get description():String
		{
			return _description;
		}
		public function set description(value:String):void
		{
			_description = value.toLowerCase();
			routes = _description.split(",");
		}
		
		public var pointX:String;
		
		public var pointY:String;
		
		private var _routes:Array;
		public function get routes():Array
		{
			return _routes;
		}
		public function set routes(value:Array):void
		{
			_routes = value;
		}
		
		public function  StationVO()
		{
			
		}
	}
}

 
