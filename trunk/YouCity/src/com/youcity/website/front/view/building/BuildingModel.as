package com.youcity.website.front.view.building
{
	import com.youcity.website.front.vo.BuildingVO;
	import com.youcity.website.front.vo.BusinessVO;
	
	public final class BuildingModel
	{
		//当前选中查看的building
		[Bindable]
		public static var currentBuilding:BuildingVO;
		
		//Relocatebusiness时使用这两个值存储当前需要重新定位的business和被选择为
		//新位置的building
		[Bindable]
		public static var businessHostBuilding:BuildingVO;
		[Bindable]
		public static var businessTobeRehost:BusinessVO;
		
		//需要被编辑的属于当前building的business。打开edit view时设定，关闭edit view时清空
		[Bindable]
		public static var businessTobeEdit:BusinessVO;
		
		//firstIndex表示顶级的选项卡的打开的index，secondIndex表示次级的选项卡打开的index
		public static var firstIndex:uint = 0;
		public static var secondIndex:uint = 0;
		
		public static var clipboard:String;
		
		public function BuildingModel()
		{
		}

	}
}