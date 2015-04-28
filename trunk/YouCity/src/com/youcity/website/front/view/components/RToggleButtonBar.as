	package com.youcity.website.front.view.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.containers.ViewStack;
	import mx.controls.Button;
	import mx.controls.ToggleButtonBar;
	import mx.core.Container;
	import mx.core.ContainerCreationPolicy;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.CollectionEvent;
	import mx.events.IndexChangedEvent;
	
	use namespace mx_internal;

	public class RToggleButtonBar extends ToggleButtonBar
	{
		
		public function RToggleButtonBar()
		{
			super();
		}
		
		private var new_dataProviderChanged:Boolean = false;
		
		private var measurementHasBeenCalled:Boolean = false;
		
		private var pendingTargetStack:Object;
		
		private var lastToolTip:String = null;
		
		private var _dataProvider:IList;
		
		private var _selectedIndex:int = -1;
		
	    /**
	     *  @private
	     */
	    override public function set dataProvider(value:Object /* can be either String, ViewStack, Array or IList */):void
	    {
	        var message:String;
			
			if (value && !(value is String) && !(value is ViewStack) && !(value is Array) && !(value is IList))
	        {
				message = resourceManager.getString("controls", "errWrongContainer", [ id ]);
	            throw new Error(message);
	        }
	
	        // If value is a string, try to resolve here.
	        // If value is a ViewStack name, document[value] may not be defined yet.
	        // In this case, fall through to the code below
	        // which will setup a pending target view stack.
	        if ((value is String) && (document && document[value]))
	            value = document[value];
	
	        if ((value is String) || (value is ViewStack))
	        {
	            setTargetViewStack(value);
	            return;
	        }
	        else if ((value is IList && IList(value).length > 0 &&
	                 IList(value).getItemAt(0) is DisplayObject) ||
	                 (value is Array && (value as Array).length > 0 &&
	                 value[0] is DisplayObject))
	        {
	            var name:String = id ? className + " '" + id + "'" : "a " + className;
	            message = resourceManager.getString("controls", "errWrongType", [ name ]);
				throw new Error(message);
	        }
	
	        // Clear any existing target stack.
	        setTargetViewStack(null);
	        removeAllChildren();
	
	        if (value is IList)
	            _dataProvider = IList(value);
	        else if (value is Array)
	            _dataProvider = new ArrayCollection(value as Array);
	        else
	            _dataProvider = null;
			
	        new_dataProviderChanged = true;
	        invalidateProperties();
	
	        if (_dataProvider)
	        {
	            // use weak reference
	            _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
	        }
	
	        // Styles might not have been set yet, so short circuit and let
	        // createChildren() handle the rest.
	        if (inheritingStyles == UIComponent.STYLE_UNINITIALIZED)
	            return;
	
	        dispatchEvent(new Event("collectionChange"));
	    }
	    
	    /**
	     *  @private
	     */
	    private function setTargetViewStack(newStack:Object /* can be String or ViewStack */):void
	    {
	        // If this property is set at creation time, the target view stack
	        // may not exist yet. In this case, we just save off the requested
	        // target stack and set it later.
	        if (!measurementHasBeenCalled && newStack)
	        {
	            pendingTargetStack = newStack;
	            invalidateProperties();
	        }
	        else
	        {
	            _setTargetViewStack(newStack);
	        }
	    }
	    
	    /**
	     *  @private
	     */
	    private function _setTargetViewStack(newStack:Object /* can be String or ViewStack */):void
	    {
	        var newTargetStack:ViewStack;
	
	        if (newStack is ViewStack)
	        {
	            newTargetStack = ViewStack(newStack);
	        }
	        else if (newStack)
	        {
	            // newStack is not a ViewStack.
	            // First, look for it on the current document
	            newTargetStack = parentDocument[newStack];
	        }
	        else
	        {
	            newTargetStack = null;
	        }
	
	        // Remove any existing event listeners
	        if (targetStack)
	        {
	            targetStack.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD, childAddHandler);
	            targetStack.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, childRemoveHandler);
	            targetStack.removeEventListener(Event.CHANGE, changeHandler);
	            targetStack.removeEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE, childIndexChangeHandler);
	        }
	
	        // Clear out the current links
	        removeAllChildren();
	        _selectedIndex = -1;
	
	        targetStack = newTargetStack;
	
	        if (!targetStack)
	            return;
	
	        targetStack.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, childAddHandler);
	        targetStack.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, childRemoveHandler);
	        targetStack.addEventListener(Event.CHANGE, changeHandler);
	        targetStack.addEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE, childIndexChangeHandler);
	
	        var numViews:int = targetStack.numChildren;
	
	        for (var i:int = 0; i < numViews; i++)
	        {
	            var child:Container = Container(targetStack.getChildAt(i));
	            var item:Button = Button(createNavItem(itemToLabel(child), child.icon));
	
	                 
	
	            // Make the nav item inherit the tooltip from the child
	            if (child.toolTip)
	            {
	                item.toolTip = child.toolTip;
	                child.toolTip = null;
	            }
	            
	            child.addEventListener("labelChanged", labelChangedHandler);
	            child.addEventListener("iconChanged", iconChangedHandler);
	            child.addEventListener("enabledChanged", enabledChangedHandler);
	        	child.addEventListener("toolTipChanged", toolTipChangedHandler);      
	
	            item.enabled = enabled && child.enabled;
	        }
	
	        var index:int = targetStack.selectedIndex;
	        if (index == -1 && targetStack.numChildren > 0)
	            index = 0;
	
	        if (index != -1)
