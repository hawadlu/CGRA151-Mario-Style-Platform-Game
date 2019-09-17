//Imports
import java.util.HashSet;

//Variables used to control aspects of the game

//controlling the users level
int level = 1; //The users level
//int levelInterval = 120; //the amount of time before the next plaform spawns
int levelDelay = 0; //stops new platforms spawning when leveling up
boolean levelingUp = false;

//Controlling platform parameters based on the users level
ArrayList<Double> speedValues = new ArrayList(); //The speed of the platoforms
ArrayList<Double> platformSeparation = new ArrayList();
ArrayList<Double> platformWidths = new ArrayList();
double platformWidth = 300;
float minYSpawn = 400;
float maxYSpawn = 450;


HashSet<Platform> platforms = new HashSet<Platform>(); //hashset containing all of the platforms
int count = 0; //counts the number of iteration in the draw loop
double spawnInterval = 0; //Counts the time until the next item should spwan

//Setting up the canvas
void setup() {
  //Adding the platform sppeds
  for (double i = 1; i < 6; i++) {
    speedValues.add(i);
  }

  //Adding the platform separtation values
  for (double i = 120; i < 400; i += 80) {
    platformSeparation.add(i);
  }
  
  //Adding the platfrom widths
  for (double i = 300; i > 0; i -= 60) {
    platformWidths.add(i);
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
    spawnInterval += 1; //incrementing the spawn counter 

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
    println("Level: " + level);
    if (level != 1) {
      println("not equal");
      if (spawnInterval == 320 / level) {

        //delay(1000);
        addPlatform(level);
        spawnInterval = 0;
      }
    } else if (spawnInterval == 320) {

      //delay(1000);
      addPlatform(level);
      spawnInterval = 0;
    }
  }
  //println("count: " + count);

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

  //Removing platofrms from the setf
  for (Platform p : platformsToremove) {
    platforms.remove(p);
  }

  //Clearing the remove arraylist
  platformsToremove.clear();

  //delay(10);
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

  double pHeight = 20; //Does not need to checge with the level
  
  double platformWidth = platformWidths.get(level - 1);

  //Creating a new object
  Platform p = new Platform(topX, platformWidth, pHeight, speed);

  //Adding the object to the hashset
  platforms.add(p);
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
  count = 0;
  spawnInterval = 0;
}
