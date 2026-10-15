
void setup() {
  size(600,600, P3D);
}

void draw() {

  background(0);

  background(0);
  translate(width/2,height/2,-100);
  
  PVector litPos = new PVector(map(mouseX,0,width,-width/2,width/2),
                          map(mouseY,0,height,-height/2, height/2),200);

  pointLight(255,255,255, litPos.x, litPos.y, litPos.z);
  stroke(255);
  strokeWeight(10);
  point(litPos.x, litPos.y, litPos.z);
                       
  noStroke();
  //ambientLight(100,0,0);
  
  PVector a = new PVector(0,0,0);
  PVector b = new PVector(-200,-200,-100);
  PVector c = new PVector( 200,-200,-100);
  PVector d = new PVector( 200, 200,-100);
  PVector e = new PVector(-200, 200,-100);
  
  beginShape();
  doVertex(b);
  doVertex(c);
  doVertex(d);
  doVertex(e);
  endShape(CLOSE);
  

  
}

void doVertex(PVector v) {
  vertex(v.x,v.y,v.z);
}
void doVertex(PVector v, PVector n) {
  //normal(n.x,n.y,n.z);
  vertex(v.x,v.y,v.z);
}
