/**
* Loads the frames into an Animation
* @param FramesCount Numbers of Frames to be loaded
* @param TileWidth Width of each individual Tile
* @param TileHeight Height of each individual Tile
*/
void LoadAnimationFrames(Animation animation, int FramesCount, int TileWidth, int TileHeight)
{
  int OffsetX = 0, OffsetY = 0;
  for(int i=0; i<FramesCount;i++)
  {
    if(OffsetX + TileWidth > animation.TextureAtlas.width)
    {
      OffsetX = 0;
      OffsetY += TileHeight + 1;
    }
    TextureCoordinates coords = new TextureCoordinates();
    coords.BottomLeft = new Vec2(OffsetX, OffsetY+TileHeight);
    coords.BottomRight = new Vec2(OffsetX+TileWidth, OffsetY+TileHeight);
    coords.TopRight = new Vec2(OffsetX+TileWidth, OffsetY);
    coords.TopLeft = new Vec2(OffsetX, OffsetY);
    animation.Frames.add(coords);

    OffsetX += TileWidth;
  }
}

//Loads the Ninja's idle animation from Disk
void LoadIdleNinjaAnimation(Animation animation)
{
  animation.TextureAtlas = AssetManager.RequestTexture("Assets/Ninja/IdleSpritesheet.png");
  //Texture presents artifacts so custom Loading is need it
  LoadAnimationFrames(animation, 5, 232, 439);
  
  for(int i=0; i < 5; i++)
  {
    TextureCoordinates coords = new TextureCoordinates();
    coords.BottomLeft = new Vec2(232, 878);
    coords.BottomRight = new Vec2(464, 878);
    coords.TopRight = new Vec2(464, 442);
    coords.TopLeft = new Vec2(232, 442);
    animation.Frames.add(coords);
  }
  
}

//Loads the Ninja's running animation from Disk
void LoadRunningNinjaAnimation(Animation animation)
{
  animation.TextureAtlas = AssetManager.RequestTexture("Assets/Ninja/RunSpritesheet.png");
  LoadAnimationFrames(animation, 10, 363, 458);
  animation.Rate = 0.15f;
}

//Loads the Ninja's jump animation from Disk
void LoadJumpNinjaAnimation(Animation animation)
{
  animation.TextureAtlas = AssetManager.RequestTexture("Assets/Ninja/JumpSpritesheet.png");
  LoadAnimationFrames(animation, 10, 362, 483);
  animation.Rate = 0.15f;
}

//Loads the Ninja's death animation from Disk
void LoadDeathNinjaAnimation(Animation animation)
{
  animation.TextureAtlas = AssetManager.RequestTexture("Assets/Ninja/DeathSpritesheet.png");
  LoadAnimationFrames(animation, 10, 482, 498);
  animation.Rate = 0.15f;
}

//Loads the Texture's coordinate of each Flower
ArrayList<TextureCoordinates> LoadFlowers()
{
  ArrayList<TextureCoordinates> flowers = new ArrayList<TextureCoordinates>();
  TextureCoordinates coords = new TextureCoordinates();
      
  coords.BottomLeft = new Vec2(577, 64);
  coords.BottomRight = new Vec2(640, 64);
  coords.TopRight = new Vec2(640, 0);
  coords.TopLeft = new Vec2(577, 0);
  flowers.add(coords);
      
  coords = new TextureCoordinates();
  coords.BottomLeft = new Vec2(640, 64);
  coords.BottomRight = new Vec2(704, 64);
  coords.TopRight = new Vec2(704, 0);
  coords.TopLeft = new Vec2(640, 0);
  flowers.add(coords);

  coords = new TextureCoordinates();
  coords.BottomLeft = new Vec2(704, 64);
  coords.BottomRight = new Vec2(768, 64);
  coords.TopRight = new Vec2(768, 0);
  coords.TopLeft = new Vec2(704, 0);
  flowers.add(coords);
      
  coords = new TextureCoordinates();
  coords.BottomLeft = new Vec2(577, 128);
  coords.BottomRight = new Vec2(640, 128);
  coords.TopRight = new Vec2(640, 65);
  coords.TopLeft = new Vec2(577, 65);
  flowers.add(coords);
      
  coords = new TextureCoordinates();
  coords.BottomLeft = new Vec2(640, 128);
  coords.BottomRight = new Vec2(704, 128);
  coords.TopRight = new Vec2(704, 65);
  coords.TopLeft = new Vec2(640, 65);
  flowers.add(coords);
      
  coords = new TextureCoordinates();
  coords.BottomLeft = new Vec2(704, 128);
  coords.BottomRight = new Vec2(768, 128);
  coords.TopRight = new Vec2(768, 65);
  coords.TopLeft = new Vec2(704, 65);
  flowers.add(coords);
  return flowers;
}

