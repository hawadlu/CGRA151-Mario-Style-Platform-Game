//Imports
import java.util.HashSet;

//Variables used to control aspects of the game

//controlling the users level
int level = 1; //The users level
int levelInterval = 150; //the amount of time before the next plaform spawns
int levelDelay = 0; //stops new platforms spawning when leveling up
boolean levelingUp = false;

double initialPlatformWidth = 100;

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

  //Only runs when not leveling up 
  if (!levelingUp) {
    count += 1; //incremting the loop counter

    //Checking if the user can level up
    if (count % 1500 == 0) {

      //Calling a method to level the user up
      levelUp();
      println("Level up!");
    }
  }

  //Checking if a new platform should be made
  if (levelingUp) {
    println("Ran level up");
    levelDelay++;
    if (levelDelay > 1000) {
      levelDelay = 0;
      levelingUp = false;
    }
  } else {
    if (count % levelInterval == 0) {
      //Calls a method to spawn a new platform 
      addPlatform(level);
    }
  }
  println("count: " + count);

  background(0);

  //An arraylist of platforms to be removed from the set
  ArrayList<Platform> platformsToremove = new ArrayList();

  //Moving the platforms
  for (Platform p : platforms) {

    //If the platform is off the screen remove it from the platform hashset
    if (p.isOutOfBounds()) {
      platformsToremove.add(p);
    }

    p.drawPlatform();
    p.movePlatform();
  }

  //Removing platofrms from the set
  for (Platform p : platformsToremove) {
    platforms.remove(p);
  }

  //Clearing the remove arraylist
  platformsToremove.clear();

  delay(10);
} 


//Places a new platform in the platform hashset
public void addPlatform(int level) {
  //Getting the appropriate platform speed based on the users level
  double speed = 0;
  try {
    speed = speedValues.get(level - 1);
  } 
  catch ( Exception e) { 
    println("You won!");
    delay(400000);
  }

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
  return (double) initialPlatformWidth;
}

//Calculates and returns are random value between two parameters
public double calculateRandom (float min, float max) {
  //Calculates the random val and returns it as a double
  return (double) random(min, max);
}

//Adjusts platform parameters so that the user can level up
//TODO, introduce a vel up screen
public void levelUp() {
  levelingUp = true;
  level ++;
  if (levelInterval > 0) {
    levelInterval -= 2;
  }

  //Adjusting the platform width
  initialPlatformWidth = initialPlatformWidth * 0.99;
}
