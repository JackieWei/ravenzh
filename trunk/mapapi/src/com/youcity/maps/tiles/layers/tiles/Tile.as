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
		protected var _request:URLRequest;
		
		private var _position:ScreenPoint;
		public function get position():ScreenPoint { return _position; }
		
		protected var _url:String;
		public function get url():String { return _url;}
		public function set url(value:String):void { _url = value; }
		
		protected var _loaded:Boolean;
		public function get loaded():Boolean { return _loaded; }
		public function set loaded(value:Boolean):void { _loaded = value; }
		
		protected var _gc:Boolean;
		public function get gc():Boolean { return _gc; }
		public function set gc(value:Boolean):void { _gc = value; }
		
		/**
		 * 
		 * @param self : for abstract class check
		 * @param url : url
		 * @param position : position
		 * 
		 */			
		public function Tile(url:String = "", position:ScreenPoint = null) {
			_request = new URLRequest();
			_loaded = false;
			_url = url;
		}
		
		/**
		 * send request to load
		 */		
		public function load():void {
			throw new Error("Tile. Method 'load' should be overrided by its subclass!");
		}
		
		/**
		 * clear all
		 */		
		public function clear():void {
			throw new Error("Tile. Method 'clear' should be overrided by its subclass!");
		}
	}
}
