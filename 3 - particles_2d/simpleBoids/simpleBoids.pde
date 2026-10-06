Flock flock;

void setup() {
  size(800, 600, P3D);
  flock = new Flock();
  for (int i = 0; i < 120; i++) {
    flock.add(new Boid(random(width), random(height)));
  }
  smooth(4);
}

void draw() {
  background(245);
  flock.run();
  fill(0);
  text("Boids: " + flock.boids.size() + "  (click to add)", 10, 20);
}

void mousePressed() {
  for (int i = 0; i < 12; i++) {
    flock.add(new Boid(mouseX, mouseY));
  }
}
void mouseReleased() {
  for (int i = 0; i < 12; i++) {
    flock.add(new Boid(mouseX, mouseY));
  }
}
void mouseDragged() {
  flock.add(new Boid(mouseX, mouseY));
}
