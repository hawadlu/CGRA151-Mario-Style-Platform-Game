/*
The sprite that the user controls
*/

class Sprite {
  double y;
  double x = 100; //The x is initialised to a constanant value. 
  PImage spriteImage;
  
 //The class initialiser
 public Sprite(int yPos) {
   y = yPos;
 }
 
 //Takes an image path and turns it into a PImage
 public void setImage(String imagePath) {
   spriteImage = loadImage(dataPath(imagePath));
 }
 
 //Draws the sprite at the specified x, y coordinates
 public void drawSprite() {
   //The image draws from the top left so, subtract the image height from the y value to draw correctly.
   image(spriteImage, (float)x, (float)y - 50);
 }
 
 //Allows the y position of the sprite to be manually set
 public void setY(double yPos) {
   y = yPos;
 }
 
 //Gets the y position of the player
 public double getY() {
  return y; 
 }
 
 
  
}
