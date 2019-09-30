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

//Arraylist to hold the obstacles and their spaen probabilities
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Float> obstacleProb = new ArrayList<Float>(); //Stored as float to make randomly generating easier
ArrayList<Obstacle> obstaclesToRemove = new ArrayList<Obstacle>(); //Stores the obstacles to be removed 


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

  //Adding the obstacle spawn probabilities. x5
  for (float i = 10; i > 1; i-= 2) {
    obstacleProb.add(i);
  }

  //Adds a platform, default set to level 0
  addPlatform(level);

  //Adding the image to the player sprite
  player.setImage("Images/Mario/Mario Edited.png");

  //Setting the sprites y value to that of the first platform
  player.setY(platforms.get(0).getY());
  println("Player y: " + player.getY());
  println("Platform y: " + platforms.get(0).getY());
}

//Redrawing each frame
void draw() { 

  //println("Draw jumping: " + player.isAirborne());

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
    checkCollisionVertical();
  } else {
    //Looking to see if a key has been pressed
    if (keyPressed) {
      keyPressed();
    }
  }

  //looking for any horizontal collisions
  checkCollisionHorizontal();


  //Drawing the player in the default position
  player.drawSprite();

  //Drawing and moving the obstacles
  if (!obstacles.isEmpty()) { //Only draws when there is something to draw
    println("Drawing obstacle");
    for (Obstacle ob : obstacles) {
      //First checking if the obstacle should be removed
      if (ob.getX() + ob.getWidth() < 0) {
       //Adds to the remove arraylist
       obstaclesToRemove.add(ob);
      } else {
        ob.drawObstacle();
        ob.moveObstacle();
      }
    }
  }

  //Moving the platforms
  for (Platform p : platforms) {

    //If the platform is off the screen remove it from the platform hashset
    if (p.isOutOfBounds()) {
      platformsToremove.add(p);
    }

    p.drawPlatform();
    p.movePlatform();
  }

  //Removing obstacles
  for (Obstacle ob: obstaclesToRemove) {
   obstacles.remove(ob); 
  }

  //Removing platforms
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

  //Randomly creating a new obstacle
  if ((int)random(0, obstacleProb.get(level - 1)) < 5) {
    println("NEW OBSTACLE");
    //Obstacle values. 70 is the width of the obstacles
    int xVal =  (int)random((float)p.getX(), (float)(p.getX() + p.getWidth() - 70));
    int yVal = (int) p.getY();
    int velocity = (int) p.getVelocity();

    //Creating the object
    Obstacle ob = new Obstacle(xVal, yVal, velocity);

    //Adding the image to the obstacle
    ob.setImage("Images/Obstacle/Brick Wall Edited.png");

    //Adding to the obstacles arraylist
    obstacles.add(ob);
  }
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
  if (key == CODED && keyCode == UP && !player.isAirborne()) {
    //Calls the method to make mario jump
    println("Jumping" + player.isAirborne());
    player.jump();
  }
}

/*
  Checks if the player has collided with a platform in the platforms arraylist.
 Performs appropriate actions if this event occurs.
 */
void checkCollisionVertical() {
  //Getting the players parameters
  double playerX = player.getX();
  double playerY = player.getY();
  double playerWidth = player.getWidth();

  //Looking for the platform that is directly beneath the player.
  for (Platform platform : platforms) {
    //Checking if the player is with the x value of the platform.
    //stroke(255, 255, 255);
    //line((float)(platform.getX() + platform.getWidth()), (float)0, (float)(platform.getX() + platform.getWidth()),  600);
    //stroke(255, 0, 0);
    //line((float)(playerX), (float)0, (float)(playerX),  600);
    //delay(1000);
    if ((playerX + playerWidth > platform.getX()) && (playerX < platform.getX() + platform.getWidth())) {
      //Checking if the player is at the y value of the platform +- 5 allows some buffer to make transitions smoother
      if (playerY < platform.getY() + 5 && playerY > platform.getY() - 5) {
        //Calls method to stop the player from moving vertically
        player.stopVertical();

        //Updtes the plyer y to match the platform y
        player.setY(platform.getY());
      }
      //Looking for collisions with an obstacale
    }
  }
  
  //Looking for collisions with an obstacle
  //Looking for the platform that is directly beneath the player.
  for (Obstacle ob : obstacles) {
    //Checking if the player is with the x value of the platform.
    stroke(255, 255, 255);
    line((float)(0), (float)playerY, (float)(1000),  (float)playerY);
    stroke(255, 0, 0);
    line((float)(0), (float)ob.getY() - ob.getHeight(), (float)(1000),  (float)ob.getY() - ob.getHeight());
    //delay(1000);
    if ((playerX + playerWidth > ob.getX()) && (playerX < ob.getX() + ob.getWidth())) {
      //Checking if the player is at the y value of the platform +- 5 allows some buffer to make transitions smoother
      if (playerY < ob.getY() - ob.getHeight() + 5 && playerY > ob.getY() - ob.getHeight() - 5) {
        //Calls method to stop the player from moving vertically
        player.stopVertical();

        //Updtes the plyer y to match the platform y
        player.setY(ob.getY() - ob.getHeight());
      }
      //Looking for collisions with an obstacale
    }
  }
}


//Looks for horizontal collisions with a platform
public void checkCollisionHorizontal() {
  //Getting the players parameters
  double playerX = player.getX();
  double playerY = player.getY(); //the bottom y
  double playerHeight = player.getHeight();
  double playerWidth = player.getWidth();
  for (Platform platform : platforms) {
    //Checking if there are is platfrom directly in front of the player at the same x pos. +- 2 allows some buffer to make transitions smoother
    if (playerX + playerWidth > platform.getX() - 2 && playerX + playerWidth < platform.getX() + 2) {
      //checking if the player is below the platform
      double platformTopY = platform.getY();
      double platformBottomY = platformTopY + platform.getHeight();
      double playerTopY = playerY - playerHeight;

      //Looking for a platform diectly in front of the user at a smilar y. +- 2 alllows some buffer for smoother transitions
      if (playerY > platformTopY && playerTopY < platformBottomY) {
        println("Player found");

        //stroke(255, 255, 255);
        //line((float)0, (float)player.getY(), (float)400, (float)player.getY()); //bottom
        //line((float) 0,(float) player.getY() - player.getHeight(), (float) 400,(float) player.getY() - player.getHeight()); //top

        //println("Platform top y: " + platformTopY);
        //println("Platform bottom y: " + platformBottomY);
        //println("Player bottom y: " + playerY);
        //println("Player top y: " + playerTopY + "\n");
        //delay(1000);

        //Makes the player move backwards
        double platformVelocity = platform.getVelocity();
        println("Platform velocity: " + platformVelocity);
        player.moveBack(platformVelocity);
      }
    }
  }
}
