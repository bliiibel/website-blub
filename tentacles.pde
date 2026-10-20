// in this class:
// mass damper, Perlin noise

class Tentacle {
  PVector[] nodes; //array of vectors-> each vector is a joint of a tentacle
  int numNodes = 20; // tentacle devided in 20 segments so smooth move
  float stiffness = 0.3; // controls how quickly a segment cathes up to segment ahead of it-> lower value looser, higher value rigid

  Tentacle(float x, float y) { //constructor runs when tentacle is born benath jellyfish
    nodes = new PVector[numNodes]; // space for exactly 20 position vectors 
    for (int i = 0; i < numNodes; i++) { // loop to int each point in the chain
      nodes[i] = new PVector(x, y + (i * 5)); // spawns each point 5 pixels lower then previous one-> starts tentacles hanging straight down
    
    }
  }
  
void reset(float newX, float newY) { // takes a new xy destination
    for (int i = 0; i < numNodes; i++) { //loop through all nodes
      nodes[i].set(newX, newY + (i * 5)); // moves every node directly to jellyfish new location vertically-> prevents from glitching and drawig big line on screen
    }
  }
  
  
  void update(float headX, float headY) { //recieves current position of jellyfish body where tentacle is attached
    nodes[0].set(headX, headY); //locks first node to jellyfish body

    //loop start at i instead of 0-> each node will now caluclate how to follow the node above itself (i-1)
    for (int i = 1; i < numNodes; i++) {
      PVector target = nodes[i - 1].copy(); //creates temporary copy of position of node above, serves as destination goal
      
      //  use perlin noise 3d based on tenatcle position, node index and frammecount(time) to calculate ocean current
      float waterSway = map(noise(headX * 0.01, i * 0.1, frameCount * 0.02), 0, 1, -3, 3);
      target.x += waterSway; // horizontal water current drift to target pos
      target.y += 5; // simulates gravity by pulling target pos 5 pixels down

      // calculate distance and direction vector pointing from current node to intent target
      PVector dir = PVector.sub(target, nodes[i]);
      dir.mult(stiffness); // multiplies direction vector by extra stiffness
      nodes[i].add(dir); //adds final movement to current node posoition shifting to target
    }
  }

  // draw strings through 20 nodes instead of straight lines
  void display() {
    noFill();
    stroke(150, 220, 255, 100);
    strokeWeight(2);
    
    beginShape();
    // starts recording points to draw shape
    curveVertex(nodes[0].x, nodes[0].y); // the first curvevertex acts as control point to determine angle of curve
    for (PVector p : nodes) {
      curveVertex(p.x, p.y); //plots mathematically spline curve through each node coordinate
    }
    curveVertex(nodes[numNodes-1].x, nodes[numNodes-1].y); // final curvevertex acts as exit control point to shape tip of tentacle tail
    endShape();
  }
}
