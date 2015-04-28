package com.youcity.website.front.view.common
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.core.Container;
	import mx.core.ContainerCreationPolicy;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;
	
	[Event(name = "closeView", 	type = "flash.events.Event")]	
	[Event(name = "minimizeView", type = "flash.events.Event")]	
	[Event(name = "maximizeView", type = "flash.events.Event")]	
	
	[Style(name = "innerBackgroundImage", type = "Class", inherit = "no")]
	public class ViewBase extends Canvas
	{
		//view close event
		public static const EVENT_CLOSE_VIEW:String = "closeView";
		
		public static const EVENT_MINIMIZE_VIEW:String = "minimizeView";
		
		public static const EVENT_MAXIMIZE_VIEW:String = "maximizeView";
		
		//normal state
		public static const STATE_NORMAL:String = "normal";
		
		//minimized state
		public static const STATE_MINIMIZED:String = "minimized";
		
		public static const TITLE_HEIGHT:Number = 40;
		
		// ------------------------------
		//	title
		// ------------------------------
		/**
		 * Storage for the title property
		 * @private 
		 */		
		private var _title:String;
		
		/**
		 * Indicates whether title property's value changed or not
		 * @private 
		 */		
		private var titleChanged:Boolean = false;
		
		/**
		 * Return the title of this component 
		 * @return 
		 * 
		 */		
		public function get title():String
		{
			return this._title;
		}
		public function set title(value:String):void
		{
			if (value != null && value != title)
			{
				this._title = value;
				this.titleChanged = true;
				this.invalidateProperties();
			}
		}
		
		// ------------------------------
		//	titleIcon
		// ------------------------------
		/**
		 * Storage for the icon property
		 * @private  
		 */		
		private var _titleIcon:Object;
		
		/**
		 * Indicates whether icon property'value changed or not
		 * @private 
		 */		
		private var titleIconChanged:Boolean = false;
		
		/**
		 * Return the value of icon.  
		 * @return 
		 * 
		 */		
		public function get titleIcon():Object
		{
			return this._titleIcon;
		}
		
		public function set titleIcon(value:Object):void
		{
			if (value != null && value != titleIcon)
			{
				this._titleIcon = value;
				this.titleIconChanged = true;
				this.invalidateProperties();
			}
		}
		
		override public function initialize():void
		{
			super.initialize();
			/* try 
			{
				super.initialize();
			}
			catch (e:Error)
			{
				trace(e.toString());
			} */
		}
		
		/**
		 * Storage for the draggable property
		 * Indicates whether this component can be dragged or not
		 * @private 
		 */
		private var _draggable:Boolean = true;
		
		[Inspectable(defaultValue="true", type="Boolean")]
		public function get draggable():Boolean
		{
			return this._draggable
		}
		
		public function set draggable(value:Boolean):void
		{
			this._draggable = value;
		}
		
		/**
		 * Storage for the closeable property
		 * Indicates whether this component can be closed or not
		 * @private
		 */		
		private var _closeable:Boolean = true;
		
		[Inspectable(defaultValue="true", type="Boolean")]
		public function get closeable():Boolean
		{
			return this._closeable;
		}
		
		public function set closeable(value:Boolean):void
		{
			this._closeable = value;
		}
		
		/**
		 * Storage for the removeable property
		 * Indicates whether this component can be removed or not from the memory
		 * @private
		 */		
		private var _removeable:Boolean = true;
		
		[Inspectable(defaultValue = true)]
		public function get removeable():Boolean
		{
			return this._removeable;
		}
		
		public function set removeable(value:Boolean):void
		{
			this._removeable = value;
		}
	
		private var _resizeable:Boolean = false;
		
		[Inspectable(defaultValue = true)]
		public function get resizeable():Boolean
		{
			return this._resizeable;
		}
		public function set resizeable(value:Boolean):void
		{
			this._resizeable = value;
		}
		/**
		 * Storage for the viewID property
		 * @private
		 */		
		private var _viewID:String;
		
		/**
		 * Return the valueof viewID 
		 * @return 
		 * 
		 */		
		public function get viewID():String
		{
			return this._viewID;
		}
		
		public function set viewID(value:String):void
		{
			if (value != null && value !="")
			{
				this._viewID = value;
			}
		}
		
		/**
		 * Indicates whether state property'value changed or not
		 * @private 
		 */	
		private var stateChanged:Boolean = false;
		
		private var _state:String;
		[Inspectable(enumeration="minimized, maximized", defaultValue="maximized")]
		public function get state():String
		{
			return this._state;
		}
		
		public function set state(value:String):void
		{
			if (value != this._state && value != null)
			{
				this._state = value;
				stateChanged = true;
				invalidateProperties();
			}
		}
		
		//	------------------------------	
		//	properties to be implemented
		//	------------------------------
		public var lastX:Number;
		public var lastY:Number;
		public var lastState:String;
		private var _innerCanvas:Canvas;
		
		private var dragManager:DragManager;
		/**
		 * Constructor 
		 * 
		 */		
		public function ViewBase()
		{
			super();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			
			addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationCompleteEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			event.stopPropagation();
			if (parent)
			{
				Container(parent).setChildIndex(this, parent.numChildren - 1);
			}
		}
		
		private var _isDragging:Boolean;
		private function handleMouseDownEvent(event:MouseEvent):void
		{
			this.startDrag();
			_isDragging = true;
		}
		
		private function handleMouseUpEvent(event:MouseEvent):void
		{
			this.stopDrag();
			_isDragging = false;
		}
		
		private function onMouseMoveHandler(event:MouseEvent):void
		{
 			if (!event.buttonDown) 
			{
				stopDrag();
				_isDragging = false;
			} 
		}
		
		private function handleCreationCompleteEvent(event:FlexEvent):void
		{
			configureListeners();
		}
		
		//	------------------------------	
		//	Children added to the viewBase
		//	------------------------------
		private var _titleText:Text;
		private var _iconImage:Image;
		private var _closeButton:Button;
		private var _resizedButton:Button;
		
		override protected function createChildren():void
		{
//			super.createChildren();
			createBorder();
			actualCreationPolicy = ContainerCreationPolicy.AUTO;
	        createComponentsFromDescriptors();	
	        
	        _innerCanvas = new Canvas();
	        _innerCanvas.percentWidth = 100;
	        _innerCanvas.percentHeight = 100;
	        _innerCanvas.styleName = this.styleName;
	        addChildAt(_innerCanvas, 0);
			
			if (title != "")
			{
				_titleText = new Text();
				_titleText.text = title;
				addChild(_titleText);
			}
			if (titleIcon)
			{
				_iconImage = new Image();
				if (titleIcon is Class)
				{
					_iconImage.source = new titleIcon();
				}
				if (titleIcon is String)
				{
					_iconImage.source = titleIcon;
				}
				_iconImage.x = 30;
				_iconImage.y = 6;
				_innerCanvas.addChild(_iconImage);
			}
			
			if (closeable)
			{
				_closeButton = new Button();
				_closeButton.includeInLayout = false;
				_closeButton.styleName = "closeBtn";
				_closeButton.setStyle("top", -12);
				_closeButton.setStyle("right", -12);
				addChild(_closeButton);
			}
			if (resizeable)
			{
				_resizedButton = new Button();
				_resizedButton.includeInLayout = false;
				_resizedButton.toggle = true;
				_resizedButton.styleName = "resizeBtn";
				_resizedButton.setStyle("top", -12);
				_resizedButton.setStyle("right",18);
				addChild(_resizedButton);
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		
		protected function configureListeners():void
		{
			if (draggable)
			{
				_innerCanvas.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDownEvent);
				_innerCanvas.addEventListener(MouseEvent.MOUSE_UP, 	handleMouseUpEvent);
			}
			if (closeable)
				_closeButton.addEventListener(MouseEvent.CLICK, handleCloseButtonClick);
			if (resizeable)
				_resizedButton.addEventListener(MouseEvent.CLICK, handleResizeButtonClick);
		}
		
		private function handleCloseButtonClick(event:MouseEvent):void
		{
//			TweenLite.to(this, 1, {width:320});
			ViewManager.getInstance().closeView(this.viewID);
//			dispatchEvent(new Event(ViewBase.EVENT_CLOSE_VIEW));
		}
		
		private function handleResizeButtonClick(event:MouseEvent):void
		{
			if (event.currentTarget.selected)
			{
				state = "minimized";
			}
			else
			{
				state = "maximized";
			}
//			var type:String = event.currentTarget.selected ? EVENT_MINIMIZE_VIEW : EVENT_MAXIMIZE_VIEW;
//			dispatchEvent(new Event(type));
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (titleChanged)
			{
				titleChanged = false;
				//to do
			}
			
			if (titleIconChanged)
			{
				titleIconChanged = false;
				//to do
			}
			
			if (stateChanged)
			{
				stateChanged = false;
				if (!_resizeable)
				return;			
				switch (_state)
				{
					case "minimized":
						_resizedButton.selected = true;
						dispatchEvent(new Event(EVENT_MINIMIZE_VIEW));
						break;
					case "maximized":
						_resizedButton.selected = false;
						dispatchEvent(new Event(EVENT_MAXIMIZE_VIEW));
						break;
					default:
						break;
				}
			}
			
		}
		
		public function dragStart():void
		{
			//to do 	
		}
		
		
	}
}