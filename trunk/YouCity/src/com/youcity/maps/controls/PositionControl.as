package com.youcity.maps.controls
{
	import com.youcity.maps.AssetsEmbed;
	import com.youcity.maps.Map;
	import com.youcity.maps.MapEvent;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.overlays.LineDrawer;
	import com.youcity.maps.overlays.Marker;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.managers.CursorManager;
	
	/**
	 * Encapsulate position control logic here. 
	 * @author Administrator
	 * 
	 */	
	public class PositionControl extends ControlBase 
	{
		private var cursorID:int;
		
		/**
		 * @private
		 * Indicates whether it is measuring 
		 */		
		private var _isMeasuring:Boolean = false; 
	 
		/**
		 * @private  
		 * Indicates how much distance the map should move.
		 * Default value is 256.
		 */	 	
		private var _slideDistance:uint = 256;
		
		
		/**
		 * @private 
		 * A collection of the distance between two points
		 */	
		private var _distanceArray:Array;
		
		/**
		 * @private 
		 *  A collection of the line shapes
		 */		
		private var _lineArray:Array;
		
		/**
		 * @private 
		 *  A collection of the marker
		 */		
		private var _markerArray:Array;
		
		/**
		 * @private 
		 * 
		 * Hold the mouse position when mouse is clicked
		 */		
		private var _currentPoint:ScreenPoint;
		
		/**
		 * Hold current measure marker 
		 */		
		private var _currentMarker:Marker;
		
		/**
		 * Hold current measure line 
		 */		
		private var _currentLine:LineDrawer;
		
		/**
		 * record if mouse now down
		 */		
		private var _isMouseDown:Boolean = false;
		
		/**
		 * record is down and move
		 */		
		private var _isDraged:Boolean = false;
		
		/**
		 * Create a new positionControl with map, position and slideDistance parameters  
		 * 
		 * @param map
		 * @param position
		 * @param sildeDistance
		 * 
		 */
		public function PositionControl(map:Map, sildeDistance:uint = 400):void
		{
			super(map);
			this._slideDistance = sildeDistance;
			this._distanceArray = new Array();
			this._lineArray = new Array();
			this._markerArray = new Array();
		}

		/**
		 * Indicates how much distance the map should move
		 * 
		 * @return 
		 */		 
		public function getSlideDistance():Number
		{
			return this._slideDistance;
		}
		 
		/**
		 * Set slide distance value.
		 * @param value
		 * 
		 * 
		 */		 
		public function setSlideDistance( value: Number):void
		{
			if (value <= 0)
			{
				return;
			}
			this._slideDistance = value;
		}
		
		/**
		 * Forward north by distance
		 * 
		 */		 
		public function forwardNorth():void 
		{
			this.map.moveMapByCoordinate(0, 0-this.getSlideDistance());
		}
	 
		/**
		 * Forward west by distance
		 * 
		 */	 	
		public function forwardWest():void
		{
			this.map.moveMapByCoordinate(0-this.getSlideDistance(),  0);
		}
		
		/**
		 * Forward east by distance
		 * 
		 */		 
		public function forwardEast():void 
		{
			this.map.moveMapByCoordinate(this.getSlideDistance(),  0);
		}
		
		/**
		 * Forward south by distance
		 * 
		 */		
		public function forwardSouth():void 
		{
			this.map.moveMapByCoordinate(0, this.getSlideDistance());
		}
		
		/**
		 * When you start your measuring ,invoke this method to measure.
		 * 
		 */	
		private var currentCursor:uint = 0;
			 
		public function measureStart():void
		{
			currentCursor = CursorManager.currentCursorID;
			CursorManager.removeAllCursors();
			cursorID = CursorManager.setCursor(AssetsEmbed.OVERLAY_MARKER_ICON, 2, 0, -28);
			
			this._isMeasuring = true;
			var e:MapEvent = new MapEvent(MapEvent.MEASURE_START);
			this.map.dispatchEvent(e);
			//this.map.disableDrag();
			this.map.doubleClickEnabled = true;
			this.map.addEventListener(MouseEvent.MOUSE_DOWN, mapDownHandler);
			this.map.addEventListener(MouseEvent.MOUSE_UP, handleMapClick);
			this.map.addEventListener(MouseEvent.DOUBLE_CLICK, handleMapDoubleClick);
		}
		
		/**
		 * When you finished your measuring ,invoke this method to calculate the measured distance
		 * 
		 */		
		public function measureEnd():void
		{
			CursorManager.removeCursor(cursorID);
			
			this._isMeasuring = false;
			
			this.map.doubleClickEnabled = false;
			this.map.removeEventListener(MouseEvent.MOUSE_DOWN, mapDownHandler);
			this.map.removeEventListener(MouseEvent.MOUSE_UP, handleMapClick);
			this.map.removeEventListener(MouseEvent.DOUBLE_CLICK, handleMapDoubleClick);
			var result:Number = returnMeasureResult();
			this.clear();
			//if (result <= 0) return;
			var e:MapEvent = new MapEvent(MapEvent.MEASURE_END);
			e.data = result;
			this.map.dispatchEvent(e);
		}
		
		/**
		 * @private
		 * @return 
		 * 
		 */		
		private function returnMeasureResult():Number
		{
			var sum:Number = 0
			for (var i:String in this._distanceArray)
			{
				sum += _distanceArray[i];
			}
			return sum;
		}
		
		/**
		 * @private
		 * 
		 */		
		private function clear():void
		{
			//clear markers
			for (var j:String in this._markerArray)
			{
				map.removeOverlay(_markerArray[j]);
			}
			this._markerArray = new Array();
			
			//clear lines
			for (var k:String in this._lineArray)
			{
				map.removeOverlay(_lineArray[k]);
			}
			this._lineArray = new Array();
			
			//clear result distance
			this._distanceArray = new Array();
			this._currentPoint = null;
			this._currentMarker = null;
			this._currentLine = null;
		}
		
		
		private function mapDownHandler(event:MouseEvent):void
		{
			_isMouseDown = true;
		}

		
		/**
		 * @private
		 * 
		 */		
		private function handleMapClick(event:MouseEvent):void
		{
			if (!_isMouseDown)  return;
			_isMouseDown = false;
			if (_isDraged) 
			{
				_isDraged = false;
				return;
			}
			
			if (!_isMeasuring)
			{
				this.map.removeEventListener(MouseEvent.CLICK, handleMapClick);
			}
			else
			{	
				this._currentPoint = map.mouseToScreen(new Point(event.currentTarget.mouseX, event.currentTarget.mouseY));
				doClick();	
			}
		}
		
		/**
		 * 
		 * @private 
		 */		
		private function doClick():void
		{
			this.map.removeEventListener(MouseEvent.MOUSE_MOVE, handleMapMouseMove);
			if (_currentLine && !_currentPoint.equalsTo(_currentLine.position))
			{
				_currentLine.drawLine(_currentPoint);
				_distanceArray.push(map.point_measure(_currentLine.position, _currentPoint));
			}
			
			_currentLine = new LineDrawer(_currentPoint);
			map.addOverlay(_currentLine);
			_lineArray.push(_currentLine);
			var tip:Sprite = generateResultTip(returnMeasureResult() + "m");
			tip.x = 20;
			tip.y = 0;
			
			_currentMarker = new Marker(_currentPoint);
			_currentMarker.addChild(tip);
			this.map.addOverlay(_currentMarker);
			_markerArray.push(_currentMarker);
			
			map.addEventListener(MouseEvent.MOUSE_MOVE, handleMapMouseMove);
		}
		
		private function handleMapDoubleClick(event:MouseEvent):void
		{
			this.measureEnd();
		}
		
		/**
		 * When mouse move on the map, clear the current line and redraw it.
		 * @private
		 */		
		private function handleMapMouseMove(event:MouseEvent):void
		{
			if (_isMouseDown) _isDraged = true;
			if (!_currentLine) return;
			
			_currentPoint = map.mouseToScreen(new Point(event.currentTarget.mouseX, event.currentTarget.mouseY));
			_currentLine.drawLine(_currentPoint);
		}
		
		private function generateResultTip(content:String):Sprite
		{
			var tip:Sprite = new Sprite();
			
			var txt:TextField = new TextField();
			txt.text = content;
			txt.border = true;
			txt.borderColor = 0x5F9EA0;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.backgroundColor = 0x000000;
			var format:TextFormat = new TextFormat();
			format.color = 0xEADDFF;
			format.size = 14;
			format.bold = "bold";
			txt.setTextFormat(format); 
			
			txt.x = 0;
			txt.y = 0;
			
			tip.addChild(txt);
			tip.alpha = 0.7;
			tip.graphics.beginFill(0x000000, .5);
			tip.graphics.drawRect(0, 0, txt.width, txt.height);
			tip.graphics.endFill();
			return tip;
		}
		
	}
}