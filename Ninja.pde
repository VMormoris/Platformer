/**
* Enumaration for all available Animations States
*/
enum AnimationState {
  //No animation
  None,

  //Idle Animations
  IdleRight,
  IdleLeft,

  //Jump Animations
  JumpRight,
  JumpLeft,

  //RunAnimations
  RunLeft, 
  RunRight,

  //Death Animation
  DeathLeft,
  DeathRight,
}

/**
* The character of Game
*  this object is responsible for handle all the
*  necessary logic for our character in order to be able
*  to Move, Animate and interact with other Objects in our Game
*/
class Ninja extends GameObject{
  
  //Idle Animations
  private Animation m_IdleRightAnimation = new Animation();
  private Animation m_IdleLeftAnimation = null;
  //Running Animations
  private Animation m_RunningRightAnimation = new Animation();
  private Animation m_RunningLeftAnimation = null;
  
  //Jump Animation
  private Animation m_JumpRightAnimation = new Animation();
  private Animation m_JumpLeftAnimation = null;
  
  //Death Animation
  private Animation m_DeathRightAnimation = new Animation();
  private Animation m_DeathLeftAnimation = null;
  
  //Characters current animations State
  private AnimationState m_AnimationState = AnimationState.None;
  
  //Coordinates on the Wolrd of the last checkpoint the character touched
  private Vec2 m_Checkpoint = new Vec2(-500.0f, -7.0f);
  
  //The obstacle the character is currently colliding with
  private Body m_Obstacle = null;
  
  //Jump & Death trigger flags
  private boolean m_DeathTrigger = false;
  private boolean m_JumpTrigger = false;

  //Sound our Ninja makes upon death
  private SoundFile m_DeathSound = null;
  
  private float m_AirControl = 0.66f;

  //Constructor
  public Ninja()
  {
    TAG = "Ninja";
    m_Transform.Position.x = -500.0f;
    m_Transform.Position.y = -7.0f;
    m_Transform.Scale.y = 2.2f;
    
    
    //Animation Loading    
    LoadIdleNinjaAnimation(m_IdleRightAnimation);
    LoadRunningNinjaAnimation(m_RunningRightAnimation);
    LoadJumpNinjaAnimation(m_JumpRightAnimation);
    LoadDeathNinjaAnimation(m_DeathRightAnimation);
    m_JumpRightAnimation.Rate =  2.0f /10.0f;
    //Create Flip Animations
    m_IdleLeftAnimation = FlipHorizontally(m_IdleRightAnimation);
    m_RunningLeftAnimation = FlipHorizontally(m_RunningRightAnimation);
    m_JumpLeftAnimation = FlipHorizontally(m_JumpRightAnimation);
    m_DeathLeftAnimation = FlipHorizontally(m_DeathRightAnimation);
    
    //Setting up current Animation
    m_CurrentAnimation = m_IdleRightAnimation;
    
    //Physic's Body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.fixedRotation = true;
    bd.position.set(m_Transform.Position.x, m_Transform.Position.y);
    
    m_Body = PlatformerWorld.CreateBody(bd);
    
    //Physic's Collider
    PolygonShape shape = new PolygonShape();
    shape.setAsBox(m_Transform.Scale.x, m_Transform.Scale.y - 0.1f);
    FixtureDef fd = new FixtureDef();
    fd.shape = shape;
    fd.density = 1.0f;
    fd.friction = 1.0f;
    fd.restitution = 0.0f;
    fd.userData = this;
    
    m_Body.createFixture(fd);
    m_AnimationState = AnimationState.IdleRight;
    
    //Preload sounds
    m_DeathSound = AssetManager.RequestSound("Assets/ouch.wav");
    
  }
  
