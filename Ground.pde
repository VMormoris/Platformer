static ArrayList<TextureCoordinates> s_AllFlowers = null;

/**
* Class for representing a Flower
*  Flowers are spawns Randomly and choose
*  which flower is shown randomly as well
*/
class Flower extends GameObject{
  
  Flower(Vec2 position, float scaleX)
  {
    if(s_AllFlowers == null)
      s_AllFlowers = LoadFlowers();
    
    float randomOffset = (float)(Math.random()) * 2 * scaleX - scaleX;
    m_Transform.Position.x = position.x + randomOffset;
    m_Transform.Position.y = position.y - 0.1;
    m_Renderable.Texture = AssetManager.RequestTexture("Assets/tilesheet_complete.png");
    m_Renderable.TextCoords = s_AllFlowers.get((int) ((Math.random() * 6.0f)));
  }

}


//Downer Part of the Ground
class DownerPart extends GameObject{
  
  public DownerPart(Vec2 scale)
  {
    m_Transform.Position.y = -1.0f;
    m_Transform.Scale.x = scale.x;
    m_Transform.Scale.y = scale.y;
    
    m_Renderable.Texture = AssetManager.RequestTexture("Assets/tilesheet_complete.png");
    m_Renderable.TextCoords.BottomLeft = new Vec2(0, 63);
    m_Renderable.TextCoords.BottomRight = new Vec2(63, 63);
    m_Renderable.TextCoords.TopRight = new Vec2(63, 0);
    m_Renderable.TextCoords.TopLeft = new Vec2(0, 0);
  }
  
}

//Upper Part of the Ground
class UpperPart extends GameObject{

  public UpperPart(float positionY, float scaleX)
  {
    m_Transform.Position.y = positionY;
    m_Transform.Scale.x = scaleX;
    
    m_Renderable.Texture = AssetManager.RequestTexture("Assets/tilesheet_complete.png");
    m_Renderable.TextCoords.BottomLeft = new Vec2(128, 63);
    m_Renderable.TextCoords.BottomRight = new Vec2(192, 63);
    m_Renderable.TextCoords.TopRight = new Vec2(192, 0);
    m_Renderable.TextCoords.TopLeft = new Vec2(128, 0);
  }
  
}

//Left Corner of Ground
class LeftCorner extends GameObject{

  public LeftCorner(Vec2 position)
  {
    m_Transform.Position.x = position.x;
    m_Transform.Position.y = position.y;

    m_Renderable.Texture = AssetManager.RequestTexture("Assets/tilesheet_complete.png");
    m_Renderable.TextCoords.BottomLeft = new Vec2(65, 63);
    m_Renderable.TextCoords.BottomRight = new Vec2(128, 63);
    m_Renderable.TextCoords.TopRight = new Vec2(128, 0);
    m_Renderable.TextCoords.TopLeft = new Vec2(65, 0);
  }
  
}

//Right Corner of Ground
class RightCorner extends GameObject{

  public RightCorner(Vec2 position)
  {
    m_Transform.Position.x = position.x;
    m_Transform.Position.y = position.y;

    m_Renderable.Texture = AssetManager.RequestTexture("Assets/tilesheet_complete.png");
    m_Renderable.TextCoords.BottomLeft = new Vec2(192, 63);
    m_Renderable.TextCoords.BottomRight = new Vec2(255, 63);
    m_Renderable.TextCoords.TopRight = new Vec2(255, 0);
    m_Renderable.TextCoords.TopLeft = new Vec2(192, 0);
  }
  
}

/**
* Ground is used as the Basic Platform for our Game
*/
class Ground extends GameObject{

  
  private DownerPart m_DownerPart = null;
  private UpperPart m_UpperPart = null;
  private LeftCorner m_LeftCorner = null;
  private RightCorner m_RightCorner = null;
  
  private Body m_LeftSlider = null;
  private Body m_RightSlider = null;
  
  private ArrayList<Flower> m_Flowers = new ArrayList();
  
