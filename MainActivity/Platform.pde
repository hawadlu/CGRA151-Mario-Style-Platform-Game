public class Platform {
  //Platform parameters
  double topX = width, topY, platformWidth, platformHeight, vx;
  
  //Initialises the platoform
  public Platform(double topLeft, double pWidth, double pHeight, double pVx) {
    topY = topLeft;
    platformWidth = pWidth;
    platformHeight = pHeight;
    vx = pVx;
  }
  
  //Draws the platform on the screen
  public void drawPlatform() {
    //For debugging
    //println("Drawing platform");
    
    fill(255, 255, 255);
    rect((float) topX, (float) topY,(float) platformWidth,(float) platformHeight);
  }
  
  //Reutns true if all of p is off the screen
  public boolean isOutOfBounds() {
     if (topX < 0 - platformWidth) {
      return true; 
     } else {
      return false; 
     }
       
  }
  
  //returns the x value of the platform
  public double getX() {
    return topX;
  }
  
  //Moves the platform across the screen
  public void movePlatform() {
    topX -= vx;
  }
}
