import java.util.HashMap;
import processing.sound.*;

/**
* Static class used for loading assets. This class used as a "cache" system
*   so every assets should be loaded only one time from Disk. The filepath 
*   of it's asset is used as a key.
*/
static class AssetManager{

  /**
  * A Hash map used for holding each texture that has already be loaded from Disk
  */
  static private HashMap<String, PImage> s_Textures = new HashMap();
  
  /**
  * A Hash map used for holding each texture that has already be loaded from Disk
  */
  static private HashMap<String, SoundFile> s_Sounds = new HashMap();
  
  //The Proccessing's Application Context
  static private PApplet s_Context = null;
  
  /**
  * Setter for the Processing Application Context 
  * @param applet The application's context
  */
  static public void SetContext(PApplet applet) { s_Context = applet; }
  
  /**
  * Request a specific Texture.
  * @param filepath A string that describes the filepath of the Texture
  * @warnings If the texture is not already loaded. This function will block
  *   until it's loaded from Disk
  */
  static public PImage RequestTexture(String filepath)
  {
    if(s_Textures.containsKey(filepath))
      return s_Textures.get(filepath);
    else
    {
      PImage img = s_Context.loadImage(filepath);
      s_Textures.put(filepath, img);
      return img;
    }
  }
  
  /**
  * Request a specific Sound.
  * @param filepath A string that describes the filepath of the Sound
  * @warnings If the sound is not already loaded. This function will block
  *   until it's loaded from Disk
  */
  static public SoundFile RequestSound(String filepath) {
    if(s_Sounds.containsKey(filepath))
      return s_Sounds.get(filepath);
    else
    {
      SoundFile sound = new SoundFile(s_Context, filepath);  
      s_Sounds.put(filepath, sound);
      return sound;
    }
  }
  
}
