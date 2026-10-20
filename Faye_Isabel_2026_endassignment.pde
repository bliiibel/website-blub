// aquarium Faye and Isabel ALGOS
// background-> perlin noise
// class coral-> mass damper system
// class jellyfish-> arraylist, perlin noise
// class jellyfishparticles-> particles
// class tentacles-> mass damper 

// concept and inspo:
// Flocking (separation, alignment, cohesion): Craig Reynolds' Boids
// Mass-spring-damper physics: Nature of Code Chapter 3 (The Coding Train)
// Perlin noise: Processing reference documentation
// Particle systems: Nature of Code Chapter 4
// AI for debugging and helping understanding


// No code was directly copied from any source. 

import java.util.Random;

int gameState = 0; // 0 = startscreen, 1 = game
PImage selectedCharacter; 

// variables player position
float charX, charY;
float charSpeed = 5.0; // speed of character 
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

Random generator; 
TankBackground bg;
Jellyfish jelly;
ParticleSystem ps;
PImage squid;
PImage turtle;
PImage seal;
PImage seahorse;

ArrayList<Coral> corals; 
color[] palette = {#EA5873, #F5996A, #DE6ECB, #E0635D};
ArrayList<Fish> school;

void setup() {
  size(900, 600);
  bg = new TankBackground(); 
  corals = new ArrayList<Coral>();
  jelly = new Jellyfish(width/4, 600);
  ps = new ParticleSystem();
  generator = new Random();
  
  // Laad de afbeeldingen
  squid = loadImage("squid.png");
  turtle = loadImage("turtle.png"); 
  seal = loadImage("seal.png");
  seahorse = loadImage("seahorse.png"); 
  
  school = new ArrayList<Fish>();
  for(int i=10; i<50; i++) {
    school.add(new Fish(random(width), random(height)));
  }
  
  int coralsPerSide = 5;
  for (int i=0; i<coralsPerSide; i++) {
    float mean = width/7; 
    float standardDeviation = 50; 
    float x = (float) generator.nextGaussian() * standardDeviation + mean;
    float h = random(30,200); 
    corals.add(new Coral(x, h));
  }
  
  for (int i=0; i<coralsPerSide; i++) {
    float mean = width*7/8; 
    float standardDeviation = 50; 
    float x = (float) generator.nextGaussian() * standardDeviation + mean;
    float h = random(30,200); 
    corals.add(new Coral(x, h));
  }
}

void draw() {
  if (gameState == 0) {
    drawStartScreen(); 
  } else if (gameState == 1) {
    playGame();
  }
}

void mousePressed() {
  if (gameState == 0) {
    handleStartScreenClick(); 
  }
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) upPressed = true;
    if (keyCode == DOWN) downPressed = true;
    if (keyCode == LEFT) leftPressed = true;
    if (keyCode == RIGHT) rightPressed = true;
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) upPressed = false;
    if (keyCode == DOWN) downPressed = false;
    if (keyCode == LEFT) leftPressed = false;
    if (keyCode == RIGHT) rightPressed = false;
  }
}

void playGame() {
  bg.display();
  float waterForce = map(noise(frameCount * 0.01), 0, 1, -0.05, 0.05);
  
  for(Coral c : corals) {
    c.update(waterForce);
    c.display();
  }
  
  for (Fish f: school) {
    f.applyBehaviours(school, charX, charY); // fishes flee fo
    f.update();
    f.display();
  }
  
  ps.update();
  ps.render();
  jelly.update();
  jelly.display();
  
 
  if (upPressed) charY -= charSpeed;
  if (downPressed) charY += charSpeed;
  if (leftPressed) charX -= charSpeed;
  if (rightPressed) charX += charSpeed;
  
  charX = constrain(charX, 0, width);
  charY = constrain(charY, 0, height);
  
  if (selectedCharacter != null) {
    imageMode(CENTER);
    image(selectedCharacter, charX, charY, width/6, height/6); 
    imageMode(CORNER); 
  }
}
