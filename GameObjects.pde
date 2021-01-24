/**
* Parent Class for all the GameObjects
*  that will be used during the game.
*/
class GameObject{
  
  public String TAG = "Default GameObject";
  
  protected Transform m_Transform = new Transform();
  protected Renderable m_Renderable = new Renderable();
  protected Body m_Body = null;
  protected Animation m_CurrentAnimation = null;
  
  /**
  * Method that is called every frame
  *  Update the animation properly
  *
  *  Here you can override this method move your body
  *    apply force or change their velocity.
  *
  * @param dt Time passed since the last frame
  * @warnings It's a good idea to called this method after you make your changes
  *    So the Animation and Transformation of the Object stays in sync.
  */
  public void Update(float dt)
  {
    
    if(m_CurrentAnimation != null)
    {
      m_CurrentAnimation.Accumulator += dt;
      if(m_CurrentAnimation.Accumulator>=m_CurrentAnimation.Rate)
      {
          m_CurrentAnimation.FrameIndex ++;
  
          m_CurrentAnimation.Accumulator -= m_CurrentAnimation.Rate;
      }
      m_Renderable.Texture = m_CurrentAnimation.TextureAtlas;
      m_Renderable.TextCoords = m_CurrentAnimation.Frames.get(m_CurrentAnimation.FrameIndex % m_CurrentAnimation.Frames.size());
    }
    
    if(m_Body != null)
      m_Transform.Position = new Vec3(m_Body.getPosition().x, m_Body.getPosition().y, m_Transform.Position.z);
  }
  
  /**
  * Method that is called for Rendering an GameObject
  */
  public void Draw()
  {
    //Normal Rendering
    push();
    
    translate(m_Transform.Position.x, m_Transform.Position.y);
    rotateZ(radians(m_Transform.Rotation));
    scale(m_Transform.Scale.x, m_Transform.Scale.y, 1.0f);
    beginShape();
    if(m_Renderable.Texture != null)
    {
      tint(m_Renderable.TintColor);
      texture(m_Renderable.Texture);
    }
    else
      fill(m_Renderable.TintColor);
    vertex(-1.0f, -1.0f, m_Renderable.TextCoords.BottomLeft.x, m_Renderable.TextCoords.BottomLeft.y);
    vertex(1.0f, -1.0f, m_Renderable.TextCoords.BottomRight.x, m_Renderable.TextCoords.BottomRight.y);
    vertex(1.0f, 1.0f, m_Renderable.TextCoords.TopRight.x, m_Renderable.TextCoords.TopRight.y);
    vertex(-1.0f, 1.0f, m_Renderable.TextCoords.TopLeft.x, m_Renderable.TextCoords.TopLeft.y);
    endShape(CLOSE);
    
    pop();
    
  }
  
  /**
  * Getter for Transform's position
  * @returns A Vec3 that represents the Local Position of the Object
  */
  public Vec3 GetPosition() { return m_Transform.Position; }
  
  /**
  * Callback function for Collision Start Event
  *  Override this function to achieve your desired behaviour
  *
  * @param other The other GameObject that this GameObject is colliding with
  */
  public void onCollisionStart(GameObject other) {}
  
}

/**
* Background Object that we hope it sells as a Sky :P
*/
class Sky extends GameObject{
  
  //Constructor
  public Sky()
  {
    m_Transform.Scale = new Vec2(1000.0f, 1000.0f);
    m_Renderable.TintColor = color(135, 206, 235, 255);
  }
  
}

/**
* Class for Representing a checkpoint
*  Checkpoint are used as character's spawn locations
*  after he dies.
*/
class Checkpoint extends GameObject{
  
  //Constructor
  public Checkpoint(Vec2 position)
  {
    TAG = "Checkpoint";
    
    m_Transform.Position = new Vec3(position.x, position.y, 0.0f);
    
    //SubTexture selection
    m_Renderable.Texture = AssetManager.RequestTexture("Assets/tilesheet_complete.png");
    m_Renderable.TextCoords.BottomLeft = new Vec2(577, 768);
    m_Renderable.TextCoords.BottomRight = new Vec2(640, 768);
    m_Renderable.TextCoords.TopRight = new Vec2(640, 705);
    m_Renderable.TextCoords.TopLeft = new Vec2(577, 705);
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(position.x, position.y - 2.0f);
    
    m_Body = PlatformerWorld.CreateBody(bd);
    
    PolygonShape shape = new PolygonShape();
    shape.setAsBox(1, 1);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = shape;
    fd.density = 1.0f;
    fd.friction = 0.0f;
    fd.restitution = 0.0f;
    fd.userData = this;
    m_Body.createFixture(fd);
  }
  
  /**
  * Used to change lever when Ninja collides with it
  */
  public void onCollisionStart(GameObject other)
  {
    if(other.TAG.compareTo("Ninja") == 0)
    {
      m_Renderable.TextCoords.BottomLeft = new Vec2(704, 704);
      m_Renderable.TextCoords.BottomRight = new Vec2(767, 704);
      m_Renderable.TextCoords.TopRight = new Vec2(767, 641);
      m_Renderable.TextCoords.TopLeft = new Vec2(704, 641);
    }
  }
  
  //Overrides default of Update
  public void Update(float dt) {}
  
}
