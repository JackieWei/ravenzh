package com.raven
{
   import flash.events.DataEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLRequest;

   public class PhotoSearchProxy extends EventDispatcher {

      private static const API_KEY:String = "ea9bb66ff1cf25e6a6c74e9a9bd504ee";
      private static const FLICKR_URL:String = "http://api.flickr.com/services/rest/";

      public function PhotoSearchProxy() 
      {
      }

      private function onComplete(event:Event):void 
      {
         dispatchEvent(new DataEvent(Event.COMPLETE, false, false, XML(event.target.data)));
      }

      public function search(userId:String, tags:String):void 
      {
         var loader:URLLoader = new URLLoader();
         var request:URLRequest = new URLRequest(PhotoSearchProxy.FLICKR_URL  +
            "?method=flickr.photos.search&user_id=" + userId + "&tags=" + tags +
            "&api_key=" + PhotoSearchProxy.API_KEY);
         loader.addEventListener(Event.COMPLETE, onComplete);
         loader.load(request);
      }

   }

}
