//TODO. FIX BUG WHERE THE PLATERS CAN SHOOT OUT THEIR OWN PLATFORMS TO WIN PREMATURELY //<>//

int level = 1; //The users level
int levelDelay = 0; //stops new platforms spawning when leveling up
boolean levelingUp = false; //Used to control whayt is displayed when the user levels up
boolean hasLost = false; //Controlls when the player has lost
int loseScreenCount = 0; //Used to control when the lose screen is displayed

//Controlling platform parameters based on the users level
ArrayList<Double> speedValues = new ArrayList(); //The speed of the platoforms
ArrayList<Double> platformSeparation = new ArrayList(); //The distance between each platform
ArrayList<Double> platformWidths = new ArrayList(); //The widths of the platforms. Dependant on the level
ArrayList<Platform> platformsToRemove = new ArrayList(); //Stores platforms that need to be removed from teh set at the end of the draw loop

//Control the vertical separation of the platofmrs
float minYSpawn = 400; 
float maxYSpawn = 450;

ArrayList<Platform> platforms = new ArrayList<Platform>(); //hashset containing all of the platforms


int count = 0; //counts the number of iteration in the draw loop. Used to control when the user levels up
double spawnInterval = 0; //Counts the time until the next item should spwan

//Creating the player object
Sprite player = new Sprite(200, 200);
boolean onGround = false; //Tells when the player has hit the ground

//Arraylist to hold the obstacles and their spawn probabilities
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Float> obstacleProb = new ArrayList<Float>(); //Stored as float to make randomly generating easier
ArrayList<Obstacle> obstaclesToRemove = new ArrayList<Obstacle>(); //Stores the obstacles to be removed 

//Arraylist to hold the current projectiles
ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
ArrayList<Projectile> projectilesToRemove = new ArrayList<Projectile>(); //Stores the projectiles to be removed


//Setting up the canvas
void setup() {
  size(1000, 500); //Canvas size
  
  noStroke();

  //Calls a method to set up all the base values for the platforms, obstacles and projectiles
  setupBaseValues();
}