//	            hiliteSelectedNavItem(index);
	
	        invalidateDisplayList();
	    }
	    
	    /**
	     *  @private
	     */
	    private function checkPendingTargetStack():void
	    {
	        // Check for pending target view stacks.
	        if (pendingTargetStack)
	        {
	            _setTargetViewStack(pendingTargetStack);
	            pendingTargetStack = null;
	        }
	    }	
	    
	    override protected function createChildren():void
	    {
//			ToggleButtonBar has exclude borderSkin style, so no need to invoke createBorder()	    	
//	    	createBorder();
			actualCreationPolicy = ContainerCreationPolicy.AUTO;
			createComponentsFromDescriptors();
			
			if (new_dataProviderChanged)
			{
			    createNavChildren();
			    new_dataProviderChanged = false;
			}
	    }
	    
	    /**
	     *  @private
	     */
	    private function createNavChildren():void
	    {
	        if (!_dataProvider)
	            return;
	
	        var n:int = _dataProvider.length;
	        for (var i:int = 0; i < n; i++)
	        {
	            var item:Object = _dataProvider.getItemAt(i);
	            var navItem:Button = new Button();
	            	
            	for (var p:String in item)
            	{
            		if(navItem.hasOwnProperty(p))
            		navItem[p] = item[p];
            	}
            	
            	navItem.setStyle("focusAlpha", 0);
            	navItem.enabled = enabled;
            	navItem.focusEnabled = false;
		       	navItem.toggle = true;
	        	navItem.addEventListener(MouseEvent.CLICK, clickHandler);
	        	addChild(navItem);
	        }
	    }	
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (new_dataProviderChanged)
			{
				new_dataProviderChanged = false;
				createNavChildren();
			}
		}
		
		override public function styleChanged(styleProp:String):void
		{
			//to do
		}
		
		/**
	     *  @private
	     */
	    private function collectionChangeHandler(event:Event):void
	    {
	       // Brute force -- rebuild everything...//强制刷新. 重新执行 set dataProvider方法 ？？
	        dataProvider = dataProvider;
	    }
	
	    /**
	     *  @private
	     */
	    private function childAddHandler(event:ChildExistenceChangedEvent):void
	    {
	        // Prevent infinite recursion; the call to createNavItem() below
	        // can cause this handler to get invoked due to event bubbling,
	        // such as when a TabBar is inside a TabNavigator.
	        if (event.target == this)
	            return;
	
	        // Bail if this isn't a child of the target stack.
	        if (event.relatedObject.parent != targetStack)
	            return;
	
	        var newChild:Container = Container(event.relatedObject);
	        var item:Button = Button(createNavItem(itemToLabel(newChild), newChild.icon));
	        var index:int = newChild.parent.getChildIndex(DisplayObject(newChild));
	        setChildIndex(item, index);
	
	        if (newChild.toolTip)
	        {
	            item.toolTip = newChild.toolTip;
	            newChild.toolTip = null;
	        }
	
	        newChild.addEventListener("labelChanged", labelChangedHandler);
	        newChild.addEventListener("iconChanged", iconChangedHandler);
	        newChild.addEventListener("enabledChanged", enabledChangedHandler);
	        newChild.addEventListener("toolTipChanged", toolTipChangedHandler);
		
	        item.enabled = enabled && newChild.enabled;
	    }
	
	    /**
	     *  @private
	     */
	    private function childRemoveHandler(event:ChildExistenceChangedEvent):void
	    {
	        // Prevent infinite recursion; the call to removeChildAt() below
	        // can cause this handler to get invoked due to event bubbling,
	        // such as when a TabBar is inside a TabNavigator.
	        if (event.target == this)
	            return;
	
	        var viewStack:ViewStack = ViewStack(event.target);
	        removeChildAt(viewStack.getChildIndex(event.relatedObject));
	
	        callLater(resetNavItems);
	    }
	
	    /**
	     *  @private
	     */
	    private function changeHandler(event:Event):void
	    {
	        // Change events from text fields propagate, so we need to make sure
	        // this event is coming from our dataProvider
	        if (event.target == dataProvider)
	            hiliteSelectedNavItem(Object(event.target).selectedIndex);
	    }
	
	    /**
	     *  @private
	     */
	    private function childIndexChangeHandler(event:IndexChangedEvent):void
	    {
	        // Prevent infinite recursion; the call to setChildIndex() below
	        // can cause this handler to get invoked due to event bubbling,
	        // such as when a TabBar is inside a TabNavigator.
	        if (event.target == this)
	            return;
	
	        setChildIndex(getChildAt(event.oldIndex), event.newIndex);
	        resetNavItems();
	    }
	
	    /**
	     *  @private
	     */
	    private function labelChangedHandler(event:Event):void
	    {
	        // Event.target is a child of the target view stack. Need to
	        // convert to index
	        var itemIndex:int = targetStack.getChildIndex(DisplayObject(event.target));
	
	        updateNavItemLabel(itemIndex, Container(event.target).label);
	    }
	
	    /**
	     *  @private
	     */
	    private function iconChangedHandler(event:Event):void
	    {
	        // Event.target is a child of the target view stack. Need to
	        // convert to index
	        var itemIndex:int = targetStack.getChildIndex(DisplayObject(event.target));
	
	        updateNavItemIcon(itemIndex, Container(event.target).icon);
	    }
	    
	    /**
	     * @private
	     */
	    private function toolTipChangedHandler(event:Event):void
	    {
	    	// Event.target is a child of the target view stack. Need to
	        // convert to index
	        var itemIndex:int =
	            targetStack.getChildIndex(DisplayObject(event.target));
	        var item:UIComponent = UIComponent(getChildAt(itemIndex));
			
			if (UIComponent(event.target).toolTip)
			{
				item.toolTip = UIComponent(event.target).toolTip;
				lastToolTip = UIComponent(event.target).toolTip;
				UIComponent(event.target).toolTip = null;
			}
			else if (!lastToolTip)
			{
	       		item.toolTip = UIComponent(event.target).toolTip;
	       		lastToolTip = "placeholder";
	        	UIComponent(event.target).toolTip = null;
	  		}
	  		else
	  		 	lastToolTip = null;
	    } 
	
	    /**
	     *  @private
	     */
	    private function enabledChangedHandler(event:Event):void
	    {
	        // Event.target is a child of the target view stack. Need to
	        // convert to index
	        var itemIndex:int = targetStack.getChildIndex(DisplayObject(event.target));
	
	        Button(getChildAt(itemIndex)).enabled = enabled && event.target.enabled;
	    }
		
	}
}