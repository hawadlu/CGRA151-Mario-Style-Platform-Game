/*
The sprite that the user controls
*/

class Sprite {
  int y;
  int x = 100; //The x is initialised to a constanant value. 
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
 public void drawSprite(int x, int y) {
   image(spriteImage, x, y);
 }
 
 
  
}
