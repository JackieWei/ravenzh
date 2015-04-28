/**
 * @author shanejohnson 
 * {@link http://www.ultravisual.co.uk}
 * created on 22 Jan 2009
 */
 
package  
{
    import caurina.transitions.*;
    
    import com.flashandmath.bitmaps.BitmapTransformer;
    
    import flash.display.*;
    import flash.events.*;
    import flash.filters.DropShadowFilter;
    import flash.geom.Point;
    
    [SWF(width='500', height='375', frameRate='30')]

    
    public class Genie extends MovieClip 
    {
        [Embed(source="logo_sml.jpg")]
        public var Lab:Class;


        private var spContainer:Sprite = new Sprite();
        private var imgWidth:Number = 500;
        private var imgHeight:Number=375;
        private var bdLab:Bitmap;
        private var bdTransform:BitmapTransformer;
        private var imgX:Number=0;
        private var imgY:Number=0;
        private var startPosX:Number = imgWidth;
        private var startPosY:Number = imgHeight;
        private var curV0:Point=new Point(imgX,imgY);
        private var curV1:Point=new Point(imgX+imgWidth,imgY);
        private var curV2:Point=new Point(imgX+imgWidth,imgY+imgHeight);
        private var curV3:Point=new Point(imgX,imgY+imgHeight);
        private var tween:Boolean = false;
        
        public function Genie()
        {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }
                
        private function init(e:Event):void 
        {                
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            curV0.x = startPosX;
            curV0.y = startPosY;
            curV1.x = startPosX;
            curV1.y = startPosY;
            curV2.x = startPosX;
            curV2.y = startPosY;
            curV3.x = startPosX;
            curV3.y = startPosY;
            this.addChild(spContainer);
            bdLab = new Lab();
            bdTransform = new BitmapTransformer(imgWidth,imgHeight,10,10);
            bdTransform.mapBitmapData(bdLab.bitmapData,curV0,curV1,curV2,curV3,spContainer);
            spContainer.filters = [ new DropShadowFilter(8,45,0x666666,1,4,4,1,1) ];
            stage.addEventListener(MouseEvent.CLICK, startTween);
        }
        public function startTween(e:MouseEvent):void
        {
            Tweener.addTween(curV0, {x: imgX, y: imgY, time: 1});
            Tweener.addTween(curV1, {x: imgX+startPosX, y: imgY, time: 1});
            Tweener.addTween(curV2, {x: imgX+startPosX, y: imgY+startPosY, delay: .5, time: .5});
            Tweener.addTween(curV3, {x: imgX, y: imgY+startPosY, delay: .5, time: 1, onComplete:removeEF});
            tween = true;    
            addEventListener(Event.ENTER_FRAME, mover);    
        }
        private function mover(e:Event):void 
        {            
            spContainer.graphics.clear();
            bdTransform.mapBitmapData(bdLab.bitmapData,curV0,curV1,curV2,curV3,spContainer);            
        }
        private function removeEF():void {    
            removeEventListener(Event.ENTER_FRAME, mover);    
            if(tween){
                stage.addEventListener(MouseEvent.CLICK, returnMove);
                stage.removeEventListener(MouseEvent.CLICK, startTween);
            }
            else{
                stage.removeEventListener(MouseEvent.CLICK, returnMove);
                stage.addEventListener(MouseEvent.CLICK, startTween);
            }    
        }    
        public function returnMove(e:MouseEvent):void
        {
            Tweener.addTween(curV3, {x: startPosX, y: startPosY, time: 1});
            Tweener.addTween(curV2, {x: startPosX, y: startPosY, time: 1});
            Tweener.addTween(curV1, {x: startPosX, y: startPosY, delay: .5, time: .5});
            Tweener.addTween(curV0, {x: startPosX, y: startPosY, delay: .5, time: 1, onComplete:removeEF});    
            tween = false;
            addEventListener(Event.ENTER_FRAME, mover);
        }    
        
    }
}




