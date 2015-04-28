package com.youcity.maps
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * 
	 * @author Administrator
	 * 作为Map对于外界唯一派发事件的对象、
	 * 可以派发那些需要通知外界但是map无法派发的事件，比如Hotspot的click事件等
	 * 基本上map没法派发但是需要对外通知的事件都是此类派发的，单实例类
	 */    
	public final class MapEventDispatcher extends EventDispatcher
	{
		private static var key:Boolean;
		private static var _instance:MapEventDispatcher;
		public static function getInstance():MapEventDispatcher
		{
			if (!_instance)
			{
				key = true;
				_instance = new MapEventDispatcher();
			}
			return _instance;
		}
		public function MapEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
			key = true;
		}
		
	}
}