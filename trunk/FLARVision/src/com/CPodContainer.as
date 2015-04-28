package com
{
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	
	public class CPodContainer
	{
		private var cube:Cube;
		private var materialsList:MaterialsList;
		
		public function CPodContainer()
		{
			init();
		}
		
		private function init():void
		{
			createSkins();
			createCube();
		}
		
		private function createSkins():void
		{
			var frontBFM:BitmapFileMaterial = new BitmapFileMaterial("assets/images/skins/cpod-front.jpg");
			var backBFM:BitmapFileMaterial = new BitmapFileMaterial("assets/images/skins/cpod-back.jpg");
			var leftBFM:BitmapFileMaterial = new BitmapFileMaterial("assets/images/skins/cpod-left.jpg");
			var rightBFM:BitmapFileMaterial = new BitmapFileMaterial("assets/images/skins/cpod-right.jpg");
			var topBFM:BitmapFileMaterial = new BitmapFileMaterial("assets/images/skins/cpod-top.jpg");
			var bottomBFM:BitmapFileMaterial = new BitmapFileMaterial("assets/images/skins/cpod-bottom.jpg");
			
			materialsList = new MaterialsList({front:frontBFM, back:backBFM, left:leftBFM, right:rightBFM, top:topBFM, bottom:bottomBFM});
		}
		
		private function createCube():void
		{
			cube = new Cube(materialsList, 198, 29, 391, 10, 4, 10);
			cube.roll(-90);
			cube.z = 20;
			cube.scale = 0.5;
		}
		
		public function attachTo(target:DisplayObject3D):void
		{
			target.addChild(cube);
		}

	}
}
