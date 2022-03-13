class Player {
  PVector pos;
  PVector posOld;
  PVector vel;
  PVector acc;
  int checkpoint;
  boolean turningright = false;
  boolean turningleft = false;
  boolean reverse = false;
  Line[] sight = new Line[11];
  boolean linecrossed = false;
  int imgw = 0;
  int controltimer;
  int timeturn = 0;
  int lives = 0;
  int livesoriginal = 0;
  int imgh = 0;
  Line Lfront, Lback, Lleft, Lright;
  float rotation;//the ships current rotation
  float rotationOld;
  float spin;//the amount the ship is to spin next update
  float maxSpeed = 7;//limit the players speed at 10
  float fitness;
  Genome brain;
  float[] vision = new float[11];//the input array fed into the neuralNet 
  float[] decision = new float[4]; //the out put of the NN 
  float unadjustedFitness;
  int lifespan = 0;//how long the player lived for fitness
  int bestScore =0;//stores the score achieved used for replay
  boolean dead = false;
  int score;
  int gen = 0;
  boolean boosting = false;
  boolean control = true;
  float lapOld = 0; // three of these are for determining when you get a lap
  float lapDistance = 0;
  boolean justEntered = false;
  float maxRot = 0.1;
  int maxSpinTime = 40;
  int moves = 0;
  boolean ranOutOfLives = false;
  int genomeInputs = 11;//8 directions, magnitude of velocity, and angle of velocity, and angle of car
  int genomeOutputs = 4;
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //constructor

  Player(int lifeCount) {
    livesoriginal = lifeCount;
    lives = lifeCount;
    pos = new PVector(85, 384);
    controltimer = 100;
    posOld = new PVector(pos.x, pos.y);
    vel = new PVector();
    acc = new PVector(); 
    rotation = 0;
    rotationOld = rotation;
    spin = 0;
    brain = new Genome(genomeInputs,genomeOutputs);
    int widtht = width/1920;
    int heightt = height/1080;
    if(widtht < 1) widtht = 1;
    if(heightt < 1) heightt = 1;
    imgw = widtht * 15;
    imgh = heightt * 30;
    Lfront = new Line((int)pos.x-imgw/2,(int)pos.y-imgh/2,(int)pos.x+imgw/2,(int)pos.y-imgh/2);
    Lback = new Line((int)pos.x-imgw/2,(int)pos.y+imgh/2,(int)pos.x+imgw/2,(int)pos.y+imgh/2);
    Lright = new Line((int)pos.x+imgw/2,(int)pos.y-imgh/2,(int)pos.x+imgw/2,(int)pos.y+imgh/2);
    Lleft = new Line((int)pos.x-imgw/2,(int)pos.y-imgh/2,(int)pos.x-imgw/2,(int)pos.y+imgh/2);
    PVector direction;
    for (int i = 0; i< 11; i++) {
      direction = PVector.fromAngle(rotation + i*(PI/8)+PI-1.125);
      direction.mult(1500);
      stroke(10);
      sight[i] = new Line((int)pos.x, (int)pos.y, (int)pos.x + (int)direction.x, (int)pos.y + (int)direction.y);
      //line(sight[i].a.x1, sight[i].a.y1, sight[i].b.x1, sight[i].b.y1);
    }
  }
  public PVector rotatePoint(PVector a, PVector center, float angle){
    float ccos = cos(angle);
    float ssin = sin(angle);
    float nx = (ccos * (a.x - center.x)) + (ssin * (a.y - center.y)) + center.x;
    float ny = (ccos * (a.y - center.y)) - (ssin * (a.x - center.x)) + center.y;
    return new PVector((int)nx, (int)ny);
  }
  public PVector rotatePoint(PVector a, PVector center, float angle, int n){
    float ccos = cos(angle);
    float ssin = sin(angle);
    float nx = (ccos * (a.x - center.x)) + (ssin * (a.y - center.y)) + center.x;
    float ny = (ccos * (a.y - center.y)) - (ssin * (a.x - center.x)) + center.y;
    return new PVector(nx, ny);
  }
  public PVector rotatePoint(float ax, float ay, float cx, float cy, float angle){
    float ccos = cos(angle);
    float ssin = sin(angle);
    float nx = (ccos * (ax - cx)) + (ssin * (ay - cy)) + cx;
    float ny = (ccos * (ay - cy)) - (ssin * (ax - cx)) + cy;
    return new PVector(nx, ny);
  }
  void updateSides(){
    Lfront = new Line((int)pos.x-imgw/2+3,(int)pos.y-imgh/2+3,(int)pos.x+imgw/2-3,(int)pos.y-imgh/2+3);
    Lback = new Line((int)pos.x-imgw/2+3,(int)pos.y+imgh/2-3,(int)pos.x+imgw/2-3,(int)pos.y+imgh/2-3);
    Lright = new Line((int)pos.x+imgw/2-3,(int)pos.y-imgh/2+3,(int)pos.x+imgw/2-3,(int)pos.y+imgh/2-3);
    Lleft = new Line((int)pos.x-imgw/2+3,(int)pos.y-imgh/2+3,(int)pos.x-imgw/2+3,(int)pos.y+imgh/2-3);
    PVector tempa = Lfront.a;
    PVector tempb = Lfront.b;
    tempa = rotatePoint(tempa, new PVector((int)pos.x, (int)pos.y), -1*rotation);
    tempb = rotatePoint(tempb, new PVector((int)pos.x, (int)pos.y), -1*rotation);
    Lfront = new Line(tempa, tempb);
    tempa = Lback.a;
    tempb = Lback.b;
    tempa = rotatePoint(tempa, new PVector((int)pos.x, (int)pos.y), -1*rotation);
    tempb = rotatePoint(tempb, new PVector((int)pos.x, (int)pos.y), -1*rotation);
    Lback = new Line(tempa, tempb);
    tempa = Lright.a;
    tempb = Lright.b;
    tempa = rotatePoint(tempa, new PVector((int)pos.x, (int)pos.y), -1*rotation);
    tempb = rotatePoint(tempb, new PVector((int)pos.x, (int)pos.y), -1*rotation);
    Lright = new Line(tempa, tempb);
    tempa = Lleft.a;
    tempb = Lleft.b;
    tempa = rotatePoint(tempa, new PVector((int)pos.x, (int)pos.y), -1*rotation);
    tempb = rotatePoint(tempb, new PVector((int)pos.x, (int)pos.y), -1*rotation);
    Lleft = new Line(tempa, tempb);
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void show(boolean shownot) {
    if (!dead) {
      if  (!shownot) {
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(rotation);
        img.resize(imgw, imgh);
        image(img, 0-imgw/2, 0-imgh/2);
        popMatrix();
        //fill(204, 102, 0);
        //ellipse(pos.x, pos.y, 4, 4);
      }
      PVector direction;
      for (int i = 0; i< 11; i++) {
        direction = PVector.fromAngle(rotation + i*(PI/8)-PI*1.125);
        direction.mult(1500);
        //stroke(10);
        sight[i] = new Line((int)pos.x, (int)pos.y, (int)pos.x + (int)direction.x, (int)pos.y + (int)direction.y);
        //line(sight[i].a.x1, sight[i].a.y1, sight[i].b.x1, sight[i].b.y1);
      }
      //comment out later:
      //Lfront.Display();
     // Lback.Display();
      //Lleft.Display();
      //Lright.Display();
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void move() {
    if (!dead) {
      if (control) rotatePlayer();
      if (boosting && reverse){
      }else if (boosting) {//are thrusters on
        boost();
      }else if (reverse) {//are thrusters on
        goback();
      }
      vel.add(acc);//velocity += acceleration
      vel.limit(maxSpeed);
      vel.mult(0.97);
      posOld.set(pos.x, pos.y);
      pos.add(vel);//position += velocity
      acc.mult(0);
      PVector temp = vel.copy();
      PVector rotemp = PVector.fromAngle(rotation-1.5708);
      rotemp.setMag(vel.mag());
      vel = PVector.lerp(rotemp, temp, 0.99);
      if(controltimer > 50) {
        control = true;
      }else {
        controltimer ++;
      }
      //loopy();
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void update(Wall walls, int deathTime) {
    move();
    updateSides();
    moves ++;
    if (pos.x < 150 && pos.y > 200 && pos.y < 450) {
      if (justEntered){
        lapDistance = walls.lapDistance(this);
        lapOld = lapDistance;
        justEntered = false;
      }else {
        lapOld = lapDistance;
        lapDistance = walls.lapDistance(this);
        if(lapOld - lapDistance > 0.5) score ++;
        else if (lapOld - lapDistance < -0.5) score --;
      }
    }else {
      justEntered = true;
    }
    Line intersected = walls.checkCollisions(this);
    if(intersected.a.x == -1){}
    else if(lives>0){
      if(control)lives--;
      control = false;
      controltimer = 0;
      vel.mult(0);
      acc.mult(0);
      int closeLine = walls.closestLine(this);
      Line closest = walls.center.get(closeLine).clone();
      PVector closestPoint = walls.closestPoint(closest.a, closest.b, new PVector(pos.x, pos.y));
      pos.x = closestPoint.x;
      pos.y = closestPoint.y;
      PVector forward;
      if (Math.sqrt(Math.pow(Math.abs(closestPoint.x-closest.b.x), 2.0) + Math.pow(Math.abs(closestPoint.y-closest.b.y), 2.0)) < 10 && closeLine+2 <= walls.center.size())  forward = new PVector(closest.b.x-closestPoint.x, closest.b.y-closestPoint.y);
      else forward = new PVector(closest.b.x-closestPoint.x, closest.b.y-closestPoint.y);
      PVector normal = new PVector (0, -1);
      float ang = atan2(forward.y,forward.x) - atan2(normal.y,normal.x);
      rotation = ang;
    }else {
      dead = true;
      ranOutOfLives = true;
      lives --;
      //println("ran out of lives");
    }
    if (moves > deathTime){ dead = true;}
    if (moves > 100 && pos.x ==85 && pos.y == 384){dead = true;
    //println("didnt move");
    }
    //println (pos.x + "        " + pos.y);
  }
  //----------------------------------------------------------------------------------------------------------------------------------------------------------

  void look(Wall walls) {
    for(int i = 0; i < sight.length; i++){
      vision[i] = walls.getcollisions(sight[i]);
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //gets the output of the brain then converts them to actions
  void think() {

    float max = 0;
    //int maxIndex = 0;
    //get the output of the neural network
    decision = brain.feedForward(vision);

    for (int i = 0; i < decision.length; i++) {
      if (decision[i] > max) {
        max = decision[i];
        //maxIndex = i;
      }
    }
    /*
    if(decision[0] > 0.5 || decision[1] > 0.5 || decision[2] > 0.5 || decision[3] > 0.5)
    println("yes");
    else
    println("no");
    */
    if(decision[0] >= .8) boosting = true;
    else boosting = false;
    if(decision[1] >= .8) turningleft = true;
    else turningleft = false;
    if(decision[2] >= .8) turningright = true;
    else turningright = false;
    if(decision[3] >= .8) reverse = true;
    else reverse = false;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //returns a clone of this player with the same brian
  Player clone() {
    Player clone = new Player(livesoriginal);
    clone.brain = brain.clone();
    clone.fitness = fitness;
    clone.brain.generateNetwork(); 
    clone.gen = gen;
    clone.bestScore = score;
    return clone;
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//since there is some randomness in games sometimes when we want to replay the game we need to remove that randomness
//this fuction does that

  Player cloneForReplay() {
    Player clone = new Player(livesoriginal);
    clone.brain = brain.clone();
    clone.fitness = fitness;
    clone.brain.generateNetwork();
    clone.gen = gen;
    clone.bestScore = score;
    return clone;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //fot Genetic algorithm
  void calculateFitness() {
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<replace
    /*
    if (ranOutOfLives){
      fitness = (score + walls.lapDistance(this))/livesoriginal;
    }
    else {
      fitness = (score + walls.lapDistance(this));
    }
    */
    //if(lives<3)
    //fitness = ((float)(score + walls.lapDistance(this)))/ (((float)(livesoriginal-lives) + 1.0)/2.0);
    //else
    fitness = (score + walls.lapDistance(this));
    if (fitness < 0) fitness = 0;
  }
  void setLives(int lifes) {
    lives = lifes;
    livesoriginal = lifes;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  Player crossover(Player parent2) {
    Player child = new Player(livesoriginal);
    child.brain = brain.crossover(parent2.brain);
    child.brain.generateNetwork();
    return child;
  }
  void rotatePlayer() {
    rotationOld = rotation;
    if(turningleft && turningright){
      spin = 0;
    }else if (turningleft) {
      timeturn +=1;
      float spinadd = -1.0*maxRot * timeturn / maxSpinTime;
      if (spinadd < -1.0*maxRot) spinadd = -1.0*maxRot;
      spin += spinadd;
    }else if (turningright){
      timeturn +=1;
      float spinadd = maxRot * timeturn / maxSpinTime;
      if (spinadd > maxRot) spinadd = maxRot;
      spin += spinadd;
    }else {
      timeturn = 0;
      spin = 0;
    }
    if (spin > maxRot) spin = maxRot;
    if (spin < -1.0*maxRot) spin = -1.0*maxRot;
    rotation += spin;
  }
  void boost() {
    if (control){
      acc = PVector.fromAngle(rotation-1.5708); 
      acc.setMag(0.2);
    }
  }
  void goback() {
    if (control){
      acc = PVector.fromAngle(rotation-1.5708-(float)Math.PI); 
      acc.setMag(0.25);
    }
  }
  void loopy() {
    if (pos.y < -1*imgh) {
      pos.y = height + imgh;
    } else
      if (pos.y > height + imgh) {
        pos.y = -1*imgh;
      }
    if (pos.x< -1*imgw) {
      pos.x = width +imgw;
    } else  if (pos.x > width + imgw) {
      pos.x = -1*imgw;
    }
  }
  float getScore(Wall w){
    //if(lives<3)
    //return (float)(((float)score + walls.lapDistance(this)))/ (((float)(livesoriginal-lives) + 1.0)/2.0);
    //else
    return (float)(score + walls.lapDistance(this));
  }
}