  // Updates Ninja's state every frame  
  public void Update(float dt) 
  {
    if (m_DeathTrigger)
    {
      m_DeathTrigger = false;
      if((m_AnimationState == AnimationState.RunRight) || (m_AnimationState == AnimationState.IdleRight) || (m_AnimationState == AnimationState.JumpRight))
      {
        if(m_AnimationState == AnimationState.RunRight)
          m_Body.setTransform(new Vec2(m_Body.getPosition().x + 1.0f, m_Body.getPosition().y), 0.0f);
        m_AnimationState = AnimationState.DeathRight;
        m_CurrentAnimation = m_DeathRightAnimation;
      }
      else if((m_AnimationState == AnimationState.RunLeft) || (m_AnimationState == AnimationState.IdleLeft) || (m_AnimationState == AnimationState.JumpLeft))
      {
        if(m_AnimationState == AnimationState.RunLeft)
          m_Body.setTransform(new Vec2(m_Body.getPosition().x - 1.0f, m_Body.getPosition().y), 0.0f);
        m_AnimationState = AnimationState.DeathLeft;
        m_CurrentAnimation = m_DeathLeftAnimation;
      }
      
      m_CurrentAnimation.Accumulator = 0.0f;
      m_CurrentAnimation.FrameIndex = 0;
      m_Transform.Scale.x = 2.0f;
      
      m_Obstacle.setActive(false);
    }
    
    if(isDying())
    {
      if(m_CurrentAnimation.FrameIndex >= 10)
      {
        m_Body.setTransform(m_Checkpoint, 0.0f);
        m_CurrentAnimation = m_IdleRightAnimation;
        m_CurrentAnimation.FrameIndex = 0;
        m_CurrentAnimation.Accumulator = 0.0f;
        m_AnimationState = AnimationState.IdleRight;
        m_Transform.Scale.x = 1.0f;
        m_Obstacle.setActive(true);
        m_Obstacle = null;
      }
      super.Update(dt);
      return;
    }
    
    if (m_JumpTrigger)
    {
      m_Body.setLinearVelocity(new Vec2(m_Body.getLinearVelocity().x, 10.0f));
      m_JumpTrigger = false;
      
      if ((m_AnimationState == AnimationState.IdleLeft) || (m_AnimationState == AnimationState.RunLeft))
      {
        m_CurrentAnimation = m_JumpLeftAnimation;
        m_AnimationState = AnimationState.JumpLeft;
      }
      else
      {
        m_CurrentAnimation = m_JumpRightAnimation;
        m_AnimationState = AnimationState.JumpRight;
      }
      m_CurrentAnimation.Accumulator = 0.0f;
      m_CurrentAnimation.FrameIndex = 0;
      m_Transform.Scale.x = 1.5f;
    }
    else
    {
      Vec2 vel = m_Body.getLinearVelocity();
      if(Input.IsKeyPressed('d'))
      {
        if(isJumping() && (m_AnimationState == AnimationState.JumpLeft))
        {
          m_CurrentAnimation = m_JumpRightAnimation;
          m_CurrentAnimation.Accumulator = m_JumpLeftAnimation.Accumulator;
          m_CurrentAnimation.FrameIndex = m_JumpLeftAnimation.FrameIndex;
          m_AnimationState = AnimationState.JumpRight;
        }
        else if(!isJumping() && (m_AnimationState != AnimationState.RunRight))
        {
          m_CurrentAnimation = m_RunningRightAnimation;
          m_CurrentAnimation.Accumulator = 0.0f;
          m_CurrentAnimation.FrameIndex = 0;
          m_AnimationState = AnimationState.RunRight;
          m_Transform.Scale.x=1.5f;
        }
        Vec2 newVel = new Vec2(12.0f, vel.y);
        if(isJumping())
          newVel.x = newVel.x * m_AirControl;
        newVel.x = Math.max(newVel.x, vel.x);
        m_Body.setLinearVelocity(newVel);
      }
      else if(Input.IsKeyPressed('a'))
      {
        if(isJumping() && (m_AnimationState == AnimationState.JumpRight))
        {
          m_CurrentAnimation = m_JumpLeftAnimation;
          m_CurrentAnimation.Accumulator = m_JumpRightAnimation.Accumulator;
          m_CurrentAnimation.FrameIndex = m_JumpRightAnimation.FrameIndex;
          m_AnimationState = AnimationState.JumpLeft;
        }
        else if(!isJumping() && (m_AnimationState != AnimationState.RunLeft))
        {
          m_CurrentAnimation = m_RunningLeftAnimation;
          m_CurrentAnimation.Accumulator = 0.0f;
          m_CurrentAnimation.FrameIndex = 0;
          m_AnimationState = AnimationState.RunLeft;
          m_Transform.Scale.x=1.5f;
        }
        Vec2 newVel = new Vec2(-12.0f, vel.y);
        if(isJumping())
          newVel.x = newVel.x * m_AirControl;
        newVel.x = Math.min(newVel.x, vel.x);
        m_Body.setLinearVelocity(newVel);
      }
      else if (isRunning())
      {
        if (m_AnimationState == AnimationState.RunLeft)
        {
           m_AnimationState = AnimationState.IdleLeft;
           m_CurrentAnimation = m_IdleLeftAnimation;
        } 
        else if (m_AnimationState == AnimationState.RunRight)
        {
           m_AnimationState = AnimationState.IdleRight;
           m_CurrentAnimation = m_IdleRightAnimation;
        }
        m_CurrentAnimation.Accumulator = 0.0f;
        m_CurrentAnimation.FrameIndex = 0;
        m_Transform.Scale.x = 1.0f;
      }
    }
    
    super.Update(dt);
  }

