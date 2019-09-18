enum BorderBehaviour {
  NO_BORDER, BOUNDS, WRAP
}

class Agent {
  PVector pos;
  PVector vel;
  PVector acc;
  float mass;
  color c;
  BorderBehaviour border = BorderBehaviour.NO_BORDER;
  float maxSpeed;
  boolean fixed;
  float friction;

  Agent(float x, float y, float z, float mass, color c) {
    pos = new PVector(x, y, z);
    vel = new PVector(0, 0, 0);
    acc = new PVector(0, 0, 0);
    this.mass = mass;
    this.c = c;
    maxSpeed = 100;
    fixed = false;
    friction = 0.2;
  }
  Agent(float x, float y, float z, float mass) {
    this(x, y, z, mass, color(random(255), random(255), random(255)));
  }
  Agent(float x, float y, float z) {
    this(x, y, z, 20, color(0, random(255), random(255)));
  }
  void applyFriction() {
    PVector fric = vel.copy();
    fric.normalize();
    fric.mult(-friction);
    addForce(fric);
  }
  void update() {
    if (!fixed) {
      applyFriction();
      vel.add(acc);
      pos.add(vel);
      vel.limit(maxSpeed);
      acc.mult(0);

      if (border == BorderBehaviour.BOUNDS) {
        if (pos.x < mass || pos.x >= width - mass) {
          vel.x *= -1;
          pos.x = constrain(pos.x, mass, width - mass);
        }
        if (pos.y < mass || pos.y >= height - mass) {
          vel.y *= -1;
          pos.y = constrain(pos.y, mass, height - mass);
        }
      } else 
      if (border == BorderBehaviour.WRAP) {
        pos.x = (pos.x + width) % width;
        pos.y = (pos.y + height) % height;
      }
    }
  }
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading());
    noStroke();
    fill(c);
    ellipse(0, 0, sqrt(mass) * 2, sqrt(mass) * 2);
    //beginShape();
    //vertex(0, -mass/3);
    //vertex(0, mass/3);
    //vertex(mass, 0);
    //endShape(CLOSE);
    popMatrix();
  }
  void addForce(PVector f) {
    PVector force = PVector.div(f, mass);
    acc.add(force);
  }
  void fix() {
    fixed = true;
  }
  void unfix() {
    fixed = false;
  }
}
