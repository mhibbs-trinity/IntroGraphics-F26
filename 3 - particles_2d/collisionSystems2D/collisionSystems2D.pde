CollisionSystem cs;
ArrayList<FixedWall> walls;
ArrayList<PVector> trail;
Particle bigPart;

void setup() {
  size(500,500);
  cs = new CollisionSystem(0,20);
  
  bigPart = new Particle(new PVector(width/2,height/2), 100);
  bigPart.mass = 20;
  cs.parts.add(bigPart);
  
  float rad = 5;
  while(cs.parts.size() < 200) {
    Particle p = new Particle(new PVector(random(rad*2,width-rad*2),random(rad*2,height-rad*2)), rad);
    boolean isect = false;
    for(Particle other : cs.parts) {
      if(p.intersect(other)) {
        isect = true;
        break;
      }
    }
    if(!isect) {
      cs.parts.add(p);
    }
  }
  trail = new ArrayList<PVector>();
  
  walls = new ArrayList<FixedWall>();
  
  walls.add(new FixedWall(new PVector(width/2,0), new PVector(0,height/2)));
  walls.add(new FixedWall(new PVector(0,height/2), new PVector(width,height)));
  walls.add(new FixedWall(new PVector(width,height), new PVector(width/2,0)));
  
  //walls.add(new FixedWall(new PVector(100,100), new PVector(300,300)));
  
  walls.add(new FixedWall(new PVector(0,0), new PVector(width,0)));
  walls.add(new FixedWall(new PVector(width,0), new PVector(width,height)));
  walls.add(new FixedWall(new PVector(width,height), new PVector(0,height)));
  walls.add(new FixedWall(new PVector(0,height), new PVector(0,0)));
  
}

void draw() {
  background(255);
  fill(0);
  /*
  for(FixedWall w : walls) {
    w.display();
  }*/
  
  //cs.run();
  //cs.runWithIntersections();
  //cs.runWithWallIntersections(walls);
  //cs.runShowingParticleCollisions();
  //cs.runShowingWallCollisions(walls);
  //cs.runWithWallCollisions(walls);
  cs.runWithParticleCollisions();
  //cs.runWithParticleAndWallCollisions(walls);
  trail.add(bigPart.loc.copy());
  
  stroke(0,255,0);
  noFill();
  beginShape();
  for(PVector v : trail) vertex(v.x,v.y);
  endShape();
}

void keyPressed() {
  loop();
}
