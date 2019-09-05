public class Platform {
  //Platform parameters
  int topX, topY, platformWidth, platformHeight, vy;
  
  //Draws the platform on the screen
  public void drawPlatform() {
    //For debugging
    //println("Drawing platform");
    
    fill(255, 255, 255);
    rect(topX, topY, platformWidth, platformHeight);
  }
  
  //returns the x value of the platform
  public int getX() {
    return topX;
  }
  
  //Sets the platform values
  public void setVals() {
    topX = width;
    topY = 200;
    platformWidth = 100;
    platformHeight = 20;
    vy = 1;
  }
  
  //Moves the platform across the screen
  public void movePlatform() {
    topX -= vy;
  }
}
