package com.youcity.maps
{

	/**
	 * 
	 * @author Administrator
	 * 没有用处了
	 */    
	public class ManhattanConstants extends Object
	{ 
		/* public static var A:Number = -0.000549910396870246;
	   	public static	 var B:Number  =  0.00822144335234043;
	    public static	 var C:Number  = 120.080972937805 ;
	    public static	 var D:Number  =   0.00778640180407564;
	    public static var E:Number  =  -0.000428722079565347;
	    public static	 var F:Number  = 30.4583965055385;
	    public static	 var rx:Number  = 120.238420;
	    public static var ry:Number  = 30.270240;
	    public static var oy:Number  = 30.56307; 
	    public static	 var	angle:Number = 32;
	    public static var	scale:Number = 0.65;
	    public static var cellsize:Number = 1 / (72 * 39.3701); */

		public static var A:Number = 2.24485653053594e-006;
		public static var B:Number =  2.10387177884686e-006;
		public static var C:Number = -74.083054038437;
		public static var D:Number=   1.01855486506902e-006;
		public static var E:Number =  -2.65122348523661e-006;
		public static var F:Number = 40.7344846224975;
	    
	    private static var _instance:ManhattanConstants;
		
		public function ManhattanConstants()
		{
			if (!_instance) _instance = new ManhattanConstants();
		}
		
		public static  function getInstance():ManhattanConstants
		{
			if (!_instance) _instance = new ManhattanConstants()
			return _instance;
		}
	}
} 
