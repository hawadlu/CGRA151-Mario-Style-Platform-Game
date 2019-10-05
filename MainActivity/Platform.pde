//TODO, CONVERT TO PVECTOR
/**
 The platforms that the user srtands on
 */


public class Platform {
  //Platform parameters
  double platformWidth, platformHeight, vx;
  int damage = 1; //The damage that a platform can take before it is destroyed
  PVector platformPosition = new PVector (0, 0); //Setup the position
  PImage platformImage = loadImage("Images/Platform/Cloud.png");


  //Initialises the platform
  public Platform(double topLeft, double pWidth, double pHeight, double pVx) {
    platformPosition.set(width, (int)topLeft);
    platformWidth = pWidth;
    platformHeight = pHeight;
    vx = pVx;
    
    //Stretching the image appropriately
    platformImage.resize((int)platformWidth, platformImage.height);
  }

  /*
  METHODS THAT GET A VALUE
   */

  //Gets the platform damage
  public int getDamage() {
    return damage;
  }

 //Gets the x positon of the platform
 public double getX() {
   //Converts the vector to an array, then gets the y value from the array
  return platformPosition.array()[0]; 
 }
 
   //Gets the y position of the platform
 public double getY() {
   //Converts the vector to an array, then gets the y value from the array
  return platformPosition.array()[1]; 
 }
 
 
  //Returns the width of the platform
  public double getWidth() {
    return platformWidth;
  }

  //Retuns the height of the platform
  public double getHeight() {
    return platformHeight;
  }

  //Returns the velocity of the platform
  public double getVelocity() {
    return vx;
  }


  /*
  METHODS THAT SET A VALUE
   */
   
   //Updates thr platform damage
   public void takeDamage() {
    damage -= 1; 
   }
   
     //Allows the y position of the platform to be manually set
 public void setY(double yPos) {
   //Copies the x value from the orignal PVector. Copies to an array, then gets the value from the array
   float xOrignal = platformPosition.array()[0];
   
   //Updating the PVector
   platformPosition.set(xOrignal, (float)yPos);
 }
 
 //Allows the x positoin of the sprite to be manually set
 public void setX(double xPos) {
   //Copies the x value from the orignal PVector. Copies to an array, then gets the value from the array
   float yOrignal = platformPosition.array()[1];
   
   //Updating the PVector
   platformPosition.set((float) xPos, yOrignal);
 }


  /*
  METHODS THAT CHECK PARAMETERS OR MAKE THE PLATFORM DO SOMETHING
   */


  //Draws the platform on the screen
  public void drawPlatform() {

    image(platformImage, (float) getX(), (float) getY());    
  }

  //Returns true if all of p is off the screen
  public boolean isOutOfBounds() {
    if (getX() < 0 - platformWidth) {
      return true;
    } else {
      return false;
    }
  }

  //Moves the platform across the screen
  public void movePlatform() {
    setX(getX() - vx);
  }
}
