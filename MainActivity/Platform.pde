public class Platform {
  //Platform parameters
  double xPosition = width, yPosition, platformWidth, platformHeight, vx;
  
  //Initialises the platoform
  public Platform(double topLeft, double pWidth, double pHeight, double pVx) {
    yPosition = topLeft;
    platformWidth = pWidth;
    platformHeight = pHeight;
    vx = pVx;
  }
  
  //Draws the platform on the screen
  public void drawPlatform() {
    //For debugging
    //println("Drawing platform");
    
    fill(255, 255, 255);
    rect((float) xPosition, (float) yPosition,(float) platformWidth,(float) platformHeight);
  }
  
  //Returns true if all of p is off the screen
  public boolean isOutOfBounds() {
     if (xPosition < 0 - platformWidth) {
      return true; 
     } else {
      return false; 
     }
       
  }
  
  //returns the x value of the platform
  public double getX() {
    return xPosition;
  }
  
  //returns the y value of the platform
  public double getY(){
   return yPosition; 
  }
  
  //Moves the platform across the screen
  public void movePlatform() {
    xPosition -= vx;
  }
}
