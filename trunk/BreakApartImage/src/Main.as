package 
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import com.foomonger.utils.Later;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import gs.easing.Quint;
	import gs.TweenMax;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
	
	/**
	 * ...
	 * @author Charlie Schulze, charlie[at]woveninteractive[dot]com
	 */
	
	public class Main extends BasicView 
	{
		protected var bulkInstance:BulkLoader;
		protected var imageMC:MovieClip;
		protected var imageString:String
		protected var planeVOs:Array = [];
		protected var planesContainer:DisplayObject3D;
		
		public function Main():void 
		{
			super();
			
			//Set the image we want to load
			imageString  = "images/queen.gif";
			
			//Load our image
			loadImage();
		}
		protected function loadImage():void 
		{
			//BulkLoader is complete overkill for this but thought it would be a 
			//nice extra for everyone to see in action. Extremely useful set of classes.
			
			//Create our unique bulkInstance / available anywhere in our app by 
			//that name "bulkImageLoader"
			bulkInstance = new BulkLoader("bulkImageLoader");
			
			//Add our image
			bulkInstance.add(imageString);
			
			//Add our listeners
			bulkInstance.addEventListener(BulkProgressEvent.COMPLETE, onImageLoaded);
			
			//Start Loading
			bulkInstance.start();
		}
		protected function onImageLoaded(evt:BulkProgressEvent):void 
		{
			init();
		}
		protected function init():void 
		{
			createChildren();
			explode();
			startRendering();
		}
		
		protected function createChildren():void 
		{
			//Create the clip we will be getting our bitmap data from
			imageMC = new MovieClip();
			
			//add our bitmap
			imageMC.addChild(bulkInstance.getBitmap(imageString));

			//Optional - Create a container to hold our planes
			planesContainer = new DisplayObject3D();
			
			//Array to store our value objects
			planeVOs = [];
			
			for (var i:int = 0; i < 65; i++)
			{
				/**
				 * Here is how we get our loop / colunm / cellWidth / cellHeight numbers
				 * 
				 * 5 columns * 13 rows = 65 (number of loops)
				 * 5 columns divided by the width (150) of our image = 30 pixels
				 * 13 rows  divided by the height (234) of our image = 18 pixels 
				 */

				var columns:uint 			= 5;
				var cellWidth:int 			= 30;
				var cellHeight:int 			= 18;
				var cellX:int 				= (i % columns)
				var cellY:int 				= Math.floor(i / columns);

				//Creates a 30 x 18 bitmapData block
				var bitmap_data:BitmapData	= new BitmapData(cellWidth, cellHeight, true, 0x00FFFF);
				
				//Create a new Matrix - A matrix is a rectangular array / table
				//of numbers with any number of rows / columns.
				var matrix:Matrix			= new Matrix();
				
				//Get's our desired x / y location information where we will 
				//pull a block of our image
				matrix.translate( -cellWidth * cellX, -cellHeight * cellY);
				
				//Write the data to our bitmap data object with our source and 
				//matrix / block info
				bitmap_data.draw(imageMC, matrix);
				
				//Create a bitmap with our bitmapData and add it to a movieclip
				var bitmap:Bitmap 			= new Bitmap(bitmap_data);
				var myMovie:MovieClip 		= new MovieClip();
				
				myMovie.addChild(bitmap);
				
				//Use the movieclip with our bitmap inside as our movieMaterial
				//needs to be cast as a DisplayObject to work
				var movieMat:MovieMaterial 	= new MovieMaterial(myMovie as DisplayObject, true);
				movieMat.smooth 			= true;
				
				//Create a plane with our moviemat the size of our cellWidth/Height
				var pl:Plane 				= new Plane(movieMat, cellWidth, cellHeight, 0, 0);
				
				//Create a value object to store our origianl infomation 
				//for when we animate we can then rebuild easily
				var planeVO:PlaneVO 		= new PlaneVO();

				//We want to place the planes to re-create our original image
				pl.x						= ((cellX * cellWidth) + cellWidth) -(imageMC.width / 2);
				pl.y 						= -((cellY * cellHeight) + cellHeight) +(imageMC.height / 2);
				
				//Set the original properties of our value object
				planeVO.origX 				= pl.x;
				planeVO.origY				= pl.y;
				planeVO.origZ 				= pl.z;
				planeVO.origRotationY		= pl.rotationY;
				planeVO.origRotationX		= pl.rotationX;
				planeVO.origRotationZ		= pl.rotationZ;
				planeVO.planeRef 			= pl;
				
				//Add our planeVO to our array
				planeVOs.push(planeVO)
				
				//Add planes to our container
				planesContainer.addChild(pl);				
			}
			
			//Add our container to our scene
			scene.addChild(planesContainer);
			
			camera.zoom = 100;
			
			//rotate our container for an skewed effect
			planesContainer.rotationY = 30;
			planesContainer.rotationX = 30;
		}
		
		protected function explode():void 
		{ 
			//Create a for loop of our plane objects set random numbers to explode our image
			
			for (var i:int = 0; i < planeVOs.length; i++)
			{
				var planeVO:PlaneVO 	= planeVOs[i];
				var plane:Plane 		= planeVO.planeRef;
				
				var ranNumber:Number = Math.round(Math.random() * 200 - 200);
				var delayAmount:Number = i * .05;
				var shortDelayAmount:Number = delayAmount * .6;
				
				var randomX:Number = (Math.random() * 4000) - 6000;
				var randomY:Number = (Math.random() * 8000) - 1000;
				var randomZ:Number = (Math.random() * 1000) + 5000;

				TweenMax.to(plane, 2, { x:planeVO.origX + randomX, delay:shortDelayAmount, 
										z:randomZ, y:150 + planeVO.origY + randomY, 
										rotationY:180,ease:Quint.easeInOut} );
			}
			
			//In 3 seconds rebuild
			Later.call(this, rebuild, 3000, true);
		}
		
		protected function rebuild():void 
		{
			//Rebuild our image with the locations we stored in our VO
			
			for (var i:int = 0; i < planeVOs.length; i++)
			{
				var planeVO:PlaneVO 	= planeVOs[i];
				var plane:Plane 		= planeVO.planeRef;
				var delayAmount:Number 	= i * .005;
				TweenMax.to(plane, 1.8, { x:planeVO.origX, delay:delayAmount, 
										z:planeVO.origZ, y:planeVO.origY, 
										rotationY:planeVO.origRotationY,ease:Quint.easeInOut} );
			}
			
			//In 5 seconds explode the image again
			Later.call(this, explode, 5000, true);
		}
	}
}