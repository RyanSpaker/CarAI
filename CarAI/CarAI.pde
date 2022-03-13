//this is a template to add a NEAT ai to any game
//note //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace 
//this means that there is some information specific to the game to input here
PGraphics canvas;

int nextConnectionNo = 1000;
Population pop;
int speed = 500;
PImage img;
PImage background;
Wall walls;
boolean showBest = false;//true if only show the best of the previous generation
boolean runBest = false; //true if replaying the best ever game
boolean humanPlaying = false; //true if the user is playing

Player humanPlayer;

boolean runThroughSpecies = false;
int upToSpecies = 0;
Player speciesChamp;

boolean showBrain = false;

boolean showBestEachGen = false;
int upToGen = 0;
Player genPlayerTemp;
boolean showNothing = false;
PFont font;
float wChance = 0.8;
float cChance = 0.3;
float nChance = 0.1;
float mChance = 1.0;
int lives = 0;
int deathTime = 1000;

//--------------------------------------------------------------------------------------------------------------------------------------------------

void setup() {
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
  size(1200, 675);
  canvas = createGraphics(640, 480, JAVA2D);
  frameRate(speed);
  img = loadImage("car-sprite.png");
  background = loadImage("Untitled.png");
  pop = new Population(500, lives);
  humanPlayer = new Player(lives);
  walls = new Wall();
}
//--------------------------------------------------------------------------------------------------------------------------------------------------
void draw() {
  drawToScreen();
  if (showBestEachGen) {//show the best of each gen
    if (!genPlayerTemp.dead) {//if current gen player is not dead then update it

      genPlayerTemp.look(walls);
      genPlayerTemp.think();
      genPlayerTemp.update(walls, deathTime);
      genPlayerTemp.show(showNothing);
    } else {//if dead move on to the next generation
      upToGen ++;
      if (upToGen >= pop.genPlayers.size()) {//if at the end then return to the start and stop doing it
        upToGen= 0;
        showBestEachGen = false;
      } else {//if not at the end then get the next generation
        genPlayerTemp = pop.genPlayers.get(upToGen).cloneForReplay();
      }
    }
  } else
    if (runThroughSpecies ) {//show all the species 
      if (!speciesChamp.dead) {//if best player is not dead
        speciesChamp.look(walls);
        speciesChamp.think();
        speciesChamp.update(walls, deathTime);
        speciesChamp.show(showNothing);
      } else {//once dead
        upToSpecies++;
        if (upToSpecies >= pop.species.size()) { 
          runThroughSpecies = false;
        } else {
          speciesChamp = pop.species.get(upToSpecies).champ.cloneForReplay();
        }
      }
    } else {
      if (humanPlaying) {//if the user is controling the ship[
        if (!humanPlayer.dead) {//if the player isnt dead then move and show the player based on input
          humanPlayer.look(walls);
          humanPlayer.update(walls, deathTime);
          humanPlayer.show(showNothing);
        } else {//once done return to ai
          humanPlaying = false;
        }
      } else 
      if (runBest) {// if replaying the best ever game
        if (!pop.bestPlayer.dead) {//if best player is not dead
          pop.bestPlayer.look(walls);
          pop.bestPlayer.think();
          pop.bestPlayer.update(walls, deathTime);
          pop.bestPlayer.show(showNothing);
        } else {//once dead
          runBest = false;//stop replaying it
          pop.bestPlayer = pop.bestPlayer.cloneForReplay();//reset the best player so it can play again
        }
      } else {//if just evolving normally
        if (!pop.done()) {//if any players are alive then update them
          pop.updateAlive(walls, deathTime);
        } else {//all dead
          //genetic algorithm 
          pop.naturalSelection(walls, wChance, cChance, nChance, mChance, lives);
        }
      }
    }
}


