/*
The sprite that the user controls
*/

class sprite {
  int y;
  int x = 100; //The x is initialised to a constanant value. 
  PImage sprite;
  
 //The class initialiser
 public sprite(int yPos, String imagePath) {
   y = yPos;
   sprite = loadImage("imagePath");
 }
 
 public void drawSprite(int x, int y) {
   image(sprite, x, y);
 }
 
 
  
}
