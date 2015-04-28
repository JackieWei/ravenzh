package com
{
	import Box2D.Dynamics.b2Body;
	
	import flash.display.DisplayObject;
	
	public class Actor
	{
		private var _body:b2Body;
		public function get body():b2Body
		{
			return this._body;
		}
		
		public function set body(value:b2Body):void
		{
			this._body = value;
		}
		
		private var _displayObect:DisplayObject;
		public function get displayObect():DisplayObject
		{
			return this._displayObect;
		}
		public function set displayObect(value:DisplayObject):void
		{
			this._displayObect = value;	
		}
		
		public function Actor(body, displayObect)
		{
			this._body = body;
			this._displayObect = displayObect;
		}

	}
}