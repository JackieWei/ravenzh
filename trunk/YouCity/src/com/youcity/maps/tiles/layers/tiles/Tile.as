package com.youcity.maps.tiles.layers.tiles
{

	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.tiles.interfaces.ITile;
	
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	/**
	 * Abstract Class
	 * Class to define all common things 
	 * in each tile
	 * @author Administrator
	 * Tile的基类，归结了一些主要的函数
	 */	
	public class Tile extends Sprite implements ITile
	{
		/**
		 * resource url
		 */		
		protected var _resourceUrl:String;
		
		/**
		 * request to send request
		 */		
		protected var _request:URLRequest;
		
		/**
		 * read only property show the position
		 * of tile
		 */		
		private var _position:ScreenPoint;
		public function get position():ScreenPoint
		{
			return _position;
		}
		
		/**
		 * read only property show if tile's contents 
		 * is loaded
		 */		
		protected var _loaded:Boolean;
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		/**
		 * 
		 * @param self : for abstract class check
		 * @param url : url
		 * @param position : position
		 * 
		 */			
		public function Tile(self:Tile, url:String, position:ScreenPoint) 
		{
			if (self != this) throw new Error("Abstract Class");
			_request = new URLRequest();
			_loaded = false;
			_position = position;
			_resourceUrl = url;
		}
		
		/**
		 * send request to load
		 */		
		public function load():void
		{
			//to be inherited
		}
		
		/**
		 * clear all
		 * 
		 */		
		public function clear():void
		{
			//_request = null;
			//_position = null;
			//_resourceUrl = null;
		}
	}
}
