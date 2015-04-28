package com.youcity.website.front.util
{
	import com.youcity.website.front.common.Config;
	import com.youcity.website.front.common.Constants;
	
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.formatters.DateBase;
	import mx.formatters.DateFormatter;
	import mx.utils.StringUtil;
	
	public class AuxUtil
	{
		public static const ONEDAY:uint = 24 * 3600 * 1000;
		
		private static var df:DateFormatter = new DateFormatter();
		
		//to indicates whether the target str is null or ""
		public static function isEmpty(target:Object):Boolean
		{
			if (target == null)
			return true;
			if (target is String)
			return StringUtil.trim(target as String) == "";
			if (target is Array)
			return target.length == 0;
			if (target is ArrayCollection)
			return target.length == 0;
			return false;
		}
		
		public static function isSame(targetStr:String, originalStr:String):Boolean
		{
			if (AuxUtil.isEmpty(originalStr))
			{
				return AuxUtil.isEmpty(targetStr);
			}
			else
			{
				if (!AuxUtil.isEmpty(targetStr))
				{
					return StringUtil.trim(targetStr) == StringUtil.trim(originalStr);
				}
				return false;
			}
		}

		//to generater the qualified picture url
		public static function generateAvator(userId:String):String
		{
			
			return Config.AVATAR_PREFIX + userId.substr(0, userId.length - 3) + "/" + userId + ".jpg" + "?"+ Math.random()*1000;
		}
		
		public static function formatDate(target:Date, formatString:String = "YYYY-MM-DD HH:NN"):String
		{
			df.formatString = formatString;
			return df.format(target);
		}
		
		public static function getState(value:String):Object
		{
			var result:Object;
			for (var i:String in Constants.STATES)
			{
				var obj:Object = Constants.STATES[i];
				if (obj.value == value)
				result =  obj;
			}
			return result;
		}
		
		public static function parseResultXML(xml:XML):void
		{
			var activityList:XMLList;
		}
		
		public static function stringToDate(str:String):Date
		{
	        if (!str || str == "")
	            return null;
	
	        var year:int = -1;
	        var mon:int = -1;
	        var day:int = -1;
	        var hour:int = -1;
	        var min:int = -1;
	        var sec:int = -1;
	        
	        var letter:String = "";
	        var marker:Object = 0;
	        
	        var count:int = 0;
	        var len:int = str.length;
	        
	        while (count < len)
	        {
	            letter = str.charAt(count);
	            count++;
	
	            // If the letter is a blank space or a comma,
	            // continue to the next character
	            if (letter <= " " || letter == ",")
	                continue;
	
	            // If the letter is a key punctuation character,
	            // cache it for the next time around.
	            if (letter == "/" || letter == ":" ||
	                letter == "+" || letter == "-")
	            {
	                marker = letter;
	                continue;
	            }
	
	            // Scan for groups of numbers and letters
	            // and match them to Date parameters
	            if ("a" <= letter && letter <= "z" ||
	                "A" <= letter && letter <= "Z")
	            {
	                // Scan for groups of letters
	                var word:String = letter;
	                while (count < len) 
	                {
	                    letter = str.charAt(count);
	                    if (!("a" <= letter && letter <= "z" ||
	                          "A" <= letter && letter <= "Z"))
	                    {
	                        break;
	                    }
	                    word += letter;
	                    count++;
	                }
	
	                // Allow for an exact match
	                // or a match to the first 3 letters as a prefix.
	                var n:int = DateBase.mx_internal::defaultStringKey.length;
	                for (var i:int = 0; i < n; i++)
	                {
	                    var s:String = String(DateBase.mx_internal::defaultStringKey[i]);
	                    if (s.toLowerCase() == word.toLowerCase() ||
	                        s.toLowerCase().substr(0,3) == word.toLowerCase())
	                    {
	                        if (i == 13) 
	                        {
	                            // pm
	                            if (hour > 12 || hour < 1)
	                                break; // error
	                            else if (hour < 12)
	                                hour += 12;
	                        } 
	                        else if (i == 12) 
	                        {
	                            // am
	                            if (hour > 12 || hour < 1)
	                                break; // error
	                            else if (hour == 12)
	                                hour = 0;
	
	                        } 
	                        else if (i < 12) 
	                        {
	                            // month
	                            if (mon < 0)
	                                mon = i;
	                            else
	                                break; // error
	                        }
	                        break;
	                    }
	                }
	                marker = 0;
	            }
	            
	            else if ("0" <= letter && letter <= "9")
	            {
	                // Scan for groups of numbers
	                var numbers:String = letter;
	                while ("0" <= (letter = str.charAt(count)) &&
	                       letter <= "9" &&
	                       count < len)
	                {
	                    numbers += letter;
	                    count++;
	                }
	                var num:int = int(numbers);
	
	                // If num is a number greater than 70, assign num to year.
	                if (num >= 70)
	                {
	                    if (year != -1)
	                    {
	                        break; // error
	                    }
	                    else if (letter <= " " || letter == "," || letter == "." ||
	                             letter == "/" || letter == "-" || count >= len)
	                    {
	                        year = num;
	                    }
	                    else
	                    {
	                        break; //error
	                    }
	                }
	
	                // If the current letter is a slash or a dash,
	                // assign num to month or day.
	                else if (letter == "/" || letter == "-" || letter == ".")
	                {
	                    if (mon < 0)
	                        mon = (num - 1);
	                    else if (day < 0)
	                        day = num;
	                    else
	                        break; //error
	                }
	
	                // If the current letter is a colon,
	                // assign num to hour or minute.
	                else if (letter == ":")
	                {
	                    if (hour < 0)
	                        hour = num;
	                    else if (min < 0)
	                        min = num;
	                    else
	                        break; //error
	                }
	
	                // If hours are defined and minutes are not,
	                // assign num to minutes.
	                else if (hour >= 0 && min < 0)
	                {
	                    min = num;
	                }
	
	                // If minutes are defined and seconds are not,
	                // assign num to seconds.
	                else if (min >= 0 && sec < 0)
	                {
	                    sec = num;
	                }
	
	                // If day is not defined, assign num to day.
	                else if (day < 0)
	                {
	                    day = num;
	                }
	
	                // If month and day are defined and year is not,
	                // assign num to year.
	                else if (year < 0 && mon >= 0 && day >= 0)
	                {
	                    year = 2000 + num;
	                }
	
	                // Otherwise, break the loop
	                else
	                {
	                    break;  //error
	                }
	                
	                marker = 0
	            }
	        }
	
	        if (year < 0 || mon < 0 || mon > 11 || day < 1 || day > 31)
	            return null; // error - needs to be a date
	
	        // Time is set to 0 if null.
	        if (sec < 0)
	            sec = 0;
	        if (min < 0)
	            min = 0;
	        if (hour < 0)
	            hour = 0;
	
	        // create a date object and check the validity of the input date
	        // by comparing the result with input values.
	        var newDate:Date = new Date(year, mon, day, hour, min, sec);
	        if (day != newDate.getDate() || mon != newDate.getMonth())
	            return null;
	
	        return newDate;
		}	
		
		public static function addPhotoPrefix(url:String):String
		{
			return Config.PHOTO_PREFIX + url;
		}
		
		public static function getCategoryUrl(category:*, size:String):String
		{
			return "assets/activity/category/" + String(category) + "_" + String(size) + ".png";
		}
		
		public static function shortStr(str:String, length:uint, start:int = 0):String
		{
			return str.length > (start + length) ? str.substr(start, length) + "..." : str;
		}
		
		public static function parseStringToNumber(value:String):Number
		{
			var t:Number;
			var positive:Boolean;
			if (value.charAt(0) == "-")
			{
				positive = false;
				t = Number(value.substring(1, value.length));
			}
			else
			{
				positive = true;
				t = Number(value);
			}
			return positive ? t: -t;
		}
		
		public static function nextDate(date:Date, jumpDays:uint = 7):Date
		{
			return jumpDate(date, jumpDays);
		}
		
		public static function previousDate(date:Date, jumpDays:uint = 7):Date
		{
			return jumpDate(date, -jumpDays);
		}
		
		public static function jumpDate(date:Date, jmmpDays:int):Date
		{
			var day:Date = new Date();
			day.time = date.time + ONEDAY * jmmpDays;
			return day;
		}
		
		public static function includeTarget(target:UIComponent, flag:Boolean):void
		{
			target.includeInLayout = flag;
			target.visible = flag;
		}
		
		public static function generateChar(num:uint):String
		{
			return String.fromCharCode(num + 64);
		}
		
		public static function formatPoints(points:String, delimiter:String = ";"):Array
		{
			if (AuxUtil.isEmpty(points))
			return new Array();
			var arr1:Array = points.split(delimiter)
			var arr2:Array = new Array();
			for(var i:String in arr1)
			{
				var temArr:Array = String(arr1[i]).split(",");
				var point:Point = new Point();
				point.x = temArr[0];
				point.y = temArr[1];
				arr2.push(point);
			}
			return arr2;
		}
		
		public static function generatePoints(arr:Array):String
		{
			var resultStr:String = "";
			for(var i:String in arr)
			{
				var temPoint:Point = arr[i];
				resultStr += temPoint.x + ","; 
				resultStr += temPoint.y; 
				resultStr += (uint(i) == (arr.length -1)) ? "" : ";";
			}
			return resultStr;
		}		
	}
}