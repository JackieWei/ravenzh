package com
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;

	public class Box2DWorld extends Sprite
	{
		private var world:b2World;
		private var groundBody:b2Body;
		private var body:b2Body;
		
		
		public function Box2DWorld()
		{
			super();
			initWorld();
			initBody();
		}
		
		private function initWorld():void
		{
			//define the world's boundary
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-100.0, -100.0);
			worldAABB.upperBound.Set(100.0, 100.0);
			
			//define gravity and its side
			var gravity:b2Vec2= new b2Vec2(0.0, -10.0);
			
			//??????
			var doSleep:Boolean = true;
		
			//define the world
			world = new b2World(worldAABB, gravity, doSleep);
		}
		
		private function initBody():void
		{
			//define groundBodyDef
			var groundBodyDef:b2BodyDef = new b2BodyDef();
			groundBodyDef.position.Set(0.0, -10.0);
			
			//define groundBody
			groundBody = world.CreateBody(groundBodyDef);
			
			//define groundShapeDef
			var groundShapeDef:b2PolygonDef = new b2PolygonDef();
			groundShapeDef.SetAsBox(50.0, 10.0);
			
			//define groundShape
			var groundShape:b2Shape = groundBody.CreateShape(groundShapeDef);	
		}
		
		private function initDynamicBody():void
		{
			//define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(0.0, 4.0);
			body = world.CreateBody(bodyDef);
			
			var shapeDef:b2PolygonDef = new b2PolygonDef();
			shapeDef.SetAsBox(1.0, 1.0);
			shapeDef.density = 1.0;
			shapeDef.friction = 0.3;
			body.CreateShape(shapeDef);
			body.SetMassFromShapes();
		}
		
		private function simulate():void
		{
			var timeStep:Number = 1.0 / 60.0;
			
			var interation:Number = 10;
			for(var i:uint = 0; i < 60; i ++)
			{
				world.Step(timeStep, interation);
				var position:b2Vec2 = body.GetPosition();
				var angel:Number = body.GetAngle();
				trace([position.x, position.y, angel]);
			}
		}
		
		
	}
}