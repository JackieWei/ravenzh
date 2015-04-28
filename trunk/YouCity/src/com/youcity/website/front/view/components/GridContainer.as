package com.youcity.website.front.view.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import gs.TweenLite;
	
	import mx.containers.Canvas;
	import mx.core.ContainerCreationPolicy;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.core.UIComponentGlobals;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	use namespace mx_internal;
	
	[Style(name="singularColor", 	type="uint", format="Color", inherit="no")]
	[Style(name="dualColor", 		type="uint", format="Color", inherit="no")]
	public class GridContainer extends Canvas
	{
		private var previousChildCoordinate:Point;
		
		private var horizontalGapChanged:Boolean = false;
		
		private var newStyleChanged:Boolean = false;
		
		//0xe4f4f1
		private var _singularColor:uint = 0x000000;
		private var _dualColor:uint = 0xffffff;
		
		private var _rowNum:uint;
		
		private var _alternativeDraw:Boolean;
		public function set alternativeDraw(value:Boolean):void
		{
			_alternativeDraw = value;
		}
		
//		private var _rowCount:uint;
		/**
		* HorizontalGap
		*/		
		private var _horizontalGap:Number = 8;
		
		[Bindable("horizontalGapChanged")]		
		[Inspectable (type = "Number", defaultValue = "8" )]
		public function get horizontalGap():Number
		{
			return this._horizontalGap;
		}
		
		public function set horizontalGap(value:Number):void
		{
			if (value != this._horizontalGap)
			{
				this._horizontalGap = value;
				invalidateProperties();
				this.dispatchEvent(new Event("horizontalGapChanged"));
			}
		}
		
		private var verticalGapChanged:Boolean = false;
		
		private var _verticalGap:Number = 8;	
		/**
		* VerticalGap
		*/
		[Bindable("verticalGapChanged")]		
		[Inspectable (type = "Number", defaultValue = 8 )]
		public function get verticalGap():Number
		{
			return this._verticalGap;
		}
		
		public function set verticalGap(value:Number):void
		{
			if (value != this._verticalGap)
			{
				this._verticalGap = value;
				verticalGapChanged = true;
				invalidateProperties();
				this.dispatchEvent(new Event("verticalGapChanged"));
			}
		}
		
		private var columnCountChanged:Boolean = false;
		
		private var _columnCount:uint = 2;
		
		/**
		 * Column Count
		 */				
		[Bindable("columnCountChanged")]	
		[Inspectable(defaultValue = "2")]
		public function get columnCount():uint
		{
			return this._columnCount;
		}
		
		public function set columnCount(value:uint):void
		{
			if (value != this._columnCount)
			{
				this._columnCount = value;
				columnCountChanged = true;
				invalidateProperties();
				this.dispatchEvent(new Event("columnCountChanged"));
			}
		}
		
//		private static var classConstructed:Boolean = classContrut();
//		
//		private static function classContrut():Boolean
//		{
//			if (!StyleManager.getStyleDeclaration("GridContainer"))
//			{
//				var gcStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
//				gcStyle.defaultFactory = function():void
//				{
//					this.dualColor = 0xFFFFFF;
//					this.singularColor = 0xFFFFFF;
//				}
//				StyleManager.setStyleDeclaration("GridContainer", gcStyle, false);
//			}
//			return true;
//		}
		
		public function GridContainer()
		{
			super();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			previousChildCoordinate = new Point(0, 0);
			addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
			addEventListener(FlexEvent.UPDATE_COMPLETE, handleUpdateComplete);
		}
		
		private function handleCreationComplete(event:FlexEvent):void
		{
			
		}
		
		private function handleUpdateComplete(event:FlexEvent):void
		{
			placeChildren();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (horizontalGapChanged || verticalGapChanged || columnCountChanged)
			{
				horizontalGapChanged = false;
				verticalGapChanged = false;
				columnCountChanged = false;
				placeChildren();
			}
		}
		
		protected function placeChild(child:UIComponent):void
		{
			var index:uint = getChildIndex(child);
			var xPos:Number = 0;
			var yPos:Number = 0;
			
			if (index == 0)
			{
				xPos = 0;
				yPos = 0;
			}
			else
			{
				if (index % columnCount == 0)
				{
					xPos = 0;
					yPos = previousChildCoordinate.y + this.getChildAt(index - 1).height + verticalGap;
				}
				else
				{
					xPos = previousChildCoordinate.x + this.getChildAt(index - 1).width + horizontalGap;
					yPos = previousChildCoordinate.y;
				}
			}
			
			previousChildCoordinate.x = xPos;
			previousChildCoordinate.y = yPos;
			
			//add effect 
			TweenLite.to(child, 0.2 + index * 0.3 / Math.pow(1.2, index), {x:xPos, y:yPos});
//			TweenLite.to(child, 0.5, {x:xPos, y:yPos, delay:index*0.005});
		}
		
		protected function placeChildren():void
		{
			for (var i:uint = 0; i < numChildren; i ++)
			{
				placeChild(getChildAt(i) as UIComponent);
			}
			if (_alternativeDraw) drawBackdrop();
		}
		
		
		private function drawBackdrop():void
		{
			if (numChildren <= 0) return;
			var __rowNum:Number = Math.ceil(numChildren / columnCount);
			graphics.clear();
			var singular:Boolean = true;
			var temY:Number=0;
			for (var i:uint = 0; i < __rowNum; i++)
			{
				var index:int = (i == 0 ? i : i * columnCount);
				var child:UIComponent = getChildAt(index) as UIComponent;
				if (singular) 
					drawSingular(5, temY, width - 10 , child.height + verticalGap);
				else
					drawDual(5, temY, width - 10, child.height + verticalGap);
				singular = !singular;
				temY += child.height + verticalGap;
			}
		}
		
		private function drawSingular(x1:Number, y1:Number, width:Number, height:Number):void
		{
			var cor:Number = Number(getStyle("cornerRadius"))
			graphics.beginFill(0xe4f4f1, 1);
			graphics.drawRoundRect(x1, y1,width, height, cor + 6, cor + 6);
			graphics.endFill();
		}
		private function drawDual(x1:Number, y1:Number, width:Number, height:Number):void
		{
			var cor:Number = Number(getStyle("cornerRadius"));
			graphics.beginFill(_dualColor, 1);
			graphics.drawRoundRect(x1, y1,width, height, cor + 2, cor + 2);
			graphics.endFill();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
//			child.x = (this.width - child.width) / 2 ;
//			child.y = (this.height - child.height) / 2;
			child.y =  - child.height;
			return super.addChild(child);
		}
		
		override protected function createChildren():void
		{
			createBorder();
			actualCreationPolicy = ContainerCreationPolicy.AUTO;
	        createComponentsFromDescriptors();
		}
		
		override public function styleChanged(styleProp:String):void		
		{
			super.styleChanged(styleProp);
			if ("singularColor" == styleProp 
				||	"dualColor" == styleProp 
				||	null == styleProp)
			{
				newStyleChanged = true;
				invalidateDisplayList();
				return;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (newStyleChanged)
			{
				newStyleChanged = false;
				_singularColor = getStyle("singularColor");
				_dualColor = getStyle("dualColor");
//				drawBackdrop();
			}
		}
		
		/**
	     *  @private
	     *  This function is called when the LayoutManager finishes running.
	     *  Clear the forceLayout flag that was set earlier.
	     */
	    private function layoutCompleteHandler(event:FlexEvent):void
	    {
	        UIComponentGlobals.layoutManager.removeEventListener(
	            FlexEvent.UPDATE_COMPLETE, layoutCompleteHandler);
	    }
		
	}
}