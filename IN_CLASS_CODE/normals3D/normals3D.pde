
void setup() {
  size(600,600, P3D);
}

void draw() {
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
  
  PVector ab = PVector.sub(b,a);
  PVector ac = PVector.sub(c,a);
  PVector abcN = ab.copy().cross(ac);
  
  /*
  beginShape(TRIANGLE_FAN);
  normal(abcN.x, abcN.y, abcN.z);
  doVertex(a);
  doVertex(b);
  doVertex(c);
  doVertex(d);
  doVertex(e);
  doVertex(b);
  endShape();
  */
  
  PVector anorm = new PVector(0,0,1);
  PVector bnorm = new PVector(-1,-1,0);
  bnorm.normalize();
  PVector cnorm = new PVector( 1,-1,0);
  cnorm.normalize();
  PVector dnorm = new PVector( 1, 1,0);
  dnorm.normalize();
  PVector enorm = new PVector(-1, 1,0);
  enorm.normalize();
  
  beginShape(TRIANGLES);
  
  //PVector norm = PVector.sub(b,a);
  //norm = norm.cross(PVector.sub(c,a));
  //norm.normalize();
  //normal(norm.x, norm.y, norm.z);
  
  doVertex(a, anorm);
  doVertex(b, bnorm);
  doVertex(c, cnorm);
  
  //norm = PVector.sub(c,a);
  //norm = norm.cross(PVector.sub(d,a));
  //norm.normalize();
  //normal(norm.x, norm.y, norm.z);
  
  doVertex(a, anorm);
  doVertex(c, cnorm);
  doVertex(d, dnorm);
  
  //norm = PVector.sub(d,a);
  //norm = norm.cross(PVector.sub(e,a));
  //norm.normalize();
  //normal(norm.x, norm.y, norm.z);
  
  doVertex(a, anorm);
  doVertex(d, dnorm);
  doVertex(e, enorm);
  
  //norm = PVector.sub(e,a);
  //norm = norm.cross(PVector.sub(b,a));
  //norm.normalize();
  //normal(norm.x, norm.y, norm.z);
  
  doVertex(a, anorm);
  doVertex(e, enorm);
  doVertex(b, bnorm);
  endShape();

  
}

void doVertex(PVector v) {
  vertex(v.x,v.y,v.z);
}
void doVertex(PVector v, PVector n) {
  normal(n.x,n.y,n.z);
  vertex(v.x,v.y,v.z);
}