//Redrawing each frame
void draw() { 
    //Resetting the background
    background(0);

    //Checking if the splayer should be set to active
    if (platforms.size() > 0) {
      if (!levelingUp && count < 1000 && platforms.get(0).getX() < 200 && platforms.get(0).getX() > 0 && !player.getActive()) {
        player.setActive(true);
        player.setFrozen(false); //Player is allowed to move
        onGround = false; //Ground set to false

        //Sets the player x, y to that of the first platform
        player.setY(platforms.get(0).getY() - 50);
        player.setX(platforms.get(0).getX());
        println("Player active");
      }
    }

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
      println("Ran level up");
      levelDelay++;

      //Checks if the level up screen has displayed for long enough.
      if (levelDelay > 1000) {
        //Resets values so that the next level can proceede
        levelDelay = 0;
        levelingUp = false;
      }

      //Displaying the level up image at the correct time
      if (platforms.size() <= 1) {
        PImage lvlUpImg = loadImage("Images/Level Up/Level Up.png");
        image(lvlUpImg, 375, 20);

        //Stops the playerbeing displayed
        player.setActive(false);
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

    //If the sprite is currently on the ground call the reset method
    if (onGround) { 
      //Set the lost parameter to true.
      hasLost = true;
    }

    //Only runs if the player has not lost
    if (!hasLost) {

      //Only draws the sprite if it is currently active
      if (player.getActive() && !player.getFrozen()) {

        //Checks to see if the player is currently jumping
        //println("Player airborne: " + player.isAirborne());
        if (player.isAirborne()) {
          //Moving the player vertically
          player.move(); 

          //Looking for a collision and stopping the player if needed
          checkCollisionVertical();
        } else {
          //Making the player fall if there is nothing below
          //Looking for collisions with a platform
          Boolean onPlatform = checkCollisionVertical();

          if (!onPlatform) {
            //Making the player fall
            player.setY(player.getY() + 5);
          }


          //Looking to see if a key has been pressed
          if (keyPressed) {
            keyPressed();
          }
        }

        //looking for any horizontal collisions
        checkCollisionHorizontal();

        //Checking if the player has hit the ground or the side
        if (player.getY() > height || player.getX() < 0) {
          onGround = true;
          player.setActive(false);
        }


        //Drawing the player in the default position
        player.drawSprite();
      }

      //Drawing and moving the projectiles
      if (!projectiles.isEmpty()) {
        for (Projectile projectile : projectiles) {
          //Draws the projectile
          projectile.drawProjectile();

          //Moves the projectile
          projectile.moveProjectile();

          //Checking if the projectile sould be removed
          if (projectile.getX() > width) {
            projectilesToRemove.add(projectile);
          }
        }
      }

      //Checking for projectile hits
      checkProjectileHit();

      //Removing projectiles
      if (!projectilesToRemove.isEmpty()) {
        for (Projectile projectile : projectilesToRemove) {
          //Removing
          projectiles.remove(projectile);
        }
        //Clears the projectiles to remove
        projectilesToRemove.clear();
      }

      //Drawing and moving the obstacles
      if (!obstacles.isEmpty()) { //Only draws when there is something to draw
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
          platformsToRemove.add(p);
        }

        p.drawPlatform();
        p.movePlatform();
      }

      //Removing obstacles
      for (Obstacle ob : obstaclesToRemove) {
        obstacles.remove(ob);
      }

      //Clearigng the obstacles to remobe
      obstaclesToRemove.clear();

      //Removing platforms
      for (Platform p : platformsToRemove) {
        platforms.remove(p);
      }

      //Clearing the remove arraylist
      platformsToRemove.clear();
    } else {
      PImage loseImgBG = loadImage("Images/Lose/Lose BG.png");
      background(loseImgBG);

      //Auto restart
      reset();
    }
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
  if ((int)random(0, obstacleProb.get(level - 1)) < 5 && platforms.size() > 1) {
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
  if (key == CODED) {
    if (keyCode == UP && !player.isAirborne() && player.getActive()) {
      //Calls the method to make mario jump

      player.jump();
      //Checking if a projectile has been fired
    } else if (keyCode  == SHIFT && player.getActive()) {

      //Will only fire if a the distance between this projectile and the last one is acceptable. Or arraylist is empty
      if (projectiles.isEmpty() || projectiles.get(projectiles.size() - 1).getX() - player.getX() > 100) {
        println("Firing");

        //Creating a new object. Scaled to that fireball comes out exactly half way
        Projectile projectile = new Projectile(player.getX(), player.getY() - (player.getHeight() / 2) + 5);

        //Adding the image to the projectile
        projectile.setImage("Images/Projectile/Fireball.png");

        //Adding to the projectiles arraylist 
        projectiles.add(projectile);
      }
    }
  }
}

/*
  Checks if the player has collided with a platform in the platforms arraylist.
 Performs appropriate actions if this event occurs.
 */
boolean checkCollisionVertical() {
  //Getting the players parameters
  double playerX = player.getX();
  double playerY = player.getY();
  double playerWidth = player.getWidth();

  //Looking for the platform that is directly beneath the player.
  for (Platform platform : platforms) {
    //Checking if the player is with the x value of the platform.
    if ((playerX + playerWidth > platform.getX()) && (playerX < platform.getX() + platform.getWidth())) {
      //Checking if the player is at the y value of the platform +- 5 allows some buffer to make transitions smoother
      if (playerY < platform.getY() + 5 && playerY > platform.getY() - 5) {
        //Calls method to stop the player from moving vertically
        player.stopVertical();

        //Updtes the plyer y to match the platform y
        player.setY(platform.getY());

        return true;
      }
    }
  }

  //Looking for collisions with an obstacle
  //Looking for the platform that is directly beneath the player.
  for (Obstacle ob : obstacles) {
    //Checking if the player is with the x value of the platform.
    if ((playerX + playerWidth > ob.getX()) && (playerX < ob.getX() + ob.getWidth())) {
      //Checking if the player is at the y value of the platform +- 5 allows some buffer to make transitions smoother
      if (playerY < ob.getY() - ob.getHeight() + 5 && playerY > ob.getY() - ob.getHeight() - 5) {
        //Calls method to stop the player from moving vertically
        player.stopVertical();

        //Updtes the plyer y to match the platform y
        player.setY(ob.getY() - ob.getHeight());

        return true;
      }
      //Looking for collisions with an obstacale
    }
  }
  return false;
}


//Looks for horizontal collisions with a platform
public void checkCollisionHorizontal() {
  //Getting the players parameters
  double playerX = player.getX();
  double playerY = player.getY(); //the bottom y
  double playerHeight = player.getHeight();
  double playerWidth = player.getWidth();

  //Checking for collisions with a platform
  for (Platform platform : platforms) {
    //Checking if there are is platfrom directly in front of the player at the same x pos. +- 2 allows some buffer to make transitions smoother
    if (playerX + playerWidth > platform.getX() - 2 && playerX + playerWidth < platform.getX() + 2) {
      //checking if the player is below the platform
      double platformTopY = platform.getY();
      double platformBottomY = platformTopY + platform.getHeight();
      double playerTopY = playerY - playerHeight;

      //Looking for a platform diectly in front of the user at a smilar y. +- 2 alllows some buffer for smoother transitions
      if (playerY > platformTopY && playerTopY < platformBottomY) {

        //Makes the player move backwards
        double platformVelocity = platform.getVelocity();
        player.moveBack(platformVelocity);
      }
    }
  }

  //Checking for collisions with an obstacle
  for (Obstacle ob : obstacles) {
    //Checking if there are is obstacle directly in front of the player at the same x pos. +- 2 allows some buffer to make transitions smoother
    if (playerX + playerWidth > ob.getX() - 2 && playerX + playerWidth < ob.getX() + 2) {
      //checking if the player is below the platform
      double obTopY = ob.getY();
      double obBottomY = obTopY + ob.getHeight();
      double playerTopY = playerY - playerHeight;

      //Looking for a platform diectly in front of the user at a smilar y. +- 2 alllows some buffer for smoother transitions
      if (playerY > obTopY && playerTopY < obBottomY) {

        //Makes the player move backwards
        double obVelocity = ob.getVelocity();
        player.moveBack(obVelocity);
      }
    }
  }
}

//Checking to see if a projectile has hit an object. performs appropriate actions
public void checkProjectileHit() {
  //Loops through every projectile, obstacle and platform looking for a hit
  for (Projectile projectile : projectiles) {
    //Looking through the obstacles
    for (Obstacle ob : obstacles) {
      //Cheking if they are on the same y level
      if (projectile.getY() > ob.getY() - ob.getHeight() - 5 && projectile.getY() < ob.getY() + 5) {
        //Looking for a hit
        if (projectile.getX() + projectile.getWidth() > ob.getX() - 10 && projectile.getX() + projectile.getWidth() < ob.getX() + 10) {
          //Deleting the projectile
          projectilesToRemove.add(projectile);

          //Making the object take damage
          ob.takeDamage(); 

          //Deleting the obstacle if it has sustained enough damage
          if (ob.getDamage() == 0) {
            //Deleting the obstacle
            obstaclesToRemove.add(ob);
            delay(100);
          }
        }
      }
    }

    //Looking through the platforms
    for (Platform platform : platforms) {
      //Checking if they are on the same y level
      if (projectile.getY() > platform.getY() && projectile.getY() < platform.getY() + platform.getHeight()) {
        //Looking for a hit
        if (projectile.getX() + projectile.getWidth() > platform.getX() - 10 && projectile.getX() + projectile.getWidth() < platform.getX() + 10) {
          //Deleting the projectile
          projectilesToRemove.add(projectile);

          //Making the object take damage
          platform.takeDamage(); 

          //Deleting the obstacle if it has sustained enough damage
          if (platform.getDamage() == 0) {
            //Deleting the obstacle
            platformsToRemove.add(platform);
            delay(100);
          }
        }
      }
    }
  }
}

//Sets up the base values for the platforms, player, obstacles and projectiles
public void setupBaseValues() {
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
}

//Method that exists only to clear arrays
public void clearArrays() {
  platforms.clear();
  obstacles.clear();
  projectiles.clear();
  platformsToRemove.clear();
  obstaclesToRemove.clear();
  projectilesToRemove.clear();
}

//resets the game so that the user can play again
public void reset() {

  println("Resetting game");

  println("Lose count: " + loseScreenCount);

  loseScreenCount += 1;
  if (loseScreenCount == 100) {
    delay(100);
    //Resetting the variables
    hasLost = false;
    level = 1; //The users level
    levelDelay = 0; //stops new platforms spawning when leveling up
    levelingUp = false; //Used to control whayt is displayed when the user levels up
    onGround = false;
    count = 0;
    player.setActive(false);
    println("Variables reset");
    
    //Clearing the sets and arrays
    clearArrays(); 
    
    //Setting up the initial platform and player
    //Adds a platform, default set to level 0
  addPlatform(level);

  //Adding the image to the player sprite
  player.setImage("Images/Mario/Mario Edited.png");

  //Setting the sprites y value to that of the first platform
  player.setY(100); //Set to a position where the player will fall onto the next platform
  }
}