  //Constructor
  public Ground(Vec2 pos, Vec2 scale)
  {
    TAG = "Ground";
    m_Transform.Position = new Vec3(pos.x, pos.y, 0.0f);
    
    m_DownerPart = new DownerPart(new Vec2(scale.x, scale.y - 1.0f));
    m_UpperPart = new UpperPart(scale.y - 1.0f, scale.x - 2.0f);
    m_LeftCorner = new LeftCorner(new Vec2(-(scale.x -1.0f), scale.y - 1.0f));
    m_RightCorner = new RightCorner(new Vec2(scale.x - 1.0f, scale.y - 1.0f));
    
    //Physic's Body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(pos.x, pos.y);
    
    m_Body = PlatformerWorld.CreateBody(bd);
    
    //Physic's Collider
    PolygonShape shape = new PolygonShape();
    shape.setAsBox(scale.x, scale.y);
    FixtureDef fd = new FixtureDef();
    fd.shape = shape;
    fd.density = 1.0f;
    fd.friction = 20.0f;
    fd.restitution = 0.0f;
    fd.userData = this;
    m_Body.createFixture(fd);
    
    //Extra Physics for slidding on the sides
    bd.position.set(pos.x - (scale.x - 0.2f), pos.y);
    m_LeftSlider = PlatformerWorld.CreateBody(bd);
    bd.position.set(pos.x + (scale.x - 0.2f), pos.y);
    m_RightSlider = PlatformerWorld.CreateBody(bd);
    
    shape.setAsBox(0.2, scale.y - 0.1);
    fd.shape = shape;
    fd.friction = 0.0f;
    m_LeftSlider.createFixture(fd);
    m_RightSlider.createFixture(fd);
    
    int size = (int)(Math.random() * 2.0f) + 1;
    for(int i=0; i<size; i++)
    {
      Vec2 flowerPos = new Vec2(pos.x, pos.y + scale.y + 1.0f);
      m_Flowers.add(new Flower(flowerPos, scale.x));
    }
  }
  
  /**
  * Overrides Draw methods
  *  Thew Grounds has a lot of other objects
  *    that must be drawned and it nothing to draw itself
  */
  public void Draw()
  {
    push();
    translate(m_Transform.Position.x, m_Transform.Position.y, 0.0);
    
    //Downer Part
    m_DownerPart.Draw();
    
    //Upper Part
    m_UpperPart.Draw();
    
    //LeftCorner
    m_LeftCorner.Draw();
    
    //Right Corner
    m_RightCorner.Draw();
    
    pop();
    
    for(int i=0; i < m_Flowers.size(); i++)
    {
      m_Flowers.get(i).Draw();
    }
  }

}

/**
* A Horizontally moving Platfom
*/
class HorizontalMovingPlatform extends GameObject
{
  
  Vec2 m_Limits = new Vec2();
  private Body m_LeftSlider = null;
  private Body m_RightSlider = null;
  
