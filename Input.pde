/**
* Static class that enable you to query if key or
*   a mouse button is being pressed or not at given time
*/
static class Input{
  
  /**
  * Container for all the key that are currently being pressed
  */
  static private ArrayList<Character> s_Keys = new ArrayList<Character>();
  
  /**
  * Container for all the mouse buttons that are currently being pressed
  */
  static private ArrayList<Integer> s_MouseButtons = new ArrayList<Integer>();

  /**
  * Queries if the given key is pressed or not
  * @param key The key that you are intrested for
  * @returns True if the given key is pressed, false otherwise
  */
  static public boolean IsKeyPressed(char keycode) { return s_Keys.contains(keycode); }
  
  /**
  * Queries if the given mouse button is pressed or not
  * @param code The code coresponding to the mouse button that you are intrested for
  * @returns True if the given mouse button is pressed, false otherwise
  */
  static public boolean IsMouseButtonPressed(int code) { return s_MouseButtons.contains(code); }
  
  /**
  * Registers a key as a one that is being pressed
  * @param key The key that will be registered
  */
  static public void KeyPressed(char keycode) { s_Keys.add(keycode); }
   
  /**
  * Unregisters a key that was being pressed
  * @param key The key that will be unregistered
  */
  static public void KeyReleased(char keycode)
  {
    int index = s_Keys.indexOf(keycode);
    if(index !=-1) s_Keys.remove(index);
  }
  
  /**
  * Registers a key as a one that is being pressed
  * @param key The key that will be registered
  */
  static public void MouseButtonPressed(int code) { s_MouseButtons.add(code); }
   
  /**
  * Unregisters a key that was being pressed
  * @param key The key that will be unregistered
  */
  static public void MouseButtonReleased(int code)
  {
    int index = s_MouseButtons.indexOf(code);
    if(index !=-1) s_MouseButtons.remove(index);
  }
  
}
