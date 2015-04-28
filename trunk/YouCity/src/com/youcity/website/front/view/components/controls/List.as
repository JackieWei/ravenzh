package com.youcity.website.front.view.components.controls
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import mx.controls.List;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.FlexShape;

	public class List extends mx.controls.List
	{
		private var _itemHeight:Number = 100;
		
		public function List()
		{
			super();
			this.styleName = "ycList";
		}
		
		override protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void
		{
	        var bg:Shape;
	        if (rowIndex < s.numChildren)
	        {
	            bg = Shape(s.getChildAt(rowIndex));
	        }
	        else
	        {
	            bg = new FlexShape();
	            bg.name = "rowBackground";
	            s.addChild(bg);
	        }
	
	        // Height is usually as tall is the items in the row,
	        // but not if it would extend below the bottom of listContent.
	        var height:Number = Math.min(
	            rowInfo[rowIndex].height,
	            listContent.height - rowInfo[rowIndex].y);
	
	        bg.y = rowInfo[rowIndex].y;
	
	        var g:Graphics = bg.graphics;
	        g.clear();
	        g.beginFill(color, getStyle("backgroundAlpha"));
	       	switch (rowIndex)
	       	{
	       		case 0:
	        		g.drawRoundRectComplex(0, 0, listContent.width, 100, 6, 6, 0, 0);
	        		break;
	      		case rowCount - 1:
	        		g.drawRoundRectComplex(0, 0, listContent.width, 100, 0, 0, 6, 6);
	        		break;
				default:
		        g.drawRect(0, 0, listContent.width, 100);
		        break;
	       	}
	        g.endFill();
		}

		override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			//do nothing here
		}
		
		override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			//do nothing here
		}
	}
}