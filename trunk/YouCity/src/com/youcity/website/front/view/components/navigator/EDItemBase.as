package com.youcity.website.front.view.components.navigator
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.events.FlexEvent;
	
	/**
	 * extends form itembase and add event disptach part
	 * also remove event listener part
	 *  just for listen change events 
	 * **/
	public class EDItemBase extends ItemBase
	{
		private var _eventDispatcher:IEventDispatcher;
		private var _defaultWatcherType:String;
		
		public function EDItemBase(eventDispatcher:IEventDispatcher, defaultType:String)
		{
			super();
			_eventDispatcher = eventDispatcher;
			_defaultWatcherType = defaultType;
		}
		
		private var _type:String;
		public function set watcherType(value:String):void
		{
			_type = value;
		}
		
		private var _watcherAdded:Boolean;
		protected function watchChange():void
		{
			if (_watcherAdded) return;
			if (_type) _eventDispatcher.addEventListener(_type, watchChangeHandler);
			if (_defaultWatcherType) _eventDispatcher.addEventListener(_defaultWatcherType, watchChangeHandler);
		}
		
		private function watchChangeHandler(event:Event):void
		{
			dataChange();
		}
		
		protected function dataChange():void
		{
			getData();
		}
		
		
		public function getData():void
		{
			
		}
		
		override public function clear():void
		{
			if (_type) _eventDispatcher.removeEventListener(_type, watchChangeHandler);
			if (_defaultWatcherType) _eventDispatcher.removeEventListener(_defaultWatcherType, watchChangeHandler);
		}
		
		override public function getDataAtFirstSelected():void
		{
			super.getDataAtFirstSelected();
			getData();
			watchChange();
		}
	}
}