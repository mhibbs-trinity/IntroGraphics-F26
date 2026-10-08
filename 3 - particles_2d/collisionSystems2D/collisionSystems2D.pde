CollisionSystem cs;
ArrayList<FixedWall> walls;
ArrayList<PVector> trail;
Particle bigPart;

enum Mode {
  NONE, // N
  INTERSECTIONS, // I
  WALL_INTERSECTIONS, // L
  SHOW_PARTICLE_COLLISIONS, // O
  SHOW_WALL_COLLISIONS, // Q
  PARTICLE_COLLISIONS, // P
  WALL_COLLISIONS, // W
  COLLISIONS, // C
  BROWNIAN // --
};
Mode mode = Mode.NONE;
//Mode mode = Mode.BROWNIAN;
float rad = 12;
int numParts = 50;


void setup() {
  size(500,500);
  cs = new CollisionSystem(0,20);
  
  if(mode == Mode.BROWNIAN) {
    bigPart = new Particle(new PVector(width/2,height/2), 100);
    bigPart.mass = 20;
    cs.parts.add(bigPart);
    trail = new ArrayList<PVector>();
  }
  
  while(cs.parts.size() < numParts) {
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
  
  //for(FixedWall w : walls) { w.display(); }
  switch(mode) {
    case NONE:
      cs.run();
      break;
    case INTERSECTIONS:
      cs.runWithIntersections();
      break;
    case WALL_INTERSECTIONS:
      cs.runWithWallIntersections(walls);
      break;
    case SHOW_PARTICLE_COLLISIONS:
      cs.runShowingParticleCollisions();
      break;
    case SHOW_WALL_COLLISIONS:
      cs.runShowingWallCollisions(walls);
      break;
    case PARTICLE_COLLISIONS:
      cs.runWithParticleCollisions();
      break;
    case WALL_COLLISIONS:
      cs.runWithWallCollisions(walls);
      break;
    case COLLISIONS:
      cs.runWithParticleAndWallCollisions(walls);
      break;
    case BROWNIAN:      
      cs.runWithParticleAndWallCollisions(walls);
      trail.add(bigPart.loc.copy());
      stroke(0,255,0);
      noFill();
      beginShape();
      for(PVector v : trail) vertex(v.x,v.y);
      endShape();
      break;
  }
}

void keyPressed() {
  switch(key) {
    case 'n': case 'N':
      mode = Mode.NONE;
      break;
    case 'i': case 'I':
      mode = Mode.INTERSECTIONS;
      break;
    case 'l': case 'L':
      mode = Mode.WALL_INTERSECTIONS;
      break;
    case 'o': case 'O':
      mode = Mode.SHOW_PARTICLE_COLLISIONS;
      break;
    case 'q': case 'Q':
      mode = Mode.SHOW_WALL_COLLISIONS;
      break;
    case 'p': case 'P':
      mode = Mode.PARTICLE_COLLISIONS;
      break;
    case 'w': case 'W':
      mode = Mode.WALL_COLLISIONS;
      break;
    case 'c': case 'C':
      mode = Mode.COLLISIONS;
      break;
    default:
      mode = Mode.NONE;
  }
}
