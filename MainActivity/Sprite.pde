/*
The sprite that the user controls
*/

class Sprite {
  //Initialised to 0, 0
  PVector playerPosition = new PVector(0, 0);
  PImage spriteImage;
  
 //The class initialiser
 public Sprite(int xPos, int yPos) {
   playerPosition.set(xPos, yPos);
 }
 
 //Takes an image path and turns it into a PImage
 public void setImage(String imagePath) {
   spriteImage = loadImage(dataPath(imagePath));
 }
 
 //Draws the sprite at the specified x, y coordinates
 public void drawSprite() {
   //Getting the values from the PVector
   float[] positionArr = playerPosition.array();
   
   //The image draws from the top left so, subtract the image height from the y value to draw correctly.
   image(spriteImage, positionArr[0], positionArr[1] - 50);
 }
 
 //Allows the y position of the sprite to be manually set
 public void setY(double yPos) {
   //Copies the x value from the orignal PVector. Copies to an array, then gets the value from the array
   float xOrignal = playerPosition.array()[0];
   
   //Updating the PVector
   playerPosition.set(xOrignal, (float)yPos);
 }
 
 //Gets the y position of the player
 public double getY() {
  return playerPosition.array()[1]; 
 }
 
 
  
}
