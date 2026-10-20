// in this class is:
// Flocking

class Fish {
  PVector pos, vel, acc;
  float maxSpeed=3.0;
  float maxForce= 0.05; // how fast the fish can turn

  Fish(float x, float y) {
    pos= new PVector(x, y);
    vel= PVector.random2D(); // all fishes go in different directions
    acc= new PVector (0, 0); // starts at 0
  }

  void applyBehaviours (ArrayList <Fish> fishes, float cx, float cy) {
    PVector sep= separate(fishes); // fishes separete when close to eachother
    PVector ali= align(fishes); // fishes swim in the same direction
    PVector coh= cohesion(fishes); // fishes swim together in group
    PVector flee= flee(new PVector(cx, cy)); // fishes swim away from character

    // weigh the forces flee is most important so stronger
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.2); // stronger coh the tighter school
    flee.mult(2.5);

    acc.add(sep); // add sep, ali, coh, flee to the acceleration vector (remove and nothing happends)
    acc.add(ali);
    acc.add(coh);
    acc.add(flee);
  }

  PVector flee(PVector target) {
    // Calculate the distance between the character and the fish
    float d = PVector.dist(pos, target);

    // Check if the character is within the panic radius of 100 pixels
    if (d < 100) {

      // Calculate a vector pointing exactly away from the character
      PVector desired = PVector.sub(pos, target);

      // Set the fleeing speed to maximum because the fish is scared
      desired.setMag(maxSpeed);

      // Calculate the steering force needed to turn around (Steer = Desired - Velocity)
      PVector steer = PVector.sub(desired, vel);

      // Double the steering force so the fish makes a very sharp and fast escape turn
      steer.limit(maxForce * 2);

      // Return the steering force to apply it to the acceleration
      return steer;
    }

    // If the character is far away, return zero steering force (stay calm)
    return new PVector(0, 0);
  }


  PVector cohesion(ArrayList<Fish> fishes) { // (dutch: samenhang)
    // Set the radius of the vision circle (how far the fish can look)
    float neighborDist = 100;
    // counts position of all fish
    PVector sum = new PVector(0, 0);
    // Create a counter to keep track of how many neighbors are found
    int count = 0;

    // Loop through every single fish in the school
    for (Fish other : fishes) {
      float d = PVector.dist(pos, other.pos);// Distance to the other fish
      // Check if the other fish is a neighbor
      if ((d > 0) && (d < neighborDist)) {
        sum.add(other.pos); // add up all neighbor positions
        count++;
      }
    }

    // If we found neighbors, calculate the center and steer towards it
    if (count > 0) {
      sum.div(count); // get the average position --> center
      return seek(sum); // return that center --> further down in code
    }
    return new PVector(0, 0); // Return zero force if the fish is completely alone
  } //<>//

  // // Helper method for cohesion: calculates a smooth steering force towards a target position
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, pos); /// A vector pointing straight from the fish to the target
    desired.setMag(maxSpeed); // Set speed to maximum to get there as fast as possible
    PVector steer = PVector.sub(desired, vel); //Steer = Desired - Velocity
    steer.limit(maxForce); // Limit the force to keep the turning smooth and natural
    return steer;
  }

  // alignment: Look at neighbors and match their heading
  PVector align(ArrayList<Fish> fishes) {
    PVector sum = new PVector(0, 0); // starts at 0
    int count = 0;
    // Loop through every single fish in the school
    for (Fish other : fishes) {
      // Calculate the distance between this fish and the other fish
      float d = PVector.dist(pos, other.pos);

      // Check if the other fish is a neighbor (not itself, and within 50 pixels)
      if ((d > 0) && (d < 50)) {
        // Add the neighbor's velocity vector (their current direction and speed) to the sum
        sum.add(other.vel);

        // Increment the neighbor counter by 1
        count++;
      }
    }

    if (count > 0) {
      sum.div(count); // Divide the sum by count to get the average heading of the group
      sum.setMag(maxSpeed); // go to that direction in full speed
      PVector steer = PVector.sub(sum, vel); // calculate steering
      steer.limit(maxForce);
      return steer; // Return the steering force to apply it to the acceleration
    }
    return new PVector(0, 0);
  }

  // separation: avoid bumping into each other
  PVector separate(ArrayList<Fish> fishes) {
    PVector steer = new PVector(0, 0); // start at 0
    int count = 0;
    for (Fish other : fishes) {
      float d = PVector.dist(pos, other.pos);
      if ((d > 0) && (d < 25)) { // counts if fishes are within 25 radias
        // Calculate a vector pointing exactly away from the too-close neighbor
        PVector diff = PVector.sub(pos, other.pos);
        // Normalize the vector to reduce its length to 1, keeping only the direction
        diff.normalize();
        //Divide by distance so closer fish push away much harder than further fish (exponential) 
        diff.div(d);
        //Add this specific push-away force to the total steering vector
        steer.add(diff);
        // Increment the counter of close neighbors
        count++;
      }
    }
    // If we found overlapping neighbors, calculate the average push-away vector
    if (count > 0) steer.div(count);
    if (steer.mag() > 0) {
      steer.setMag(maxSpeed);
      steer.sub(vel);
      steer.limit(maxForce);
    }
    return steer; // Return the final separation force to apply it to the acceleration
  }

  void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0); // reset acceleration each frame

    // screen wrap
    if (pos.x < 0) pos.x = width;
    if (pos.x > width) pos.x = 0;
    if (pos.y < 0) pos.y = height;
    if (pos.y > height) pos.y = 0;
  }


  // draw the fish
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading());
    fill(255, 200, 0);
    noStroke();
    ellipse(0, 0, 10, 5); // body
    triangle(-5, 0, -8, 3, -8, -3); //  tail
    popMatrix();
  }
}
