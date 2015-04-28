package com.youcity.website.front.view.menu
{
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	
	public class MenuIconButton extends Button
	{
		/**
		 *Tip for menu, just like tooltip 
		 */		
		private var _tip:String;
		public function get tip():String
		{
			return this._tip;
		}
		public function set tip(value:String):void
		{
			this._tip = value;
		}
		
		public function MenuIconButton()
		{
			super();
		}
		
	}
}