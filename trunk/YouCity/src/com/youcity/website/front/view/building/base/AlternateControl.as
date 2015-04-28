package com.youcity.website.front.view.building.base
{
	import mx.core.UIComponent;
	
	public final class AlternateControl
	{
		private var _index:int;
		private var _singular:Boolean;
		
		//sigular : when true means 单数有颜色，即第一个，第三个。。。
		//false 表示双数有颜色
		public function AlternateControl(target:UIComponent, singular:Boolean = true)
		{
			_index = target.repeaterIndex;
			if (_index < 0) return;
			_singular = singular;
			drawBG(target);
		}
		
		private function drawBG(target:UIComponent):void
		{
			var indexCount:uint = _singular ? _index  + 1: _index;
			if (indexCount%2)
			{
				target.setStyle("backgroundColor", 0xe4f4f1);
				target.setStyle("broderColor", 0xe4f4f1);
			}
			else
			{
				target.setStyle("backgroundColor", 0xffffff);
				target.setStyle("broderColor", 0xffffff);
			}
			target.setStyle("borderStyle", "solid");
			target.setStyle("borderThickness", 1);
		}

	}
}