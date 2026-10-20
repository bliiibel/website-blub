// in this class is:  //<>//
// perlin noise, array list, 

class Jellyfish {
  PVector position;      // xy coordinate
  float pulseTime = 0;   // counter that increases, used in sine formula to create pulse movement and shape 
  float noiseOffset = 0; // counter for perlin noise-> driting motions to left and right 
  
  Tentacle[] tentacles;  // array where tentancle objects will be stored
  int numTentacles = 7;  // jellyfish has 7 tentacles

  Jellyfish(float x, float y) { //starting position of jellyfish
    position = new PVector(x, y);
    tentacles = new Tentacle[numTentacles];
    
    // loop repeats 7 times
    for (int i = 0; i < numTentacles; i++) {
      tentacles[i] = new Tentacle(x, y);
    }
  }

  void update() {
    pulseTime += 0.05; // increases pulse timer so sine moves forward
    noiseOffset += 0.01; // shift position on perlin noise map-> change in drift direction

    float upwardForce = map(sin(pulseTime), -1, 3, 0, -1.5); // sinpulsetime returns value between -1 and 1. and map converts this into value between 0(no movement) and -1.5(moving up). number is negative so jelly goes up
    float drift = map(noise(noiseOffset), 0, 1, -1, 2); // noise returns a smooth number between 0 and 1-> mapped to value between -1(left_ and 2 (right) so mimick water flow

    position.x += drift; // adds drift value to x-pos
    position.y += upwardForce; // adds upward force to y-pos


    // tentacles 
    boolean hasTeleported = false; // track if jellyfish just jumped oppposite side screen

    if (position.y < -100) { // if jellyfish swims too high above screen->
      position.y = height + 100; // reposition at bottom of screen
      hasTeleported = true; //remember jellyfish just teleported
    }
    if (position.x < -50 || position.x > width + 50) { //if jellyfish drifts too far to left OR right
      if (position.x < -50) position.x = width + 50; // if jellyfish disappeared on tyhe left put it on the right side
      else position.x = -50; // else(disappeared right) put it on the left side
      hasTeleported = true;
    }

    // if jellyfish moved to other side screen->
    if (hasTeleported) {
      for (Tentacle t : tentacles) { //loops through all tentacles
        t.reset(position.x, position.y); // resets position of each tentacle to new position jelly-> so tentacles dont stretch across the whole scrteen during teleportation
      }
    }

    // bioluminicne
    if (random(1) < 0.3) { //random number between 0-1-> 30% chance per frame
      ps.addParticle(position.x, position.y + 20); //if chance succees adds glowing paricle to sparticle system
      //we had a lot of trouble with this bc without the 30% chance the light would be a constant beam every single 60 sec frameand made processing lag
    }
  }

  void display() {
    //draw tentacles one by one
    for (int i = 0; i < numTentacles; i++) {
      //distribute tentacles side by side
      float xOffset = map(i, 0, numTentacles - 1, -30, 30);
      tentacles[i].update(position.x + xOffset, position.y + 10); // update position specific and calculate offset
      tentacles[i].display();
    }

    float bellWidth = 100 + sin(pulseTime) * 30; // calculates wdth of head-> bc of sin head fluctuates between 70 (100 - 30) and 130 (100 + 30)
    float bellHeight = 70 - sin(pulseTime) * 25; //calculates height of head. - sign-> when head gets wider(positive sine) the height gets smaller. creates squishy effect

    noStroke();
    fill(100, 200, 255, 150); // RGBA: transparant blue
    arc(position.x, position.y, bellWidth, bellHeight, PI, TWO_PI); // arc which forms main head
    
    fill(80, 180, 255, 200);
    ellipse(position.x, position.y, bellWidth, 10); 
  }
}
