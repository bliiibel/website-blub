// in this class is:
// Mass damper system 


class Coral {

  PVector root;          // fixed base of the coral
  float angle;           // current bending angle
  float aVelocity;       // angular velocity
  float aAcceleration;   // angular acceleration

  // mass-damper parameters
  float mass = 10.0;     // higher mass->slower, heavier movement
  float k = 0.1;         // spring constant (stiffness) - higher k pulls the coral back faster
  float damping = 0.95;  // friction (0.95 = 5% energy loss per frame) (Higher --> faster )

  float h;               // height of the coral (maintab)
  color coralColor;

  Coral(float x, float h) {
    this.root = new PVector(x, height - 40); // Base in the sand place
    this.h = h;
    this.angle = 0;
    this.aVelocity = 0;
    this.coralColor= palette[int(random(palette.length))];
  }
  // Calculates the movement every frame (60 per sec)
  void update(float externalForce) {
    // 1. spring force (hookes law= -k * x) -> the further the coral sways, the harder it pulls back
    float springForce = -k * angle;

    // 2. applied physics Newton 2Law: a = F/m
    // add externalForce like a water current to the spring force
    aAcceleration = (springForce + externalForce) / mass;

    // 3. velocity and damping
    aVelocity += aAcceleration;
    aVelocity *= damping; //  "damper" part -> simulates water resistance

    // 4. update angle
    angle += aVelocity; // acummulate velocity is fed back to start of loop to calculate next frames spring force
  }

  void display() {
    pushMatrix();
    translate(root.x, root.y);
    rotate(angle); // rotate the entire branch based on the mass-damper calc

    stroke(coralColor);
    strokeWeight(10);

    // main stalk
    line(0, 0, 0, -h);

    // branches
    pushMatrix();
    translate(0, -h * 0.4);
    rotate(PI/4);
    line(0, 0, 0, -h * 0.4);
    popMatrix();

    pushMatrix();
    translate(0, -h * 0.6);
    rotate(-PI/4);
    line(0, 0, 0, -h * 0.4);
    popMatrix();

    popMatrix();
  }
}
