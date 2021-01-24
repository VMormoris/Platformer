/**
* Representation of an Orthographic Camera. The camera is build in a way,
*  that is able to simulate a Camera in GreenTea Engine (that was used for the Level Design)
*/
class Camera{
  
  /**
  * Half the size of Vertical space in meters
  */
  public float VerticalBoundary = 10.0f;
  
  /**
  * Object that the Camera is supposed to followe
  */
  private GameObject m_RelativeObj;
  
  //Constructor
  public Camera(GameObject relativeObj){ m_RelativeObj = relativeObj; }
  
  /**
  * Setup the Camera's projection
  * @warning This function must be called before you start drawing
  */
  public void Setup()
  {
    final float AspectRatio = (float) width / (float) height;
    final float HorizontalBoundary = AspectRatio * VerticalBoundary;
    
    //Move Everything so Center is 0.0, 0.0
    translate(width/2.0f, height/2.0f);//Translation Here is done in pixels
    //Setup Camera's projection Matrix
    //After setting the projection Matrix every translation becomes now on World units instead of pixels
    ortho(-HorizontalBoundary * 1.5f, HorizontalBoundary * 1.5f, VerticalBoundary * 1.5f, -VerticalBoundary * 1.5f);
    //Set Camera's position in World Space
    
    translate(-m_RelativeObj.GetPosition().x, -(m_RelativeObj.GetPosition().y + 7.085f));
  }
  
  
}
