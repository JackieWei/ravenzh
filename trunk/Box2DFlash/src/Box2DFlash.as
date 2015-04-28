package {
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class Box2DFlash extends Sprite
	{
		private static const CONSTANT:Number = 10;
		
		private var world:b2World;
		private var body:b2Body;
		private var sprite:Sprite;
		
		public function Box2DFlash()
		{
			super();
			initWorld();
			initBody();
			initShape();
//			startSimulation();
//			addEventListener(Event.ENTER_FRAME, handleEnterFrameEvent);
		}
		
		private function initWorld():void
		{
			//define AABB
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-100.0, -100.0);
			worldAABB.upperBound.Set(100.0, 100.0);
			
			var gravity:b2Vec2 = new b2Vec2(10.0, 10.0);
			var doSleep:Boolean = true;
			
			//initialize world
			world = new b2World(worldAABB, gravity, doSleep);
		}
		
		private function initBody():void
		{
			//initialize body's definition
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(0.0 , 4.0);
			
			body = world.CreateBody(bodyDef);
		}
		
		private function initShape():void
		{
			initSprite();
			
			//initialize shape's definition
			var shapeDef:b2PolygonDef = new b2PolygonDef();
			shapeDef.SetAsBox(1.0, 1.0);
			shapeDef.density = 10.0;
			shapeDef.friction = 0.1;
			shapeDef.userData = sprite;
			
			body.CreateShape(shapeDef);
			body.SetMassFromShapes();
		}
		
		private function initSprite():void
		{
			sprite = new Sprite();	
			var graphics:Graphics = sprite.graphics;
			graphics.beginFill(0xFFFFFF, 1.0);
			graphics.drawRect(0, 0, 20, 20);
			graphics.endFill();
			addChild(sprite);
		}
		
		private function startSimulation():void
		{
			var time_step:Number = 1.0/ 60.0;
			var iteration_count:Number = 10;
			world.Step(time_step, iteration_count);
		}
		
		private function handleEnterFrameEvent(event:Event):void
		{
			startSimulation();
			
			var position:b2Vec2 = body.GetPosition();
			var angel:Number = body.GetAngle();
			trace([position.x, position.y, angel]);
			sprite.rotation = 0;
			var m:Matrix = sprite.transform.matrix;
			m.identity();
			m.tx = -sprite.width / 2 ;
			m.ty = -sprite.height / 2 ;
			m.rotate(angel * Math.PI/180);
			
			m.tx += position.x * CONSTANT;
			m.ty += position.y * CONSTANT;
			
			sprite.transform.matrix = m;
		}
		
	}
}
    
    