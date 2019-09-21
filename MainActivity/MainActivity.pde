int level = 1; //The users level
int levelDelay = 0; //stops new platforms spawning when leveling up
boolean levelingUp = false; //Used to control whayt is displayed when the user levels up

//Controlling platform parameters based on the users level
ArrayList<Double> speedValues = new ArrayList(); //The speed of the platoforms
ArrayList<Double> platformSeparation = new ArrayList(); //The distance between each platform
ArrayList<Double> platformWidths = new ArrayList(); //The widths of the platforms. Dependant on the level
ArrayList<Platform> platformsToremove = new ArrayList(); //Stores platforms that need to be removed from teh set at the end of the draw loop

//Control the vertical separation of the platofmrs
float minYSpawn = 400; 
float maxYSpawn = 450;

ArrayList<Platform> platforms = new ArrayList<Platform>(); //hashset containing all of the platforms


int count = 0; //counts the number of iteration in the draw loop. Used to control when the user levels up
double spawnInterval = 0; //Counts the time until the next item should spwan

//Creating the player object
Sprite player = new Sprite(200, 200);


//Setting up the canvas
void setup() {
  size(1000, 500); //Canvas size

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

  //Adds a platform, default set to level 0
  addPlatform(level);

  //Adding the image to the player sprite
  player.setImage("Images/Mario Edited.png");

  //Setting the sprites y value to that of the first platform
  player.setY(platforms.get(0).getY());
  println("Player y: " + player.getY());
  println("Platform y: " + platforms.get(0).getY());
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
      //println("Level up!");
    }
  }

  //Checking if a new platform should be made
  if (levelingUp) {
    //println("Ran level up");
    levelDelay++;

    //Checks if the level up screen has displayed for long enough.
    if (levelDelay > 1000) {
      //Resets values so that the next level can proceede
      levelDelay = 0;
      levelingUp = false;
    }

    //Spawning platforms
  } else {

    //Ignore lvl 1
    if (level != 1) {

      //Checks if new platforms should be added
      if (spawnInterval == 320 / level) {

        //add platforms and reset spawn interval
        addPlatform(level);
        spawnInterval = 0;
      }

      //Sawns a new platform every time spawnInterval = 320 for lvl 1
    } else if (spawnInterval == 320) {
      addPlatform(level);
      spawnInterval = 0;
    }
  }

  //Resetting the background
  background(0);

  //Checks to see if the player is currently jumping
  //println("Player airborne: " + player.isAirborne());
  if (player.isAirborne()) {
    //Moving the player vertically
     player.move(); 
     
     //Looking for collisions with a platform
    checkCollision();
  } else {
    //Looking to see if a key has been pressed
    keyPressed();
  }
  
  

  //Drawing the player in the default position
  player.drawSprite();

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
} 


//Places a new platform in the platform hashset
public void addPlatform(int level) {
  //Getting the appropriate platform speed based on the users level
  double speed = 0;

  //If the program has run out wof speed values the user has completed all levels and won the game
  try {
    speed = speedValues.get(level - 1);
  } 
  catch ( Exception e) { 
    println("You won!");
    delay(400000);
  }

  //Parameters used when spawning the platforms
  double topY = calculateRandom(minYSpawn, maxYSpawn); //The y coordinate of the top left corner of the platform
  double pHeight = 20; //Does not need to checge with the level
  double platformWidth = platformWidths.get(level - 1); //width of the platform

  //Creating a new object
  Platform p = new Platform(topY, platformWidth, pHeight, speed);

  //Adding the object to the hashset
  platforms.add(p);
}

//Calculates and returns are random value between two parameters
public double calculateRandom (float min, float max) {
  //Calculates the random val and returns it as a double
  return (double) random(min, max);
}

//Adjusts platform parameters so that the user can level up
//TODO, introduce a lvl up screen
public void levelUp() {
  levelingUp = true;
  level ++;
  count = 0;
  spawnInterval = 0;
}

//This method checks to see if a key has been pressed. Runs the appropriate action required
void keyPressed() {
  if (key == CODED) { 
    //Checking if the up arrow has been pressed 
    if (keyCode == UP) {
      //Calls the method to make mario jump
      player.jump();      
    }
  }
}
  
  /*
  Checks if the player has collided with a platform in the platforms arraylist.
  Performs appropriate actions if this event occurs.
  */
  void checkCollision() {
    //Getting the players x posistion
    double playerX = player.getX();
    double playerY = player.getY();
    double playerHeight = player.getHeight();
    double playerWidth = player.getWidth();
    
    //Looking for the platform that is directly beneath the player. breaks loop when found
    for (Platform platform: platforms) {
      //Checking if the player is with the x value of the platform.
      if ((playerX > platform.getX() - playerWidth) && (playerX < platform.getX() + platform.getWidth() + playerWidth)) {
       //println("Found platform");
        //Checking if the player is at the y value of the platform
        if (playerY - playerHeight == platform.getY()) {
           //Calls method to stop the player from moving vertically
           player.stopVertical();
        }
        
      } else {
       println("Could not find platform");
      }
    }
    
    
    
    
  }
