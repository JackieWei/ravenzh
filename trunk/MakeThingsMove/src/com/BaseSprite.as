package com
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	[SWF(width="800", height="600")]
	public class BaseSprite extends Sprite
	{
		public function BaseSprite()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			init();
		}
		
		protected function init():void {};
		
		
		protected function updateUI():void{}
		
	}
}