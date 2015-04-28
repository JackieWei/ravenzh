package com.youcity.website.front.view.components
{
	import flash.events.EventDispatcher;

	public class Singleton extends EventDispatcher
	{
		protected static var _instance:Singleton;
		protected static var key:Boolean;
		protected static function get instance():Singleton
		{
			if (!_instance)
			{
				key = true;
				_instance = new Singleton();
			}
			return _instance;
		}
		
		public function Singleton()
		{
			super(null);
			if (!key)
			{
				throw new Error("Singleton");
				return;
			}
			key = false;
		}
		
	}
}