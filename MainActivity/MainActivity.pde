//Imports
import java.util.HashSet;

//Variables used to control aspects of the game
int level = 1; //The users level
HashSet<Platform> platforms = new HashSet<Platform>(); //hashset containing all of the platforms

//Setting up the canvas
void setup() {
  size(1000, 500);
  addPlatform();
}

//Redrawing each frame
void draw() {
  background(0);
  
  //Moving the platforms
  for (Platform p: platforms) {
    
    //If the platform is off the screen remove it from the platform hashset
    if (p.getX() < 0 - width) {
      println("removed from platform set"); //line for debugging
      platforms.remove(p);
    }
    
     p.drawPlatform();
     p.movePlatform();
  }
  delay(10);
}

//Places a new platform in the platform hashset
public void addPlatform() {
   Platform p = new Platform();
   p.setVals();
   platforms.add(p);
}
