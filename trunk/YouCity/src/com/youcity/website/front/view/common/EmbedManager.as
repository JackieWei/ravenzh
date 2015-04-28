package com.youcity.website.front.view.common
{
	public class EmbedManager
	{
		private static const _embed_1:String = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" name="';
		private static const _embed_1_1:String = '" width="400" height="350" codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab"><param name="movie" value="http://www.youcity.com/2009/widget/index.swf" /><param name="quality" value="high" /><param name="bgcolor" value="ffffff" /><param name="allowScriptAccess" value="sameDomain" /><param name="flashvars" value="zoom=4&hasMiniMap=false&mapType=3d&hasZoomControl=true&hasTypeControl=true&';
        private static const _embed_2:String = '&center=43724, 27842&dragEnabled=true&wheelEnabled=true" /><embed name="';
        private static const embed_2_2:String = '"  src="http://www.youcity.com/2009/widget/index.swf" quality="high" bgcolor="ffffff" width="400" height="350" align="middle" flashvars="zoom=4&hasMiniMap=false&mapType=3d&hasZoomControl=true&hasTypeControl=true&';
        private static const _embed_3:String = '&center=43724, 27842&dragEnabled=true&wheelEnabled=true" play="true" loop="false" quality="high"  allowscriptaccess="sameDomain"  type="application/x-shockwave-flash" pluginspage="http://www.adobe.com/go/getflashplayer"> </embed> </object>';
		
		public function EmbedManager()
		{
			
		}
		
		public static function getActivityEmbed(ids:Array):String
		{
			var name:String = '_activity_' + Math.random().toString() + "_"   + ids.join(",") + '_end';
			return _embed_1 + name + _embed_1_1 + 'type=activity&' + 'activityId=' + ids.join(",") +  _embed_2 + name + embed_2_2 
			    +  'type=activity&' + 'activityId=' + ids.join(",")  + _embed_3;
		}
		
		public static function getBusinessEmbed(ids:Array):String
		{
			var name:String = '_business_' + Math.random().toString() + "_" +  ids.join(",") + '_end';
			return _embed_1 + name + _embed_1_1 +  'type=business&' + 'businessId=' + ids.join(",") 
			    + _embed_2 + name + embed_2_2 
                +  'type=business&' + 'businessId=' + ids.join(",")  + _embed_3;
		}
		
		public static function getBuildingEmbed(ids:Array):String
		{
			var name:String = '_building_' + Math.random().toString() + "_" + ids.join(",") + '_end';
			return _embed_1 + name + _embed_1_1 +  'type=building&' + 'buildingId=' + ids.join(",") 
			    + _embed_2  + name +  embed_2_2 
                +  'type=building&' + 'buildingId=' + ids.join(",")  + _embed_3;
		}
        
        public static function getMyMapEmbed(id:String):String
        {
        	var name:String =  '_myMap_' + Math.random().toString() + "_" + id + '_end';
        	return _embed_1 + name + _embed_1_1 +  'type=myMap&' + 'myMapId=' + id 
        	    + _embed_2  + name + embed_2_2 
                +  'type=myMap&' + 'myMapId=' + id  + _embed_3;
        }
        
	}
}