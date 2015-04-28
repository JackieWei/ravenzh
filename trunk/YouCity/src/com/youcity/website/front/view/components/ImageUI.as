package com.youcity.website.front.view.components
{
	import com.youcity.website.front.common.Config;
	import com.youcity.website.front.util.AuxUtil;
	import com.youcity.website.front.view.components.controls.SWFLoader;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filters.DropShadowFilter;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	[Event(name="progress",	type="flash.events.ProgressEvent")]
	[Event(name="unload", 		type="flash.events.Event")]
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	
	[Style(name="loaderStyle", type="String", inherit="no")]
	public class ImageUI extends UIComponent 
	{
		private var loader:SWFLoader = new SWFLoader();
		private var maskShape:Shape = new Shape();
		
		private var styleChangded:Boolean = false;
		
		private var sourceChanged:Boolean = false;
		
		private var _source:String;
		
 		private function get scaleContent():Boolean
		{
			return loader.scaleContent;
		}
		
		public function set scaleContent(value:Boolean):void
		{
			loader.scaleContent = value;
		}
		
		public function get trustContent():Boolean
		{
			return loader.trustContent;
		}
		
		public function set trustContent(value:Boolean):void
		{
			loader.trustContent = value;
		}
		
		public function get maintainAspectRatio():Boolean
		{
			return loader.maintainAspectRatio;
		}
		
		public function set maintainAspectRatio(value:Boolean):void
		{
			loader.maintainAspectRatio = value;
		} 
		
		public function get bytesLoaded():uint
		{
			return loader ? loader.bytesLoaded : 0;
		}
		
		public function get bytesTotal():uint
		{
			return loader ? loader.bytesTotal : 0;
		} 
		
		private var _brokenImage:String;
		public function set brokenImage(value:String):void
		{
			loader.brokenImage = value;
		}
		
		public function get source():String
		{
			return this._source;
		}
		public function set source(value:String):void
		{
			if (AuxUtil.isEmpty(value))
			{
				value = "error path";
			}
			this._source = value;
			sourceChanged = true;
			invalidateProperties();
		}
		
		public function ImageUI()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, 	handlCreationComplete);
			addEventListener(ResizeEvent.RESIZE, 			handleResizeEvent);
		}
		
		private function onProgressHandler(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		private function onHTTPStatusHandler(event:HTTPStatusEvent):void
		{
			dispatchEvent(event);
		}
		
		private function onCompleteHandler(event:Event):void
		{
			dispatchEvent(event);
		}
		
		private function onUnloadHandler(event:Event):void
		{
			dispatchEvent(event);
		}
		
		private function handlCreationComplete(event:FlexEvent):void
		{
			addFilters();
			drawMask();
		}
		
		private function handleResizeEvent(event:ResizeEvent):void
		{
			drawMask();
			loader.width = width - 1*2;
			loader.height = height - 1*2;
		}
		
		private function addFilters():void
		{
			var arr:Array = new Array();
			var shadowFilter:DropShadowFilter = new DropShadowFilter();
			shadowFilter.alpha = 0.2;
			shadowFilter.angle = 120;
			shadowFilter.blurX = 3.0;
			shadowFilter.blurY = 3.0;
			shadowFilter.color = 0x000000;
			shadowFilter.distance = 3;
			arr.push(shadowFilter);
			this.filters = arr;
		}
		
		private function drawMask():void
		{
			maskShape.graphics.clear();
			maskShape.graphics.beginFill(0xFFFFFF, 0.2);
			maskShape.graphics.drawRoundRectComplex(0, 0, this.width - 1*2, this.height - 1*2, 4, 4, 4, 4);
			maskShape.graphics.endFill();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			loader.x = 1; 
			loader.y = 1; 
			loader.width = width - 1*2;
			loader.height = height - 1*2;
			loader.maintainAspectRatio = true;
			loader.addChild(maskShape);
			loader.mask = maskShape;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, 		onProgressHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, 	onHTTPStatusHandler);
			loader.addEventListener(Event.UNLOAD, 					onUnloadHandler); 
			loader.addEventListener(Event.COMPLETE, 					onCompleteHandler); 
			loader.addEventListener(Event.INIT, 					handleLoaderInitEvent);
			this.addChild(loader);
		}
		
		private function onIOErrorHandler(event:IOErrorEvent):void
		{
			//if (_brokenImage) loader.load(_brokenImage);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (sourceChanged)
			{
				sourceChanged = false;
				loader.x = 1; 
				loader.y = 1; 
				loader.width = this.width - 1*2;
				loader.height = this.height - 1*2;
				loader.source = source;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			graphics.clear();
			graphics.beginFill(0xffffff, 0.3);
			graphics.drawRoundRectComplex(0, 0, this.width, this.height, 4, 4, 4, 4);
			graphics.endFill();
			
			if (styleChangded)
			{
				styleChangded = false;
				if(getStyle("loaderStyle") == null)
				return;
				this.loader.styleName = getStyle("loaderStyle");
			}
		}
		
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			if ("loaderStyle" == styleProp 
				|| "styleName" == styleProp
				|| null == styleProp)
			{
				styleChangded = true;
				invalidateDisplayList();
				return;
			}
		}
		
		private function handleLoaderInitEvent(event:Event):void
		{
			var w:Number = SWFLoader(event.currentTarget).contentWidth;
			var h:Number = SWFLoader(event.currentTarget).contentHeight;
			var actualW:Number = this.width - 1*2;
			var actualH:Number = this.height - 1*2;
			if (w < actualW || h < actualH)
			{
				loader.width = w;
				loader.height = h;
				loader.x = (this.width - w)/2;
				loader.y = (this.height - h)/2;
			}
			
		}
		
	}
}