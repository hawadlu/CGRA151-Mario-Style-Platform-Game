/*
This class store all the current projectile projectilejects
*/

class Projectile {
  //projectile constants
  PImage projectileImage;
  int projectileHeight = 0;
  int projectileWidth = 0;
  
  //Variables that control the movement of the projectile
  PVector projectilePosition = new PVector(0, 0);
  int vx = 5; //Initalised as a constant because the projectile moves at a constant speed
  
  
 //The class initialiser
 public Projectile(double xPos, double yPos) {
   projectilePosition.set((float)xPos, (float)yPos);
 }
 
 /*
 METHODS THAT GET A VALUE
 */
   //Gets the y position of the player
 public double getY() {
   //Converts the vector to an array, then gets the y value from the array
  return projectilePosition.array()[1]; 
 }
 
  //Gets the x position of the player
 public double getX() {
   //Converts the vector to an array, then gets the y value from the array
  return projectilePosition.array()[0]; 
 }
 
  //returns the width of the projectile
 public int getWidth() {
  return projectileWidth;
 }
 
  //returns the height of the projectile
 public int getHeight() {
  return projectileHeight;
 }
 
 /*
 METHODS THAT SET A VALUE
 */
    //Takes an image path and turns it into a PImage
 public void setImage(String imagePath) {
   projectileImage = loadImage(dataPath(imagePath));
   
   //Sets the image height and width variables
   projectileHeight = projectileImage.height;
   projectileWidth = projectileImage.width;
 }
 
   //Allows the y position of the sprite to be manually set
 public void setY(double yPos) {
   //Copies the x value from the orignal PVector. Copies to an array, then gets the value from the array
   float xOrignal = projectilePosition.array()[0];
   
   //Updating the PVector
   projectilePosition.set(xOrignal, (float)yPos);
 }
 
 //Allows the x positoin of the sprite to be manually set
 public void setX(double xPos) {
   //Copies the x value from the orignal PVector. Copies to an array, then gets the value from the array
   float yOrignal = projectilePosition.array()[1];
   
   //Updating the PVector
   projectilePosition.set((float) xPos, yOrignal);
 }
 
 
 /*
 METHODS THAT PERFORM AN ACTION
 */
 
   //Draws the sprite at the specified x, y coordinates
 public void drawProjectile() {
   //Getting the values from the PVector
   float[] positionArr = projectilePosition.array();
   
   //The image draws from the top left so, subtract the image height from the y value to draw correctly.
   //println("projectilestacle x: " + (positionArr[0] + vx));
   //println("projectilestacle y: " + (positionArr[1] - projectileHeight));
   image(projectileImage, positionArr[0] + vx, positionArr[1] - projectileHeight);
 }
 
 //Moves the projectile
 public void moveProjectile() {
   setX(getX() + vx);
 }
}
