class Flock {
  ArrayList<Boid> boids = new ArrayList<Boid>();
  void add(Boid b) { boids.add(b); }
  void run() {
    for (Boid b : boids) b.run(boids);
  }
}