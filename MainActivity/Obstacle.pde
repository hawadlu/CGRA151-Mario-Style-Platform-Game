//TODO. IMPLEMENT DAMAGE LEVEL IMAGES AND MAKE PVECTOR

/*
The obstacles that the user must destroy
*/

public class Obstacle {
  //Constants
  PImage obImage;
  int obHeight = 0;
  int obWidth = 0;
  int damage = 3; //The amount of damage that an obsacle can take.
  
  //Variables that control the movement of the obstacle
  PVector obPosition = new PVector (0, 0);
  int vx = 0;
  
   //The class initialiser
 public Obstacle(int xPos, int yPos, int velocity) {
   obPosition.set(xPos, yPos);
   vx = velocity;
 }
 
   //Takes an image path and turns it into a PImage
 public void setImage(String imagePath) {
   obImage = loadImage(dataPath(imagePath));
   
   //Sets the image height and width variables
   obHeight = obImage.height;
   obWidth = obImage.width;
 }
 
  //Draws the obstacle at the specified x, y coordinates
 public void drawObstacle() {
   //Getting the values from the PVector
   float[] positionArr = obPosition.array();
   
   //The image draws from the top left so, subtract the image height from the y value to draw correctly.
   //println("Obstacle x: " + (positionArr[0] + vx));
   //println("Obstacle y: " + (positionArr[1] - obHeight));
   image(obImage, positionArr[0] + vx, positionArr[1] - obHeight);
 }
 
 //Updates the x position of the obstacle
  public void setX(double xPos) {
   //Copies the x value from the orignal PVector. Copies to an array, then gets the value from the array
   float yOrignal = obPosition.array()[1];
   
   //Updating the PVector
   obPosition.set((float) xPos, yOrignal);
 }
 
 //gets the damage that the obstacle has
 public int getDamage() {
  return damage; 
 }
 
 //makes the obstacle take 1 damage
 public void takeDamage() {
  damage -= 1; 
  
  //Updates the image accordingly
  if (getDamage() == 2) {
   setImage("Images/Obstacle/Brick Wall Edited One Damage.png"); 
  } else if (getDamage() == 1) {
    setImage("Images/Obstacle/Brick Wall Edited Two Damage.png"); 
  }
 }
 
 //Gets the x positon of the obstacle
 public double getX() {
   //Converts the vector to an array, then gets the y value from the array
  return obPosition.array()[0]; 
 }
 
   //Gets the y position of the player
 public double getY() {
   //Converts the vector to an array, then gets the y value from the array
  return obPosition.array()[1]; 
 }
 
 //Moves the obstacles accross the screen (x only)
 public void moveObstacle() {
   //Gets and sets the new position
   double newX = getX() - vx;
   setX(newX);
 }
 
 //returns the width of the obstacle
 public int getWidth() {
  return obWidth;
 }
 
  //returns the height of the obstacle
 public int getHeight() {
  return obHeight;
 }
 
  //Returns the velocity of the obstacle
  public double getVelocity() {
   return vx; 
  }
 
  
}
