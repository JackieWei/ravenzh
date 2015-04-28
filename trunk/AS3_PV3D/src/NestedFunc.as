package
{
	import flash.display.Sprite;

	public class NestedFunc extends Sprite
	{
		private var innerFunc:Function;
		
		public function NestedFunc()
		{
			super();
			getDate();
			init();
			innerFunc();
		}
		
		private function getDate():void
		{
			trace("out getDate");
		}
		
		private function init():void
		{
			function getDate():void
			{
				trace("inner getDate");
			}
			trace("init");
			
			innerFunc = getDate;
		}
		
		
	}
}