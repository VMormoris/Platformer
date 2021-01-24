/**
* Invisible obstacle for killing player when in falls
*  from a certain point and prevent him for falling forever
*/
class GravityBoss extends GameObject {
  //Constructor
  public GravityBoss(Vec2 position, float scaleX) {
     TAG = "GravityBoss";

     m_Renderable.TintColor = color(255, 255, 255, 0);
     
     BodyDef bd = new BodyDef();
     bd.type = BodyType.STATIC;
     bd.position.set(position);
     
     m_Body = PlatformerWorld.CreateBody(bd);
     
     PolygonShape shape = new PolygonShape();
     shape.setAsBox(scaleX, 1.0f);
     
     FixtureDef fd = new FixtureDef();
     fd.shape = shape;
     fd.density = 1.0;
     fd.friction = 20.0f;
     fd.restitution = 0.0f;
     fd.userData = this;
     m_Body.createFixture(fd);
   }  
}

//The basic Obstacle that Player should avoid during the game
class Spikes extends GameObject {
  
  public Spikes(Vec2 position)
  {
    this(position, 0.0f);
  }
  
  public Spikes(Vec2 position, float angle) 
  {
    m_Transform.Rotation = angle;
    TAG = "Spikes"; 
    
    m_Renderable.Texture = AssetManager.RequestTexture("Assets/tilesheet_complete.png");
    m_Renderable.TextCoords.BottomLeft = new Vec2(769, 639);
    m_Renderable.TextCoords.BottomRight = new Vec2(831, 639);
    m_Renderable.TextCoords.TopLeft = new Vec2(769, 577);
    m_Renderable.TextCoords.TopRight = new Vec2(831, 577);
    
    
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(position);
    bd.angle = radians(angle);
    
    m_Body = PlatformerWorld.CreateBody(bd); 
    
    PolygonShape shape = new PolygonShape();
    shape.setAsBox(0.7f, 0.5f);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = shape;
    fd.density = 1.0f;
    fd.friction = 20.0f;
    fd.restitution = 0.0f;
    fd.userData = this;
    m_Body.createFixture(fd);  
  }
  
}
  
