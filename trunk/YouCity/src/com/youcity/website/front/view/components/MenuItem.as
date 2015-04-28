package com.youcity.website.front.view.components
{
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.SWFLoader;

	public class MenuItem extends Canvas
	{
		private var _content_Image:SWFLoader;
		
		private var _source:String;
		public function set source(value:String):void
		{
			if (_source == value) return;
			_source = value;
			_content_Image.source = _source;
		}
		public function get source():String
		{
			return _source;
		}
		
		public function MenuItem()
		{
			super();
			_content_Image = new SWFLoader();
			addChild(_content_Image);
			buttonMode=true;
		}
		
		override public function setStyle(styleProp:String, newValue:*):void
		{
			super.setStyle(styleProp, newValue);
			if (styleProp == "backgroundImage" ||
				styleProp == "background-image")
			{
				
			}
		}
		
	}
}