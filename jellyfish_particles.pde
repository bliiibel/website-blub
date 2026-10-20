// in this class is:
// particles

class ParticleSystem {
  ArrayList<Particle> particles;

  ParticleSystem() {
    particles = new ArrayList<Particle>();
  }

  void addParticle(float x, float y) { // spawn new particle at specific location called by jellyfsih
    particles.add(new Particle(x, y));
  }

  void update() {
    for (int i = particles.size() - 1; i >= 0; i--) { // for loop that goes backwards on the list-> loop backwards bc if you delete item wgile looping forwards the list shifts left so you can accidentally skip next item
      Particle p = particles.get(i);
      p.update();
      if (p.isDead()) { // check if particle's life has run out
        particles.remove(i); // if out of life permenantly delete
      }
    }
  }

  void render() {
    blendMode(ADD); // swith to additive blending-> transparant particles overlap the pixel values add up-> more intense and glowing
    for (Particle p : particles) { // goes trough each remaining particle
      p.render();
    }
    blendMode(BLEND); // reset to default drawing mode
  }
}

class Particle {
  PVector position;
  PVector velocity; //xy screen coordinates
  float lifetime; // number that represents health/transparancy of particle

  Particle(float x, float y) {
    position = new PVector(x, y); //set particle start position to where jellyfish dropped it
    velocity = new PVector(random(-0.5, 0.5), random(0.5, 1)); // gives random speed-> left.right and sink downwards
    lifetime = 255; // maximum value of color transparancy 
  }

  void update() {
    position.add(velocity); // adds velocity vector to position vec shifting particle
    lifetime -= 3; // -3 from lifetime every frame
  }

  boolean isDead() { //return true or false
    return lifetime < 0; // if lifetime is below 0 tells yes im dead
 }

  void render() {
    noStroke();
    fill(100, 255, 255, lifetime); // lifetime is the RGB value
    circle(position.x, position.y, 4);
  }
}
