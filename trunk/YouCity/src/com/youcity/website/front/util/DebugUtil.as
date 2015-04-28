package com.youcity.website.front.util
{
	/**
	 *  
	 * @author Raven
	 * Created at 2010.7.14
	 */	
	public class DebugUtil
	{
		/**
		 * 打印日志方法 
		 * @param args
		 * 
		 */		
		public static function print(...args):void {
			var length:int = args.length;
			for (var i:int = 0; i < length; i ++) {
				trace(args[i]);
			}
		}
		
		public static function debug():void {
			//todo
		}
		
	}
}