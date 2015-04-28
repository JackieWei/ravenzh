package com.youcity.website.front.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	[Bindable]
	[RemoteClass(alias="com.youcity.website.back.vo.AdManageVO")]
	public dynamic class AdManageVO implements IValueObject
	{
		public var id:int;
		
		public var default_zoom:int;
		
		public var left:int;
		
		public var top:int;
		
		public var url:String;
		
		public var link:String;
		
		public var swf_width:int;
		
		public var swf_height:int;
		
		public var max_zoom:int;

		public function AdManageVO()
		{
			
		}
		
	}

}
 
