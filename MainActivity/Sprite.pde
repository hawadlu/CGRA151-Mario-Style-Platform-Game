/*
The sprite that the user controls
*/

class Sprite {
  //Player constants
  PImage playerImage;
  int playerHeight = 0;
  int playerWidth = 0;
  
  //Variables that control the movement of the player
  PVector playerPosition = new PVector(0, 0);
  boolean isJumping = false; //Used to tell if the player is in the air
  int timeOfFlight = 0; //Used to control how player moves when jumping
  int flightCutoff = 50; //Used to control when player should begin descending
  //boolean ascent = false; // Used to tell the program if player is asceding or descending
  int vY = -5; //The default vertical velocity of the player. initalised as negative, to make the player move up
  
  
 //The class initialiser
 public Sprite(int xPos, int yPos) {
   playerPosition.set(xPos, yPos);
 }
 
 /*
 METHODS THAT GET A VALUE
 */
  //Gets the y position of the player
 public double getY() {
   //Converts the vector to an array, then gets the y value from the array
  return playerPosition.array()[1]; 
 }
 
  //Gets the x position of the player
 public double getX() {
   //Converts the vector to an array, then gets the y value from the array
  return playerPosition.array()[0]; 
 }
 
 //Returns true if the player is mid jump
 public boolean isAirborne(){
   return isJumping;
 }
 
 //Returns the height of the player
 public int getHeight(){
  return playerHeight; 
 }
 
 //returns the width of the player
 public int getWidth() {
  return playerWidth; 
 }
 
 /*
 METHODS THAT SET A VALUE
 */
 
  //Resets the flight timer
 public void resetFlightTime(){
  timeOfFlight = 0; 
 }
 
  //Allows the y position of the sprite to be manually set
 public void setY(double yPos) {
   //Copies the x value from the orignal PVector. Copies to an array, then gets the value from the array
   float xOrignal = playerPosition.array()[0];
   
   //Updating the PVector
   playerPosition.set(xOrignal, (float)yPos);
 }
 
  //Takes an image path and turns it into a PImage
 public void setImage(String imagePath) {
   playerImage = loadImage(dataPath(imagePath));
   
   //Sets the image height and width variables
   playerHeight = playerImage.height;
   playerWidth = playerImage.width;
 }
 
 /*
 METHODS THAT CHECK PARAMETERS OR MAKE THE PLAYER DO SOMETHING
 */
 //Draws the sprite at the specified x, y coordinates
 public void drawSprite() {
   //Getting the values from the PVector
   float[] positionArr = playerPosition.array();
   
   //The image draws from the top left so, subtract the image height from the y value to draw correctly.
   image(playerImage, positionArr[0], positionArr[1] - playerHeight);
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
 
 //Stops the player from moving vertically. Resets the appropriate values
 void stopVertical() {
   println("Called stop");
   //resets the time of flight
   resetFlightTime();
   isJumping = false;
   println("Is jumping: " + isJumping);
   vY *= -1; //reset so that the player will jump correctly next time
 }
  
}