//---------------------------------------------------------------------------------------------------------------------------------------------------------
//draws the display screen
void drawToScreen() {
  if (!showNothing) {
   //pretty stuff
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
    image(background, 0, 0);
    //walls.Display();
    drawBrain();
    writeInfo();
  }else{
    background(0, 0, 0);
    fill(200);
    textAlign(LEFT);
    textSize(30);
    text("Gen: " + (pop.gen +1), 10, 50);
    text("MaxMemory: " + (Runtime.getRuntime().maxMemory()/1000000f), 10, 100);
    text("AllocatedMemory: " + (Runtime.getRuntime().totalMemory()/1000000f), 10, 150);
    text("FreeMemory: " + (Runtime.getRuntime().freeMemory()/1000000f), 10, 200);
  }
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void drawBrain() {  //show the brain of whatever genome is currently showing
  int startX = 690;//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
  int startY = 365;
  int w = 500;
  int h = 300;
  if (runThroughSpecies) {
    speciesChamp.brain.drawGenome(startX,startY,w,h);
  } else if (runBest) {
    pop.bestPlayer.brain.drawGenome(startX,startY,w,h);
  } else if (humanPlaying) {
    showBrain = false;
  } else if (showBestEachGen) {
    genPlayerTemp.brain.drawGenome(startX,startY,w,h);
  } else {
    pop.pop.get(0).brain.drawGenome(startX,startY,w,h);
  }
}
void saveBest(){

}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//writes info about the current player
void writeInfo() {
  fill(200);
  textAlign(LEFT);
  textSize(30);
  if (showBestEachGen) {
    text("Score: " + genPlayerTemp.getScore(walls), 650, 50);//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
    text("Gen: " + (genPlayerTemp.gen +1), 1000, 50);
  } else
    if (runThroughSpecies) {
      text("Score: " + speciesChamp.getScore(walls), 650, 50);//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
      text("Species: " + (upToSpecies +1), 10, 50);
      text("Players in this Species: " + pop.species.get(upToSpecies).players.size(), 50, height/2 + 200);
    } else
      if (humanPlaying) {
        fill(255, 0, 0);
        text("Score: " + humanPlayer.getScore(walls), 650, 50);//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
        text("Lives: " + humanPlayer.lives, 350, 50);//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
        text("Rotation: " + humanPlayer.rotation, 500, 100);
      } else
        if (runBest) {
          text("Score: " + pop.bestPlayer.getScore(walls), 650, 50);//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
          text("Gen: " + pop.gen, 1150, 50);
        } else {
          if (showBest) {          
            text("Score: " + pop.pop.get(0).getScore(walls), 650, 50);//<<<<<<<<<<<<<<<<<<<<<replace
            text("Gen:" + pop.gen, 900, 50);
            text("Species: " + pop.species.size(), 50, height/2 + 300);
            text("Global Best Score: " + pop.bestScore, 50, height/2 + 200);
          }
          else{
            text("Gen:" + pop.gen, 900, 50);
          }
        }
}

//--------------------------------------------------------------------------------------------------------------------------------------------------
void keyReleased() {
  //once key released
  if (key == CODED) {
    if (keyCode == UP) {//stop boosting
      humanPlayer.boosting = false;
    }
    if (keyCode == LEFT) {// stop turning
       humanPlayer.turningleft = false;
    } 
    if (keyCode == RIGHT) {
      humanPlayer.turningright = false;
    }
    if (keyCode == DOWN) {
      humanPlayer.reverse = false;
    }
  }
}
void keyPressed() {
  switch(key) {
  case ' ':
    //toggle showBest
    showBest = !showBest;
    break;
  case '+'://speed up frame rate
    speed += 10;
    frameRate(speed);
    println(speed);
    break;
  case '-'://slow down frame rate
    if (speed > 10) {
      speed -= 10;
      frameRate(speed);
      println(speed);
    }
    break;
  case 'b'://run the best
    runBest = !runBest;
    break;
  case 's'://show species
    runThroughSpecies = !runThroughSpecies;
    upToSpecies = 0;
    speciesChamp = pop.species.get(upToSpecies).champ.cloneForReplay();
    break;
  case 'g'://show generations
    showBestEachGen = !showBestEachGen;
    upToGen = 0;
    genPlayerTemp = pop.genPlayers.get(upToGen).clone();
    break;
  case 'n'://show absolutely nothing in order to speed up computation
    showNothing = !showNothing;
    break;
  case 'p'://play
    humanPlaying = !humanPlaying;
    humanPlayer = new Player(lives);
    break; 
  case 'k'://save a nn
    saveBest();
    break;
  case '1':
    if (mChance < 0.95) mChance += 0.05;
    else mChance = 1;
    println(mChance);
    break;
  case '2':
    if (mChance > 0.05) mChance -= 0.05;
    else mChance = 0.0;
    println(mChance);
    break;
  case '3':
    if (nChance < 0.95) nChance += 0.05;
    else nChance = 1;
    println(nChance);
    break;
  case '4':
    if (nChance > 0.05) nChance -= 0.05;
    else nChance = 0.0;
    println(nChance);
    break;
  case '5':
    if (wChance < 0.95) wChance += 0.05;
    else wChance = 1;
    println(wChance);
    break;
  case '6':
    if (wChance > 0.05) wChance -= 0.05;
    else wChance = 0.0;
    println(wChance);
    break;
  case '7':
    if (cChance < 0.95) cChance += 0.05;
    else cChance = 1;
    println(cChance);
    break;
  case '8':
    if (cChance > 0.05) cChance -= 0.05;
    else cChance = 0.0;
    println(cChance);
    break;
  case 'z':
    lives++;
    println(lives);
    break;
  case 'x':
    if (lives > 0)lives--;
    println(lives);
    break;
  case 'c':
    deathTime += 100;
    println(deathTime);
    break;
  case 'v':
    if (deathTime > 100)deathTime-= 100;
    else deathTime = 100;
    println(deathTime);
    break;
  case CODED://any of the arrow keys
    switch(keyCode) {
    case UP://the only time up/ down / left is used is to control the player
      humanPlayer.boosting = true;
      break;
    case DOWN:
      humanPlayer.reverse = true;
      break;
    case LEFT:
      humanPlayer.turningleft = true;
      break;
    case RIGHT://right is used to move through the generations
      if (runThroughSpecies) {//if showing the species in the current generation then move on to the next species
        upToSpecies++;
        if (upToSpecies >= pop.species.size()) {
          runThroughSpecies = false;
        } else {
          speciesChamp = pop.species.get(upToSpecies).champ.cloneForReplay();
        }
      } else 
      if (showBestEachGen) {//if showing the best player each generation then move on to the next generation
        upToGen++;
        if (upToGen >= pop.genPlayers.size()) {//if reached the current generation then exit out of the showing generations mode
          showBestEachGen = false;
        } else {
          genPlayerTemp = pop.genPlayers.get(upToGen).cloneForReplay();
        }
      } else if (humanPlaying) {//if the user is playing then move player right

        humanPlayer.turningright = true;
      }
      break;
    }
    break;
  }
}
