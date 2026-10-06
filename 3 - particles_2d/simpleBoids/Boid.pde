class Boid {
  PVector pos, vel, acc;
  float maxSpeed = 2.6;
  float maxForce = 0.05;
  float view = 45;        // neighborhood radius
  float sepDist = 18;     // separation radius

  Boid(float x, float y) {
    pos = new PVector(x, y);
    float a = random(TWO_PI);
    vel = new PVector(cos(a), sin(a)).mult(random(1.5, maxSpeed));
    acc = new PVector();
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  // Apply the three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids).mult(1.6);
    PVector ali = align(boids).mult(1.0);
    PVector coh = cohesion(boids).mult(0.9);

    apply(sep);
    apply(ali);
    apply(coh);
  }

  void apply(PVector force) { acc.add(force); }

  void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
  }

  // Keep boids on screen with wraparound
  void borders() {
    if (pos.x < -10) pos.x = width + 10;
    if (pos.y < -10) pos.y = height + 10;
    if (pos.x > width + 10) pos.x = -10;
    if (pos.y > height + 10) pos.y = -10;
  }

  // Draw a small triangle pointing in the velocity direction
  void render() {
    float theta = vel.heading() + PI/2;
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    noStroke();
    fill(40, 80);
    beginShape();
    vertex(0, -6);
    vertex(-3, 6);
    vertex(3, 6);
    endShape(CLOSE);
    popMatrix();
  }

  // Rule 1: Separation — steer to avoid crowding local flockmates
  PVector separate(ArrayList<Boid> boids) {
    PVector steer = new PVector();
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(pos, other.pos);
      if (other != this && d < sepDist && d > 0) {
        PVector diff = PVector.sub(pos, other.pos);
        //diff.normalize();
        diff.div(d*d); // weight by distance
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) steer.div(count);
    if (steer.mag() > 0) {
      steer.setMag(maxForce * 1.0);
    }
    return steer;
  }

  // Rule 2: Alignment — steer toward the average heading of neighbors
  PVector align(ArrayList<Boid> boids) {
    PVector sum = new PVector();
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(pos, other.pos);
      if (other != this && d < view) {
        sum.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.setMag(maxSpeed);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector();
    }
  }

  // Rule 3: Cohesion — steer to move toward the average position of neighbors
  PVector cohesion(ArrayList<Boid> boids) {
    PVector sum = new PVector();
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(pos, other.pos);
      if (other != this && d < view) {
        sum.add(other.pos);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count); // center of mass
      // Steering helper toward a target
      PVector desired = PVector.sub(sum, pos);
      desired.setMag(maxSpeed);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector();
    }
  } 
}