  //Constructor
  HorizontalMovingPlatform(Vec2 limits)
  {
    TAG = "HorizontalMovingPlatform";
    m_Transform.Scale.x = 2.0f;
    
    //Texture
    m_Renderable.Texture = AssetManager.RequestTexture("Assets/tilesheet_complete.png");
    m_Renderable.TextCoords.BottomLeft = new Vec2(449, 191);
    m_Renderable.TextCoords.BottomRight = new Vec2(578, 191);
    m_Renderable.TextCoords.TopRight = new Vec2(578, 128);
    m_Renderable.TextCoords.TopLeft = new Vec2(449, 128);
    
    m_Limits = limits;
    m_Transform.Position.y = -9.9f;
    m_Transform.Position.x = limits.x + ((Math.abs(limits.y) - Math.abs(limits.x)) / 2.0f); 
    
    //Physic's Body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.KINEMATIC;
    bd.fixedRotation = true;
    bd.position.set(m_Transform.Position.x, m_Transform.Position.y);
    
    m_Body = PlatformerWorld.CreateBody(bd);
    
    //Physic's Collider
    PolygonShape shape = new PolygonShape();
    shape.setAsBox(2.0f, 1.0f);
    FixtureDef fd = new FixtureDef();
    fd.shape = shape;
    fd.density = 1.0f;
    fd.friction = 20.0f;
    fd.restitution = 0.0f;
    fd.userData = this;

    m_Body.createFixture(fd);

    
    //Extra Physics for slidding on the sides
    bd.position.set(m_Transform.Position.x-1.8, m_Transform.Position.y);
    m_LeftSlider = PlatformerWorld.CreateBody(bd);
    bd.position.set(m_Transform.Position.x+1.8, m_Transform.Position.y);
    m_RightSlider = PlatformerWorld.CreateBody(bd);
    
    shape.setAsBox(0.2, 0.9f);
    fd.shape = shape;
    fd.friction = 0.0f;
    m_LeftSlider.createFixture(fd);
    m_RightSlider.createFixture(fd);
  
  }
  
  //Moves the Platform back and forth
  public void Update(float dt)
  {
    Vec2 pos = m_Body.getPosition();
    if(pos.x <= m_Limits.x)
    {
      m_Body.setLinearVelocity(new Vec2(4.0f, 0.0f));
      m_LeftSlider.setLinearVelocity(new Vec2(4.0f, 0.0f));
      m_RightSlider.setLinearVelocity(new Vec2(4.0f, 0.0f));
    }
    else if(pos.x >= m_Limits.y)
    {
      m_Body.setLinearVelocity(new Vec2(-4.0f, 0.0f));
      m_LeftSlider.setLinearVelocity(new Vec2(-4.0f, 0.0f));
      m_RightSlider.setLinearVelocity(new Vec2(-4.0f, 0.0f));
    }
    super.Update(dt);
  }
}

class SmallPlatform extends GameObject{
  
  private Body m_LeftSlider = null;
  private Body m_RightSlider = null;
  
  
  //Constructor
  SmallPlatform(Vec2 pos)
  {
    TAG = "Ground";
    m_Transform.Scale.x = 2.0f;
    
    //Texture
    m_Renderable.Texture = AssetManager.RequestTexture("Assets/tilesheet_complete.png");
    m_Renderable.TextCoords.BottomLeft = new Vec2(449, 127);
    m_Renderable.TextCoords.BottomRight = new Vec2(578, 127);
    m_Renderable.TextCoords.TopRight = new Vec2(578, 64);
    m_Renderable.TextCoords.TopLeft = new Vec2(449, 64);
    
    m_Transform.Position.y = pos.y;
    m_Transform.Position.x = pos.x; 
    
    //Physic's Body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.KINEMATIC;
    bd.fixedRotation = true;
    bd.position.set(m_Transform.Position.x, m_Transform.Position.y);
    
    m_Body = PlatformerWorld.CreateBody(bd);
    
    //Physic's Collider
    PolygonShape shape = new PolygonShape();
    shape.setAsBox(2.0f, 1.0f);
    FixtureDef fd = new FixtureDef();
    fd.shape = shape;
    fd.density = 1.0f;
    fd.friction = 20.0f;
    fd.restitution = 0.0f;
    fd.userData = this;

    m_Body.createFixture(fd);

    
    //Extra Physics for slidding on the sides
    bd.position.set(m_Transform.Position.x-1.8, m_Transform.Position.y);
    m_LeftSlider = PlatformerWorld.CreateBody(bd);
    bd.position.set(m_Transform.Position.x+1.8, m_Transform.Position.y);
    m_RightSlider = PlatformerWorld.CreateBody(bd);
    
    shape.setAsBox(0.2, 0.9f);
    fd.shape = shape;
    fd.friction = 0.0f;
    m_LeftSlider.createFixture(fd);
    m_RightSlider.createFixture(fd);
  }
  
}
