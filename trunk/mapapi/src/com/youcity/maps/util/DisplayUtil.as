package com.youcity.maps.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 
	 * @author Raven
	 * 
	 */	
	public final class DisplayUtil
	{
		/**
		 * add child to parent 
		 * @param parent
		 * @param child
		 * 
		 */		
		public static function addChild(parent:DisplayObjectContainer, child:DisplayObject):void {
			if (parent && child && !parent.contains(child)) {
				parent.addChild(child);
			}
		}
		
		
		/**
		 * remove child from parent 
		 * @param parent
		 * @param child
		 * 
		 */		
		public static function removeChild(parent:DisplayObjectContainer, child:DisplayObject):void {
			if (parent && child && parent.contains(child)) {
				parent.removeChild(child);
			}
		}
		
		/**
		 * common function to remove all children in target
		 * @param target
		 */		
		public static function removeAllChildren(target:DisplayObjectContainer):void {
			while (target && target.numChildren > 0) {
				target.removeChildAt(0);
			}
		}
	}
}