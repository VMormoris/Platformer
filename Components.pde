//This File Contains classes that are used as C++ structs (aka all their Fields are public)

/**
* Structure containing information about the position
*  and orientation of each object in the Scene
*/
class Transform{
  
  public Vec3 Position = new Vec3(0.0f, 0.0f, 0.0f);
  public Vec2 Scale = new Vec2(1.0f, 1.0f);
  public float Rotation = 0.0f;
  
  //Constructor(s)
  public Transform() {}
  public Transform(Vec3 position, Vec2 scale, float rotation)
  {
    Position = position;
    Scale = scale;
    Rotation = rotation;
  }
  
}

/**
* Because we are working with Spritesheets & Tilesheets
*  is very important to reference those individual Sprites and Tiles
*  thus this structure is used for the Coordinates of these Sprites and Tiles
*/
class TextureCoordinates{
  
  public Vec2 BottomLeft = new Vec2(0.0f, 0.0f);
  public Vec2 BottomRight = new Vec2(1.0f, 0.0f);
  public Vec2 TopRight = new Vec2(1.0f, 1.0f);
  public Vec2 TopLeft = new Vec2(0.0f, 1.0f);
 
  //For Debug
  public String toString()
  {
    return "[" + BottomLeft.x + ", " + BottomLeft.y + "] " +
      "[" + BottomRight.x + ", " + BottomRight.y + "] " +
      "[" + TopRight.x + ", " + TopRight.y + "] " +
      "[" + TopLeft.x + ", " + TopLeft.y + "]\n";
  }
  
}

/**
* Structure Containing all the necessary information
*   for rendering objects
*/
class Renderable{
  public color TintColor = color(255, 255, 255, 255);
  public PImage Texture = null;
  public TextureCoordinates TextCoords = new TextureCoordinates();
}

/**
* Structure Containing all the necessary information
*   for playing a 2D Animation
* @warings To use this structure all the Animation must be in image
*/
class Animation{
  public PImage TextureAtlas = null;
  public ArrayList<TextureCoordinates> Frames = new ArrayList<TextureCoordinates>();
  public float Rate = 0.2f;
  public float Accumulator = 0.0f;
  public int FrameIndex = 0;
}
