package com.youcity.website.front.view.common
{
	public final class ErrorCode
	{
		//=======================
		// System Exception Start  
		//=======================
		public static const UNKNOWN_CLIENT_ERROR:String = "ClIENT_ERR_001";
				
		public static const UNKNOWN_SERVER_ERROR:String = "ERR_000";
		
		public static const DATABASE_ACCESS_ERROR:String = "ERR_001";
		//=======================
		// System Exception End  
		//=======================	
			
		
		//============================
		// Application Exception Start  
		//============================		
		public static const ACCOUNT_NULL:String = "USR_001";
		
		public static const APP_FRIENDPAGE_NOPOWER:String = "USR_005";
		
		public static const VOTE_ERROR:String = "USR_008";
		//============================
		// Application Exception End  
		//============================		
		
	}
}