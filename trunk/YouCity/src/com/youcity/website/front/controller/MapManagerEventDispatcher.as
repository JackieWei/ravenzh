package com.youcity.website.front.controller
{
	import com.youcity.website.front.event.MapManagerEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MapManagerEventDispatcher
	{
		private static var instance:MapManagerEventDispatcher;
		
		private var eventDispatcher:IEventDispatcher;
		
		public function MapManagerEventDispatcher(target:IEventDispatcher = null)
		{
			eventDispatcher = new EventDispatcher(target);
		}
		
		public static function getInstance():MapManagerEventDispatcher
		{
			if (instance == null)
			{
				instance = new MapManagerEventDispatcher();
			}
			return instance;
		}

		/**
		 * Adds an event listener.
		 */
		public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ) : void 
		{
			eventDispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		  
		/**
		 * Removes an event listener.
		 */
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ) : void 
		{
		   eventDispatcher.removeEventListener( type, listener, useCapture );
		}
		
		/**
		 * Dispatches a FriendEvent instance
		 */
		public function dispatchEvent( event:MapManagerEvent) : Boolean 
		{
		   return eventDispatcher.dispatchEvent( event );
		}
		  
		/**
		 * Returns whether an event listener exists.
		 */
		public function hasEventListener( type:String ) : Boolean 
		{
		   return eventDispatcher.hasEventListener( type );
		}
		  
		/**
		 * Returns whether an event will trigger.
		 */
		public function willTrigger(type:String) : Boolean 
		{
		   return eventDispatcher.willTrigger( type );
		}		
		
	}
}