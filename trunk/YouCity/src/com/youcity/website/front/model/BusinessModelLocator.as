package com.youcity.website.front.model
{
	import com.youcity.website.front.vo.BusinessVO;
	
	import mx.collections.ArrayCollection;
	
	public class BusinessModelLocator 
	{
		
		public var businessDetailInfo:BusinessVO;
		
		[ArrayElementType("com.youcity.website.front.vo.VideoVO")] 
		public var videoList:ArrayCollection;
		
		[ArrayElementType("com.youcity.website.front.vo.PhotoVO")] 
		public var photoList:ArrayCollection;
		
		[ArrayElementType("com.youcity.website.front.vo.ActivityVO")] 
		public var activityList:ArrayCollection;
		
		[ArrayElementType("com.youcity.website.front.vo.CommentVO")] 
		public var commentList:ArrayCollection;
		
		public var noteList:ArrayCollection;
		
		private static var _instance:BusinessModelLocator;
		
	 	public function BusinessModelLocator()
	 	{
	 		if (_instance)
	 		{
	 			throw(new Error("SINGTON ERROR!"));
	 		}
	 	}
	 	
	 	public static function getInstance():BusinessModelLocator
	 	{
	 		if (!_instance)
	 		{
	 			_instance = new BusinessModelLocator();
	 		}
	 		return _instance;
	 	}		 
	}
}


 
