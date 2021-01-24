Camera cam = null;

float start = 0.0f;

ArrayList<GameObject> mainScene = new ArrayList();
Ninja ninja = null;
SoundFile backgroundSound = null;
void settings() { size(1080, 720, P3D); }


void setup()
{ 
  AssetManager.SetContext(this);
  backgroundSound = AssetManager.RequestSound("Assets/awesomeness.wav");
  //AssetManager.RequestSound("Assets/ouch.wav"); 
  PlatformerWorld.Setup(new CollisionDispatcher());
  LoadMainScene(mainScene);
  
  ninja = new Ninja();
  cam = new Camera(ninja);
  mainScene.add(ninja);
  
  frameRate(60);
  rectMode(CENTER);
  noStroke();
  backgroundSound.loop();
}

void draw()
{
  float now = millis();
  float dt = 0.0f;
  if(start ==0.0f)
    start = now;
  else
    dt = (now - start) / 1000.f;

  PlatformerWorld.Step();
  for(GameObject obj: mainScene)
    obj.Update(dt);

  clear();
  cam.Setup();
  
  for(GameObject obj: mainScene)
    obj.Draw();

  
  start = now;  
}

void keyPressed()
{
  ninja.onKeyDown(key);
  Input.KeyPressed(key);
}

void keyReleased()
{
  Input.KeyReleased(key);
}
