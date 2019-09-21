/*
The sprite that the user controls
*/

class Sprite {
  //Initialised to 0, 0
  PVector playerPosition = new PVector(0, 0);
  PImage spriteImage;
  boolean isJumping = false; //Used to tell if the player is in the air
  int timeOfFlight = 0; //Used to control how player moves when jumping
  int flightCutoff = 50; //Used to control when player should begin descending
  boolean ascent = false; // Used to tell the program if player is asceding or descending
  int vY = -5; //The default vertical velocity of the player. initalised as negative, to make the player move up
  
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
   //Converts the vector to an array, then gets the y value from the array
  return playerPosition.array()[1]; 
 }
 
 //Returns true if the player is mid jump
 public boolean isAirborne(){
   return isJumping;
 }
 
 //Makes the player jump
 public void jump() {
   //Sets the jump status to true
   isJumping = true;
 }
 
 //Moves the player up and down
 public void move() {
   //Checks to see if the flight cutoff has been reached
   if (timeOfFlight == flightCutoff) {
    //Inverses vY to make player fall
    vY *= -1;
   }
   
  //moving the player up/down based on their vY
  double currentY = getY();
  setY(currentY + vY);
  
  //Adding to the time of flight counter
  timeOfFlight++;
 }
 
 //Resets the flight timer
 public void resetFlightTime(){
  timeOfFlight = 0; 
 }
 
 
  
}
