package com.youcity.website.front.view.components
{
	import com.youcity.website.front.view.components.controls.Label;
	
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;

	public class TitleContainer extends Canvas
	{
		public static const TITLE_HEIGHT:Number = 30;
		
		private var _tilte:String;
		public function get title():String
		{
			return _tilte;
		}
		public function set title(value:String):void
		{
			if (_tilte == value) return;
			_tilte = value;
			_textChanged = true;
			_titleContainer_title.text = _tilte;
		}
		
		private var titleAlignChanged:Boolean = false;
		
		private var _titleAlign:String = "center";
		[Inspectable(category="General", enumeration="left,right,center", defaultValue="center")]
		public function set titleAlign(value:String):void
		{
			if (value != null  && value != this._titleAlign)
			{
				_titleAlign = value;
				titleAlignChanged = true;
				invalidateProperties();
			}
		}
		public function get titleAlign():String
		{
			return _titleAlign;
		}
		
		private var _titleContainer_title:Label;
		private var _textChanged:Boolean = false;
		public function TitleContainer()
		{
			super();
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
			styleName = "titleFrame";
			_titleContainer_title = new Label();
			_titleContainer_title.setStyle("color", 0x12100f);
			_titleContainer_title.text = _tilte;
			_titleContainer_title.percentWidth = 100;
			_textChanged = true;
			addChild(_titleContainer_title);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (_textChanged)
			{
				var realHeight:Number = styleName == "titleFrame" ? TITLE_HEIGHT : unscaledHeight;
				_titleContainer_title.y = (realHeight - _titleContainer_title.height)/2;
				_textChanged = false;
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (titleAlignChanged)
			{
				titleAlignChanged = false;
				_titleContainer_title.setStyle("textAlign", _titleAlign);
			}
		}
		
	}
}