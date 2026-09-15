PVector p1;
PVector p2;
PVector p3;
PVector p4;

void setup() {
  size(400,400);
}

void draw() {
  background(255);
  strokeWeight(4);
  
  p1 = new PVector(100,100);
  p2 = new PVector(300,100);
  p3 = new PVector(300,300);
  p4 = new PVector(100,300);
  
  curve(p1.x,p1.y, p2.x,p2.y, p3.x,p3.y, p4.x,p4.y);
}
  
