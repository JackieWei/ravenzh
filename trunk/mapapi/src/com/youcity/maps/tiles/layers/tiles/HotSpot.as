package com.youcity.maps.tiles.layers.tiles
{
	import com.youcity.maps.MapConstants;
	import com.youcity.maps.MapEvent;
	import com.youcity.maps.MapEventDispatcher;
	import com.youcity.maps.MapPoint;
	import com.youcity.maps.ScreenPoint;
	import com.youcity.maps.util.DisplayUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * HotSpot area, each a instance
	 * @author Jackie Wei
	 * 跟Ad类似，每个HotSpotTile里面会有0到多个HotSpot，这个才是具体的形状，HotSpotTile本身只是作为容器
	 * 和XML解析器
	 */	
	internal final class HotSpot extends Sprite
	{
		/**
		 * title for hotspot
		 */		
		public var title:String;
		
		/**
		 * id
		 */		
		public var id:String;

		/**
		 * hotspot center
		 */		
		public var buildingCenter:MapPoint;
		
		/**
		 * lefttop point's position
		 */		
		private var _ltPoint:ScreenPoint;
		
		/**
		 * hotspot tip
		 */		
		private var _tip:Sprite;
		
		/**
		 * constructor
		 * @param id
		 * @param title
		 * @param centerX
		 * @param centerY
		 * @param coords
		 * @param ltPoint
		 * @param add
		 * @param tel
		 * record hotspot info and draw shape
		 */		
		public function HotSpot(id:String, title:String, centerX:String, centerY:String, coordsList:Array, ltPoint:ScreenPoint)
		{
			x = 0;
			y = 0;
			alpha = 0;
			
			this.id = id;
			this.title = title;
			
			buildingCenter = new MapPoint(Number(centerX), Number(centerY));
			
			_ltPoint = ltPoint;
			draw(coordsList, ltPoint);
			
			addListeners();
			addTip();
		}
		
		private function draw(coords:Array, center:ScreenPoint):void {
			graphics.lineStyle(MapConstants.HOTSPOT_LINE_WIDTH, MapConstants.HOTSPOT_LINE_COLOR, MapConstants.HOTSPOT_LINE_ALPHA);
			graphics.beginFill(MapConstants.HOTSPOT_FILL_COLOR, MapConstants.HOTSPOT_FILL_ALPHA);
			var length:int = coords.length;
			for (var i:int = 0; i < length; i ++) {
				var newX:int = coords[i][0] - center.x;
				var newY:int = coords[i][1] - center.y;
				if (i ==0) {
					graphics.moveTo(newX, newY);
				} else{
					graphics.lineTo(newX, newY);
				}
			}	
			graphics.lineTo(coords[0][0] - center.x, coords[0][1] - center.y);
			graphics.endFill();
		}
		
		//添加一些监听器，主要是为了HotSpot上的鼠标事件和拖动 
		private function addListeners():void {
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			addEventListener(MouseEvent.MOUSE_UP, upHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			addEventListener(MouseEvent.MOUSE_OVER, overSpotHandler);
			addEventListener(MouseEvent.MOUSE_OUT, outSpotHandler);
		}
		
		//add tip to hotspot
		private function addTip():void {
			if (!_tip) {
				_tip = new Sprite();
			}
			
			var content:TextField = new TextField();
			content.text = title;
			content.border = true;
			content.borderColor = 0x5F9EA0;
			content.autoSize = TextFieldAutoSize.LEFT;
			content.backgroundColor = 0x000000;
			var format:TextFormat = new TextFormat();
			format.color = 0xEADDFF;
			format.size = 20;
			format.bold = "bold";
			content.setTextFormat(format); 
			
			content.x = 0;
			content.y = 0;
			
			_tip.addChild(content);
			_tip.alpha = .7;
			_tip.graphics.beginFill(0x000000, .5);
			_tip.graphics.drawRect(0, 0, content.width, content.height);
			_tip.graphics.endFill();
			_tip.visible = false;
			addChild(_tip);
			
		}
		
		//move tip when mouse move
		private function moveTip():void {
			_tip.x = mouseX + 5;
			_tip.y = mouseY + 15;
		}
		
		/**
		 * set tip visible according to flag
		 * @param flag
		 * 
		 */		
		private function showTip(flag:Boolean):void {
			_tip.visible = flag;
		}
		
		/**
		 * flag to show if hotspot are dragging
		 */		
		private var _draging:Boolean = false;
		/**
		 * record mouse left button is down
		 */		
		private var _isDown:Boolean = false;
		
		/**
		 * @private
		 * @param event
		 * 
		 */		
		private function downHandler(event:MouseEvent):void {
			 _isDown = true;
			showTip(false);
		}
		
		/**
		 * @private
		 * @param event
		 * 
		 */	
		private function moveHandler(event:MouseEvent):void {
			if (_isDown) {
				_draging = true;
			} else {
				moveTip();
			}
		}
		
		/**
		 * @private
		 * @param event
		 */	
		private function upHandler(event:MouseEvent):void {
			if (_isDown && !_draging) clickSpotHandler();
			
			_isDown = false;
			_draging = false;
			showTip(true);
		}
		
		/**
		 * @private
		 * @param event
		 * while over, let alpha = 1 and show hotspot
		 */		
		private function overSpotHandler(event:MouseEvent):void {
			showTip(true);
			moveTip();
			
			alpha = 1;
		}
		
		/**
		 * @private
		 * @param event
		 * while over, let alpha = 0 and show hotspot
		 */		
		private function outSpotHandler(event:MouseEvent):void {
			showTip(false);
			alpha = 0;
		}
		
		/**
		 * 
		 * @param event
		 * click handler, show info
		 */		
		private function clickSpotHandler(event:MouseEvent = null):void {
			var me:MapEvent = new MapEvent(MapEvent.HOTSPOT_CLICKED);
			me.data = {buildingId:id, buildingCenter:buildingCenter, title:title};
			MapEventDispatcher.getInstance().dispatchEvent(me);
		}
		
		
		/**
		 * destruct all 
		 * and dispose this
		 */		
		public function destruct():void {
			graphics.clear();
			DisplayUtil.removeAllChildren(this);
			title = null;
			buildingCenter = null;
			_ltPoint = null;
			_tip = null;
			removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, overSpotHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, outSpotHandler);
		}
		
	}
}