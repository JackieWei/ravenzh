package
{
	import flash.display.Sprite;

	public class GreatestCommonFactor extends Sprite
	{
		public function GreatestCommonFactor()
		{
			super();
			init();                           
		}
		
		private function init():void {
			trace("75" + "\t" + "145" + "\t" + gcf(75, 145));
			trace("75" + "\t" + "1" + "\t" + gcf(75, 1));
			trace("75" + "\t" + "5" + "\t" + gcf(75, 2));
			trace("75" + "\t" + "75" + "\t" + gcf(75, 75));
			trace("75" + "\t" + "150" + "\t" + gcf(75, 150));
			trace("75" + "\t" + "215" + "\t" + gcf(75, 215));
		}
		
		private function gcf(a:int, b:int):int {
			var factor:int = 0;
			var remainder:int = 0;
			while(1) {
				var swap:int;
				if(b > a) {
					swap = a;
					a = b; 
					b = swap;
				}
				remainder = a % b;
				a = b;
				b = remainder; 
				if (remainder == 0) {
					factor = a;
					break;
				} else if (remainder == 1) {
					break;
				}
			}
			return factor;
		}
	}
}