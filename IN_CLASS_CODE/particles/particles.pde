ParticleSystem ps;

void setup() {
  size(500,500);
  ps = new ParticleSystem(new PVector(width/2, height/2));
}

void draw() {
  background(0);
  ps.run();
  ps.addParticle();
  
}

class Particle {
   PVector pos, vel, acc;
   Particle(PVector p, PVector v, PVector a) {
     pos = p; vel = v; acc = a;
   }
   void display() {
     fill(255,0,0);
     ellipse(pos.x, pos.y, 10,10);
   }
   void update() {
     pos.add(vel);
     vel.add(acc);
   }
}

class ParticleSystem {
  ArrayList<Particle> parts;
  PVector origin;
  ParticleSystem(PVector o) {
    parts = new ArrayList<Particle>();
    origin = o;
  }
  void addParticle() {
    Particle p = new Particle(origin.copy(), new PVector((float)(Math.random() * 2 - 1), (float)(Math.random() * 2 - 1)), new PVector(0,0.01));
    parts.add(p);
  }
  void run() {
    for(Particle p : parts) {
      p.display();
      p.update();
    }
  }
}
