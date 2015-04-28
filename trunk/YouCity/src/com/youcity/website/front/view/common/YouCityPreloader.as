package com.youcity.website.front.view.common
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.preloaders.DownloadProgressBar;

	public class YouCityPreloader extends DownloadProgressBar
	{
		[Embed(source="assets/preloader/loading_bg.png")]
		public static var LOADING_BG:Class;
		
		[Embed(source="assets/preloader/progress_track.png")]
		public static var PROGRESS_TRACK:Class;
		
		[Embed(source="assets/preloader/progress_content_left.gif")]
		public static var PROGRESS_CONTENT_LEFT:Class;
		
		[Embed(source="assets/preloader/progress_content_center.gif")]
		public static var PROGRESS_CONTENT_CENTER:Class;
		
		[Embed(source="assets/preloader/progress_content_right.gif")]
		public static var PROGRESS_CONTENT_RIGHT:Class;
		
		[Embed(source="assets/preloader/building.png")]
		public static var LOGO:Class;
		
		private var _preloadBG:Bitmap;
		private var _progressTrack:Bitmap;
		private var _progressContent:Sprite;
		private var _progressText:TextField;
		
		private var _logo:Bitmap;
		
		public function YouCityPreloader()
		{
			super();
			_preloadBG = new LOADING_BG();
			_progressTrack = new PROGRESS_TRACK();
			_progressContent = new Sprite();
			_logo = new LOGO();
		}
		
		private var _progressBar:Sprite;
		override protected function createChildren():void
		{
			_preloadBG.x = (stageWidth - _preloadBG.width) / 2;
			_preloadBG.y = (stageHeight - _preloadBG.height) / 2;
			addChild(_preloadBG);
			
			_progressBar = new Sprite();
			_progressBar.addChild(_progressTrack);
			_progressBar.addChild(_progressContent);
			_progressContent.y = (_progressTrack.height - _left.height)/2;
			_progressBar.x = (stageWidth - _progressTrack.width) / 2;
			_progressBar.y = (stageHeight - _progressTrack.height) / 2;
			addChild(_progressBar);
	
			_progressText = new TextField();
			_progressText.autoSize = TextFieldAutoSize.LEFT;
			var format:TextFormat = new TextFormat();
			format.color = 0x505050;
			format.font = "Verdana";
			format.size = 15;
			format.italic = true;
			format.bold = "bold";
			_progressText.setTextFormat(format);
			 
			_progressText.x = (stageWidth - 88)/2;
			_progressText.y = _progressBar.y + 15;
			addChild(_progressText);
			
			_logo.x = (stageWidth - _logo.width)/2;
			_logo.y = _progressBar.y - _logo.height - 20;
			addChild(_logo);
		}
		
		
		override protected function setProgress(completed:Number, total:Number):void
		{
			setPreoloaderProgress(completed, total);
		}
		private function setPreoloaderProgress(bytesLoaded:Number, bytesTotal:Number):void
		{
			if(!_progressText) return;
			var percent:Number = uint(bytesLoaded * 100 / bytesTotal);
			_progressText.text = "Loading... ... " + String(percent) + "%";
			setContentWidth(_progressTrack.width * bytesLoaded / bytesTotal);
		}
		
		private var _left:Bitmap = new PROGRESS_CONTENT_LEFT();
		private var _center:Bitmap = new PROGRESS_CONTENT_CENTER();
		private var _right:Bitmap = new PROGRESS_CONTENT_RIGHT();
		private function setContentWidth(value:Number):void
		{
			var centerLength:Number = value - _left.width - _right.width;
			if (centerLength < 0) centerLength = 0;
			var graphic:Graphics = _progressContent.graphics;
			graphic.clear();
			graphic.beginBitmapFill(_left.bitmapData, null, false, true);
			graphic.drawRect(0,0, _left.width, _left.height);
			graphic.beginBitmapFill(_center.bitmapData, null, true, true);
			graphic.drawRect(_left.width, 0, centerLength, _center.height);
			graphic.beginBitmapFill(_right.bitmapData, null, false, true);
			graphic.drawRect(_left.width + centerLength, 0, _right.width, _right.height);
			graphic.endFill();
		}
		
	}
}