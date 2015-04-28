package
{
	import flash.display.Sprite;
	import flash.utils.getTimer;

	public class TestSpeed extends Sprite
	{
		private var length:int = 10000000;
		public function TestSpeed()
		{
			super();
			init();
		}
		
		private function init():void {
			runDivisionTest();
			runMultiTest();
			runBitShiftTest();
		}
		
		private function runDivisionTest():void {
			var startTime:int = getTimer();
			for (var i:int = 0; i < length; i ++) {
				var test:int = i /2;
			}
			var cost:int = getTimer() - startTime;
			trace("Run Division Test\t" + cost);
		}
		
		private function runMultiTest():void {
			var startTime:int = getTimer();
			for (var i:int = 0; i < length; i ++) {
				var test:int = i * 0.5;
			}
			var cost:int = getTimer() - startTime;
			trace("Run Multi Test\t" + cost);
		}
		
		private function runBitShiftTest():void {
			var startTime:int = getTimer();
			for (var i:int = 0; i < length; i ++) {
				var test:int = i >> 1;
			}
			var cost:int = getTimer() - startTime;
			trace("Run BitShift Test\t" + cost);
		}
		
		
		
	}
}