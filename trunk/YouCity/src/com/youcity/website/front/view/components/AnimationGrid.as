////////////////////////////////////////////////////////////////////////////////
//
// Copy from Tile.as, just modify some of the code. For animation
// Copyright Reseved Adobe.Inc
////////////////////////////////////////////////////////////////////////////////

package com.youcity.website.front.view.components
{

	import flash.events.Event;
	
	import gs.TweenLite;
	
	import mx.containers.TileDirection;
	import mx.core.Container;
	import mx.core.EdgeMetrics;
	import mx.core.IUIComponent;
	import mx.core.ScrollPolicy;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	[Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]
	
	[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]
	
	[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]
	
	[Style(name="paddingTop", type="Number", format="Length", inherit="no")]
	
	[Style(name="verticalAlign", type="String", enumeration="bottom,middle,top", inherit="no")]
	
	[Style(name="verticalGap", type="Number", format="Length", inherit="no")]
	
	[Exclude(name="focusIn", kind="event")]
	[Exclude(name="focusOut", kind="event")]
	
	[Exclude(name="focusBlendMode", kind="style")]
	[Exclude(name="focusSkin", kind="style")]
	[Exclude(name="focusThickness", kind="style")]
	
	[Exclude(name="focusInEffect", kind="effect")]
	[Exclude(name="focusOutEffect", kind="effect")]
	
	public class AnimationGrid extends Container
	{
		public function AnimationGrid()
		{
			super();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
		}
	
		mx_internal var cellWidth:Number;
	
		mx_internal var cellHeight:Number;
	
		private var _direction:String = TileDirection.HORIZONTAL;
	
		[Bindable("directionChanged")]
		[Inspectable(category="General", enumeration="vertical,horizontal", defaultValue="horizontal")]
	
		public function get direction():String
		{
			return _direction;
		}
	
		public function set direction(value:String):void
		{
			_direction = value;
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("directionChanged"));
		}
	
		private var _tileHeight:Number;
	
		[Bindable("resize")]
		[Inspectable(category="General")]
	
		public function get tileHeight():Number
		{
			return _tileHeight;
		}
	
		public function set tileHeight(value:Number):void
		{
			_tileHeight = value;
			invalidateSize();
		}
	
		private var _tileWidth:Number;
	
		[Bindable("resize")]
		[Inspectable(category="General")]
	
		public function get tileWidth():Number
		{
			return _tileWidth;
		}
	
		public function set tileWidth(value:Number):void
		{
			_tileWidth = value;
			invalidateSize();
		}
	
	override protected function measure():void
	{
	super.measure();
	
	var preferredWidth:Number;
	var preferredHeight:Number;
	var minWidth:Number;
	var minHeight:Number;
	
	// Determine the size of each tile cell and cache the values
	// in cellWidth and cellHeight for later use by updateDisplayList().
	findCellSize();
	
	// Min width and min height are large enough to display a single child.
	minWidth = cellWidth;
	minHeight = cellHeight;
	
	// Determine the width and height necessary to display the tiles
	// in an N-by-N grid (with number of rows equal to number of columns).
	var n:int = numChildren;
	
	// Don't count children that don't need their own layout space.
	var temp:int = n;
	for (var i:int = 0; i < n; i++)
	{
	if (!IUIComponent(getChildAt(i)).includeInLayout)
	temp--;
	}
	n = temp;
	
	if (n > 0)
	{
	var horizontalGap:Number = getStyle("horizontalGap");
	var verticalGap:Number = getStyle("verticalGap");
	
	var majorAxis:Number;
	
	// If an explicit dimension or flex is set for the majorAxis,
	// set as many children as possible along the axis.
	if (direction == TileDirection.HORIZONTAL)
	{
	var unscaledExplicitWidth:Number = explicitWidth / Math.abs(scaleX);
	if (!isNaN(unscaledExplicitWidth))
	{
	// If we have an explicit height set,
	// see how many children can fit in the given height
						majorAxis = Math.floor(unscaledExplicitWidth / (cellWidth + horizontalGap));
	}
	}
	else
	{
	var unscaledExplicitHeight:Number = explicitHeight / Math.abs(scaleY);
	if (!isNaN(unscaledExplicitHeight))
	{
	// If we have an explicit height set,
	// see how many children can fit in the given height
	majorAxis = Math.floor(unscaledExplicitHeight /
	 (cellHeight + verticalGap));
	}
	}
	
	// Finally, if majorAxis still isn't defined, use the
	// square root of the number of children.
	if (isNaN(majorAxis))
	majorAxis = Math.ceil(Math.sqrt(n));
	
	// Even if there's not room, force at least one cell
	// on each row/column.
	if (majorAxis < 1)
	majorAxis = 1;
	
	var minorAxis:Number = Math.ceil(n / majorAxis);
	
	if (direction == TileDirection.HORIZONTAL)
	{
	preferredWidth = majorAxis * cellWidth +
	 (majorAxis - 1) * horizontalGap;
	
	preferredHeight = minorAxis * cellHeight +
	(minorAxis - 1) * verticalGap;
	}
	else
	{
	preferredWidth = minorAxis * cellWidth +
	 (minorAxis - 1) * horizontalGap;
	
	preferredHeight = majorAxis * cellHeight +
	(majorAxis - 1) * verticalGap;
	}
	}
	else
	{
	preferredWidth = minWidth;
	preferredHeight = minHeight;
	}
	
	var vm:EdgeMetrics = viewMetricsAndPadding;
	var hPadding:Number = vm.left + vm.right;
	var vPadding:Number = vm.top + vm.bottom;
	
	// Add padding for margins and borders.
	minWidth += hPadding;
	preferredWidth += hPadding;
	minHeight += vPadding;
	preferredHeight += vPadding;
	
	measuredMinWidth = Math.ceil(minWidth);
	measuredMinHeight = Math.ceil(minHeight);
	measuredWidth = Math.ceil(preferredWidth);
	measuredHeight = Math.ceil(preferredHeight);
	}
	
	override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
	
		if (isNaN(cellWidth) || isNaN(cellHeight)) findCellSize();
		var vm:EdgeMetrics = viewMetricsAndPadding;

		var paddingLeft:Number = getStyle("paddingLeft");
		var paddingTop:Number = getStyle("paddingTop");
		
		var horizontalGap:Number = getStyle("horizontalGap");
		var verticalGap:Number = getStyle("verticalGap");
		 
		var horizontalAlign:String = getStyle("horizontalAlign");
		var verticalAlign:String = getStyle("verticalAlign");
		
		var xPos:Number = paddingLeft;
		var yPos:Number = paddingTop;
		
		var xOffset:Number;
		var yOffset:Number;
		
		var n:int = numChildren;
		var i:int;
		var child:IUIComponent;
		
		if (direction == TileDirection.HORIZONTAL)
		{
		var xEnd:Number = Math.ceil(unscaledWidth) - vm.right;
		
		for (i = 0; i < n; i++)
		{
		child = IUIComponent(getChildAt(i));
		
		if (!child.includeInLayout)
		continue;
		
		// Start a new row?
		if (xPos + cellWidth > xEnd)
		{
		// Only if we have not just started one...
		if (xPos != paddingLeft)
		{
		yPos += (cellHeight + verticalGap);
		xPos = paddingLeft;
		}
		}
		
		setChildSize(child); // calls child.setActualSize()
		
		// Calculate the offsets to align the child in the cell.
		xOffset = Math.floor(calcHorizontalOffset(
		child.width, horizontalAlign));
		yOffset = Math.floor(calcVerticalOffset(child.height, verticalAlign));
						TweenLite.to(child, 0.2 + i * 0.3 / Math.pow(1.2, i) * (0.5 + Math.random()), {x:xPos + xOffset, y:yPos + yOffset});
	//					TweenLite.to(child, 0.8, {x:xPos + xOffset, y:yPos + yOffset});
	//					child.move(xPos + xOffset, yPos + yOffset);
		
		xPos += (cellWidth + horizontalGap);
		}
		}
		else
		{
		var yEnd:Number = Math.ceil(unscaledHeight) - vm.bottom;
		
		for (i = 0; i < n; i++)
		{
		child = IUIComponent(getChildAt(i));
		
		if (!child.includeInLayout)
		continue;
		
		// Start a new column?
		if (yPos + cellHeight > yEnd)
		{
		// Only if we have not just started one...
		if (yPos != paddingTop)
		{
		xPos += (cellWidth + horizontalGap);
		yPos = paddingTop;
		}
		}
		
		setChildSize(child); // calls child.setActualSize()
		
						// Calculate the offsets to align the child in the cell.
						xOffset = Math.floor(calcHorizontalOffset(child.width, horizontalAlign));
						yOffset = Math.floor(calcVerticalOffset(child.height, verticalAlign));
						
	//					child.move(xPos + xOffset, yPos + yOffset);
						TweenLite.to(child, 0.2 + i * 0.3 / Math.pow(1.2, i) * (0.5 + Math.random()), {x:xPos + xOffset, y:yPos + yOffset});
		yPos += (cellHeight + verticalGap);
		}
		}
			cellWidth = NaN;
			cellHeight = NaN;
		}
	
		mx_internal function findCellSize():void
		{
			// If user explicitly supplied both a tileWidth and
			// a tileHeight, then use those values.
			var widthSpecified:Boolean = !isNaN(tileWidth);
			var heightSpecified:Boolean = !isNaN(tileHeight);
			if (widthSpecified && heightSpecified)
			{
				cellWidth = tileWidth;
				cellHeight = tileHeight;
				return;
			}
	
			// Reset the max child width and height
			var maxChildWidth:Number = 0;
			var maxChildHeight:Number = 0;
			
			// Loop over the children to find the max child width and height.
			var n:int = numChildren;
			for (var i:int = 0; i < n; i++)
			{
				var child:IUIComponent = IUIComponent(getChildAt(i));
				if (!child.includeInLayout) continue;
				var width:Number = child.getExplicitOrMeasuredWidth();
				if (width > maxChildWidth) maxChildWidth = width;
				var height:Number = child.getExplicitOrMeasuredHeight();
				if (height > maxChildHeight) maxChildHeight = height;
			}
			
			// If user explicitly specified either width or height, use the
			// user-supplied value instead of the one we computed.
			cellWidth = widthSpecified ? tileWidth : maxChildWidth;
			cellHeight = heightSpecified ? tileHeight : maxChildHeight;
		}
	
		private function setChildSize(child:IUIComponent):void
		{
			var childWidth:Number;
			var childHeight:Number;
			var childPref:Number;
			var childMin:Number;
			
			if (child.percentWidth > 0)
			{
				// Set child width to be a percentage of the size of the cell.
				childWidth = Math.min(cellWidth,cellWidth * child.percentWidth / 100);
			}
			else
			{
				// The child is not flexible, so set it to its preferred width.
				childWidth = child.getExplicitOrMeasuredWidth();
			
				// If an explicit tileWidth has been set on this Tile,
				// then the child may extend outside the bounds of the tile cell.
				// In that case, we'll honor the child's width or minWidth,
				// but only if those values were explicitly set by the developer,
				// not if they were implicitly set based on measurements.
				if (childWidth > cellWidth)
				{
					childPref = isNaN(child.explicitWidth) ?0 : child.explicitWidth;
					childMin = isNaN(child.explicitMinWidth) ? 0 : child.explicitMinWidth;
					childWidth = (childPref > cellWidth || childMin > cellWidth) ? Math.max(childMin, childPref) : cellWidth;
				}
			}
			if (child.percentHeight > 0)
			{
				childHeight = Math.min(cellHeight,cellHeight * child.percentHeight / 100);
			}
			else
			{
				childHeight = child.getExplicitOrMeasuredHeight();
				if (childHeight > cellHeight)
				{
					childPref = isNaN(child.explicitHeight) ?0 :child.explicitHeight;
					childMin = isNaN(child.explicitMinHeight) ?0 : child.explicitMinHeight;
					childHeight = (childPref > cellHeight || childMin > cellHeight) ?Math.max(childMin, childPref) : cellHeight;
				}
			}
			child.setActualSize(childWidth, childHeight);
		}
	
		/**
		 *@private
		 *Compute how much adjustment must occur in the x direction
		 *in order to align a component of a given width into the cell.
		 */
		mx_internal function calcHorizontalOffset(width:Number, horizontalAlign:String):Number
		{
			var xOffset:Number;
			if (horizontalAlign == "left")xOffset = 0;
			else if (horizontalAlign == "center") xOffset = (cellWidth - width) / 2;
			else if (horizontalAlign == "right") xOffset = (cellWidth - width); 
			return xOffset;
		}
	
		mx_internal function calcVerticalOffset(height:Number, verticalAlign:String):Number
		{
			var yOffset:Number;
			if (verticalAlign == "top") yOffset = 0;
			else if (verticalAlign == "middle") yOffset = (cellHeight - height) / 2;
			else if (verticalAlign == "bottom") yOffset = (cellHeight - height);
			return yOffset;
		}
	}

}