//Loads the Main scene
void LoadMainScene(ArrayList<GameObject> scene)
{
  scene.add(new Sky());
  scene.add(new Ground(new Vec2(-500.0f, -25.0f), new Vec2(15.0f, 16.0f)));
  scene.add(new Ground(new Vec2(-460.0f, -25.0f), new Vec2(20.0f, 16.0f)));
  scene.add(new Ground(new Vec2(-380.0f, -25.0f), new Vec2(20.0f, 16.0f)));
  scene.add(new Ground(new Vec2(-288.0f, -25.0f), new Vec2(20.0f, 16.0f)));
  scene.add(new Ground(new Vec2(-330.0f, -25.0f), new Vec2(20.0f, 16.0f)));
  scene.add(new Ground(new Vec2(-245.0f, -25.0f), new Vec2(20.0f, 20.0f)));
  scene.add(new Ground(new Vec2(-200.0f, -25.0f), new Vec2(20.0f, 16.0f)));
  
  scene.add(new Ground(new Vec2(-111.0f, -13.0f), new Vec2(20.0f, 20.0f)));
  scene.add(new Ground(new Vec2(-150.0f, -24.0f), new Vec2(20.0f, 16.0f)));
  scene.add(new Ground(new Vec2(-146.0f, 4.0f), new Vec2(5.0f, 6.0f)));
  scene.add(new Ground(new Vec2(-20.0f, -17.0f), new Vec2(20.0f, 16.0f)));
  
  scene.add(new SmallPlatform(new Vec2(-75.0f, 2.0f)));
  scene.add(new SmallPlatform(new Vec2(-56.0f, -2.0f)));
  
  scene.add(new GravityBoss(new Vec2(-420.0f, -20.0f), 20.0f));
  scene.add(new GravityBoss(new Vec2(-355.0f, -20.0f), 5.0f));
  scene.add(new GravityBoss(new Vec2(-266.5f, -20.0f), 1.0f));
  scene.add(new GravityBoss(new Vec2(-222.5f, -20.0f), 2.0f));
  scene.add(new GravityBoss(new Vec2(-65.5f, -20.0f), 20.0f));
  scene.add(new GravityBoss(new Vec2(21.0f, -20.0f), 20.0f));
  
  scene.add(new Spikes(new Vec2(-470.0f, -8.0f)));
  scene.add(new Spikes(new Vec2(-390.0f, -8.0f)));
  scene.add(new Spikes(new Vec2(-330.0f, -8.0f)));
  scene.add(new Spikes(new Vec2(-305.0f, -8.0f)));
  scene.add(new Spikes(new Vec2(-294.0f, -8.0f)));
  scene.add(new Spikes(new Vec2(-210.0f, -8.0f)));
  scene.add(new Spikes(new Vec2(-183.0f, -8.0f)));
  scene.add(new Spikes(new Vec2(-161.0f, -7.0f)));
  
  scene.add(new Spikes(new Vec2(-132.0f, -7.0f), 90.0f));
  scene.add(new Spikes(new Vec2(-132.0f, 2.0f), 90.0f));
  scene.add(new Spikes(new Vec2(-140.0f, 6.0f), -90.0f));
  
  scene.add(new Checkpoint(new Vec2(-370.0f, -8.0f)));
  scene.add(new Checkpoint(new Vec2(-278.0f, -8.0f)));
  
  scene.add(new HorizontalMovingPlatform(new Vec2(-430.0f, -413.0f)));
  
}