  public void onKeyDown(char keycode)
  {
    if(keycode == ' ' &&  !isJumping() && !isDying())
      m_JumpTrigger = true;
  }

  private Animation FlipHorizontally(Animation source)
  {
    Animation flipped = new Animation();
    flipped.TextureAtlas = source.TextureAtlas;
    flipped.Rate = source.Rate;
    
    for(int i=0;i<source.Frames.size();i++)//Flip Texture Coordinates Horizontally (aka Make Left Coords Right and Vice Versa)
    {
      final TextureCoordinates sourceFrame = source.Frames.get(i);
      TextureCoordinates coords = new TextureCoordinates();
      coords.BottomLeft= new Vec2(sourceFrame.BottomRight.x, sourceFrame.BottomRight.y);
      coords.BottomRight= new Vec2(sourceFrame.BottomLeft.x, sourceFrame.BottomLeft.y);
      coords.TopLeft= new Vec2(sourceFrame.TopRight.x, sourceFrame.TopRight.y);
      coords.TopRight= new Vec2(sourceFrame.TopLeft.x, sourceFrame.TopLeft.y);
      flipped.Frames.add(coords);    
    }
    return flipped;
  }
  
  //Handle Collision with each body accordingly
  public void onCollisionStart(GameObject other)
  {
    if (other.TAG.compareTo("GravityBoss") == 0 || other.TAG.compareTo("Spikes") == 0)
    {
      m_DeathTrigger = true;
      m_DeathSound.play();
      m_Obstacle = other.m_Body;
    }
    else if(other.TAG.compareTo("Checkpoint") == 0)
    {
      Vec3 pos = other.GetPosition();
      m_Checkpoint = new Vec2(pos.x, pos.y);
    }
    
    if(isJumping() && ( (other.TAG.compareTo("Ground") == 0) || (other.TAG.compareTo("HorizontalMovingPlatform") == 0 ) ))
    {
      if (m_Body.getLinearVelocity().x==0.0f) 
      {
        if (m_AnimationState == AnimationState.JumpLeft) 
        {
          m_CurrentAnimation = m_IdleLeftAnimation;
          m_AnimationState = AnimationState.IdleLeft;
        }
        else if (m_AnimationState == AnimationState.JumpRight) 
        {
          m_CurrentAnimation = m_IdleRightAnimation;
          m_AnimationState = AnimationState.IdleRight;
        }
        m_CurrentAnimation.Accumulator=0.0f;
        m_CurrentAnimation.FrameIndex=0;
        m_Transform.Scale.x=1.0f;
      }
      else
      {
        if (m_AnimationState == AnimationState.JumpLeft) 
        {
          m_CurrentAnimation = m_RunningLeftAnimation;
          m_AnimationState = AnimationState.RunLeft;
        }
        else if (m_AnimationState == AnimationState.JumpRight) 
        {
          m_CurrentAnimation = m_RunningRightAnimation;
          m_AnimationState = AnimationState.RunRight;
        }
        m_CurrentAnimation.Accumulator=0.0f;
        m_CurrentAnimation.FrameIndex=0;
        m_Transform.Scale.x=1.5f;
      }
    }
  }
 
  //Helper Functions
  private boolean isIdlying() { return m_AnimationState==AnimationState.IdleLeft || m_AnimationState==AnimationState.IdleRight; }
  private boolean isRunning() { return m_AnimationState==AnimationState.RunLeft || m_AnimationState==AnimationState.RunRight;}
  private boolean isJumping() { return m_AnimationState==AnimationState.JumpLeft || m_AnimationState==AnimationState.JumpRight; }
  private boolean isDying() { return m_AnimationState == AnimationState.DeathLeft || m_AnimationState == AnimationState.DeathRight; }

}
