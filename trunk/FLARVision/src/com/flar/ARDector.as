package com.flar
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;

	public class ARDector extends EventDispatcher
	{
		private var cameraURL:String;
		private var markerURL:String;
		
		private var code:FLARCode;
		private var codeWidth:Number;
		private var raster:FLARRgbRaster_BitmapData;
		private var detector:FLARSingleMarkerDetector;
		
		private var _flarParam:FLARParam;
		public function get flarParam():FLARParam
		{
			return this._flarParam;
		}
		
		public var width:Number;
		public var height:Number;
		public var markerWidth:Number = 16;
		public var markerHeight:Number = 16;
		
		public function ARDector(canvasWidth:Number = 320, canvasHeight:Number = 240, codeWidth:Number = 80)
		{
			this.width = canvasWidth;
			this.height = canvasHeight;
			this.codeWidth = codeWidth;
		}
		
		
		public function set src(target:BitmapData):void
		{
			raster = new FLARRgbRaster_BitmapData(target);
			detector = new FLARSingleMarkerDetector(_flarParam, code, codeWidth);
		}
		
		public function loadCameraFile(url:String):void
		{
			var cameraLoader:URLLoader = new URLLoader();
			cameraLoader.dataFormat = URLLoaderDataFormat.BINARY;
			cameraLoader.addEventListener(Event.COMPLETE, handleCameraLoadComplete, false, 0, true);
			addErrorListeners(cameraLoader);
			cameraLoader.load(new URLRequest(url));
		}
		
		private function handleCameraLoadComplete(event:Event):void
		{
			event.stopImmediatePropagation();
			
			var target:URLLoader = event.currentTarget as URLLoader;
			target.removeEventListener(Event.COMPLETE, handleCameraLoadComplete);
			removeErrorListeners(target);
			
			_flarParam = new FLARParam();
			_flarParam.loadARParam(target.data);
			_flarParam.changeScreenSize(width, height);
			
			loadMarkerFile(markerURL);
		}
		
		public function loadMarkerFile(url:String):void
		{
			var markerLoader:URLLoader = new URLLoader();
			markerLoader.dataFormat = URLLoaderDataFormat.TEXT;
			markerLoader.addEventListener(Event.COMPLETE, handleMarkerLoadComplete, false, 0, true);
			addErrorListeners(markerLoader);
			markerLoader.load(new URLRequest(url));
		}
		
		private function handleMarkerLoadComplete(event:Event):void
		{
			event.stopImmediatePropagation();
			
			var target:URLLoader = event.currentTarget as URLLoader;
			target.removeEventListener(Event.COMPLETE, handleMarkerLoadComplete);
			removeErrorListeners(target);
			
			code = new FLARCode(markerWidth, markerHeight);
			code.loadARPatt(target.data);
			
			dispatchEvent(new Event(Event.COMPLETE, true, true));
		}
		
		protected function addErrorListeners(target:IEventDispatcher):void
  		{
   			target.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
   			target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
   		}
  		
  		protected function removeErrorListeners(target:IEventDispatcher):void
  		{
   			target.removeEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
   			target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
   		}
   		
   		public function setup(cameraURL:String, markerURL:String):void
   		{
   			this.cameraURL = cameraURL;
   			this.markerURL = markerURL;
   			loadCameraFile(cameraURL);
   		}
   		
   		public function calculateTransformMatrix(resultMat:FLARTransMatResult):void
   		{
   			detector.getTransformMatrix(resultMat);
   		}
   		
   		public function detectMarker(threshold:Number = 90, confidence:Number = 0.5):Boolean
   		{
   			return detector.detectMarkerLite(raster, threshold) && (detector.getConfidence() > confidence)
   		}
		
	}
}
