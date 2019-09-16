//Imports
import java.util.HashSet;

//Variables used to control aspects of the game

//controlling the users level
int level = 1; //The users level
int levelInterval = 150; //the amount of time before the next plaform spawns

int initialPlatformWidth = 100;

//Controlling platform parameters based on the users level
ArrayList<Double> speedValues = new ArrayList();
float minYSpawn = 200;
float maxYSpawn = 250;


HashSet<Platform> platforms = new HashSet<Platform>(); //hashset containing all of the platforms
int count = 0; //counts the number of iteration in the draw loop

//Setting up the canvas
void setup() {
  //Adding the platform sppeds
  for (double i = 1; i < 6; i++) {
    speedValues.add(i);
  }
  
  size(1000, 500);
  
  //Adds a platform, default set to level 0
  addPlatform(level);
}

//Redrawing each frame
void draw() {
  count += 1; //incremting the loop counter
  
  //Checking if a new platform should be made
  if (count % levelInterval == 0) {
     //Calls a method to spawn a new platform 
     addPlatform(level);
  }
  println("count: " + count);
  
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
public void addPlatform(int level) {
  //Getting the appropriate platform speed based on the users level
  double speed = speedValues.get(level - 1);
  
  //The top left corner of the platform
  double topX = calculateRandom(minYSpawn, maxYSpawn);
  
  //The width of the platform
  double pWidth = calculatePlatformWidth(level);
  
  double pHeight = 20; //Does not need to checge with the level
  
  //Creating a new object
   Platform p = new Platform(topX, pWidth, pHeight, speed);
   
   //Adding the object to the hashset
   platforms.add(p);
}

//Calculates the platform width based on the level
public double calculatePlatformWidth (int level) {
  //calculating and returning the platform width
  return (double) initialPlatformWidth / level;
}

//Calculates and returns are random value between two parameters
public double calculateRandom (float min, float max) {
  //Calculates the random val and returns it as a double
  return (double) random(min, max);
}
