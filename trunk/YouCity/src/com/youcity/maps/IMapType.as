package com.youcity.maps
{
	/**
	 * MapType接口，目前什么用处
	 */
	public interface IMapType
	{
		function get direction():String;
		function set direction(value:String):void;
		function get type():String;
		function set type(value:String):void;
		function get name():String;
		function set name(value:String):void;
	}
}