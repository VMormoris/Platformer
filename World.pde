import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

/**
* Static class that is used as a wrapper
*   over World object of Box2D
*/
static class PlatformerWorld{
  
  static private World s_World;
  
  static final float s_PhysicsRate = 1.0f/60.0f;
  static final int s_VelocityIterations = 6;
  static final int s_PositionIterations = 2;
  
  /**
  * Setup the World object
  * @param dispatcher CollisionListener for the Wolrd object
  */
  static public void Setup(CollisionDispatcher dispatcher)
  {
    s_World = new World(new Vec2(0.0f, -10.0f));
    s_World.setContactListener(dispatcher);
  }
  
  /**
  * Creates & registers and Rigidbody into Physics Engine's Wolrd
  * @param bd Body's definition object for the creation of the Rigidbody
  * @returns The newly created Rigidbody
  */
  static public Body CreateBody(BodyDef bd) { return s_World.createBody(bd); }

  /**
  * Moves Rigidbodies on the Wolrd accordings to Newton's law
  */
  static public void Step() { s_World.step(s_PhysicsRate, s_VelocityIterations, s_PositionIterations);}

}
