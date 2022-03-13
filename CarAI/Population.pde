class Population {
  ArrayList<Player> pop = new ArrayList<Player>();
  Player bestPlayer;//the best ever player 
  float bestScore =-10;//the score of the best ever player
  //int species = 0;
  int gen;
  int bestScoreGen = 0;
  //int nextConnectionNumber;
  ArrayList<connectionHistory> innovationHistory = new ArrayList<connectionHistory>();
  ArrayList<Player> genPlayers = new ArrayList<Player>();
  ArrayList<Species> species = new ArrayList<Species>();

  boolean massExtinctionEvent = false;
  boolean newStage = false;

  //------------------------------------------------------------------------------------------------------------------------------------------
  //constructor
  Population(int size, int lives) {
    for (int i =0; i<size; i++) {
      pop.add(new Player(lives));
      pop.get(i).brain.generateNetwork();
      pop.get(i).brain.mutate(innovationHistory, 0.8, 0.3, 0.1);
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //update all the players which are alive
  void updateAlive(Wall walls, int timeDeath) {

    for (int i = 0; i< pop.size(); i++) {
      if (!pop.get(i).dead) {
        pop.get(i).look(walls);//get inputs for brain 
        pop.get(i).think();//use outputs from neural network
        pop.get(i).update(walls, timeDeath);//move the player according to the outputs from the neural network
        if (!showBest || i ==0) {
          pop.get(i).show(showNothing);
        }
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //returns true if all the players are dead      sad
  boolean done() {
    for (int i = 0; i< pop.size(); i++) {
      if (!pop.get(i).dead) {
        return false;
      }
    }
    return true;
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //sets the best player globally and for this gen
  void setBestPlayer() {
    Player tempBest =  species.get(0).players.get(0);
    tempBest.gen = gen;
    float temp = tempBest.getScore(walls);

    //if best this gen is better than the global best score then set the global best as the best this gen
    if (gen > 10){
      //println("hi");
    }
    if (temp > bestScore){
      genPlayers.add(tempBest.cloneForReplay());
      println();
      println("********************************");
      println("improved by:", (temp - bestScore));
      println("********************************");
      bestScore = temp;
      bestPlayer = tempBest.cloneForReplay();
      bestScoreGen = tempBest.gen;
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------
  //this function is called when all the players in the population are dead and a new generation needs to be made
  void naturalSelection (Wall walls, float wChance, float cChance, float nChance, float mChance, int lives) {
    speciate();//seperate the population into species 
    calculateFitness();//calculate the fitness of each player
    sortSpecies();//sort the species to be ranked in fitness order, best first
    if (massExtinctionEvent) { 
      massExtinction();
      massExtinctionEvent = false;
    }
    cullSpecies();//kill off the bottom half of each species
    setBestPlayer();//save the best player of this gen
    killStaleSpecies();//remove species which haven't improved in the last 15(ish) generations
    killBadSpecies();//kill species which are so bad that they cant reproduce
    println();
    println("generation", gen, "Number of mutations", innovationHistory.size(), "species: " + species.size(), "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");


    float averageSum = getAvgFitnessSum();
    ArrayList<Player> children = new ArrayList<Player>();//the next generation
    //println("Species:");    
    children.add(bestPlayer.cloneForReplay());
    println("best unadjusted fitness:", species.get(0).players.get(0).getScore(walls));
    println("# of Gens since last improvement:", gen-bestScoreGen);
    //println("1:" + species.size() + "   ooooooooooo");
    for (int j = 0; j < species.size(); j++) {//for each species
      //print("j:" + j + ": ");
      //for (int i = 0; i < species.get(j).players.size(); i++) {}
      //print("player " + i, "fitness: " +  species.get(j).players.get(i).fitness, "score " + species.get(j).players.get(i).getScore(walls));
      children.add(species.get(j).champ.cloneForReplay());//add champion without any mutation

      int NoOfChildren = floor(species.get(j).averageFitness/averageSum * (pop.size()-1)) -1;//the number of children this species is allowed, note -1 is because the champ is already added
      //print("NOC: " + NoOfChildren + ", ");
      for (int i = 0; i< NoOfChildren; i++) {//get the calculated amount of children from this species
        //print("i:" + i + ", ");
        children.add(species.get(j).giveMeBaby(innovationHistory, wChance, cChance, nChance, mChance));
      }
    }
    //println("hey");
    while (children.size() < pop.size()) {//if not enough babies (due to flooring the number of children to get a whole int) 
      children.add(species.get(0).giveMeBaby(innovationHistory, wChance, cChance, nChance, mChance));//get babies from the best species
    }
    //println("hi");
    pop.clear(); b
    pop = (ArrayList)children.clone(); //set the children as the current population
    gen+=1;
    for (int i = 0; i< pop.size(); i++) {//generate networks for each of the children
      pop.get(i).brain.generateNetwork();
      pop.get(i).setLives(lives);
    }
    //println("h0");

  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //seperate population into species based on how similar they are to the leaders of each species in the previous gen
  void speciate() {
    for (Species s : species) {//empty species
      s.players.clear();
    }
    for (int i = 0; i< pop.size(); i++) {//for each player
      boolean speciesFound = false;
      for (Species s : species) {//for each species
        if (s.sameSpecies(pop.get(i).brain)) {//if the player is similar enough to be considered in the same species
          s.addToSpecies(pop.get(i));//add it to the species
          speciesFound = true;
          break;
        }
      }
      if (!speciesFound) {//if no species was similar enough then add a new species with this as its champion
        species.add(new Species(pop.get(i)));
      }
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //calculates the fitness of all of the players 
  void calculateFitness() {
    for (int i =1; i<pop.size(); i++) {
      pop.get(i).calculateFitness();
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //sorts the players within a species and the species by their fitnesses
  void sortSpecies() {
    //sort the players within a species
    for (Species s : species) {
      s.sortSpecies();
    }

    //sort the species by the fitness of its best player
    //using selection sort like a loser
    ArrayList<Species> temp = new ArrayList<Species>();
    for (int i = 0; i < species.size(); i ++) {
      float max = -1000;
      int maxIndex = -1000;
      for (int j = 0; j< species.size(); j++) {
        if (species.get(j).bestFitness > max) {
          max = species.get(j).bestFitness;
          maxIndex = j;
        }
      }
      temp.add(species.get(maxIndex));
      species.remove(maxIndex);
      i--;
    }
    species = (ArrayList)temp.clone();
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //kills all species which haven't improved in 15 generations
  void killStaleSpecies() {
    for (int i = 2; i< species.size(); i++) {
      if (species.get(i).staleness >= 15) {
        species.remove(i);
        i--;
      }else if (species.get(i).getFitness() == 0.0 && species.get(i).staleness > 3){species.remove(i); i--;}
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //if a species sucks so much that it wont even be allocated 1 child for the next generation then kill it now
  void killBadSpecies() {
    float averageSum = getAvgFitnessSum();

    for (int i = 1; i< species.size(); i++) {
      if (species.get(i).averageFitness/averageSum * pop.size() < 1) {//if wont be given a single child 
        species.remove(i);//sad
        i--;
      }
    }
    for (int i = 1; i < species.size(); i++){
      if (species.get(i).averageFitness < 0) {species.remove(i); i--;}
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //returns the sum of each species average fitness
  float getAvgFitnessSum() {
    float averageSum = 0;
    for (Species s : species) {
      averageSum += s.averageFitness;
    }
    return averageSum;
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //kill the bottom half of each species
  void cullSpecies() {
    for (Species s : species) {
      s.cull(); //kill bottom half
      s.fitnessSharing();//also while we're at it lets do fitness sharing
      s.setAverage();//reset averages because they will have changed
    }
  }


  void massExtinction() {
    for (int i =5; i< species.size(); i++) {
      species.remove(i);//sad
      i--;
    }
  }
}
