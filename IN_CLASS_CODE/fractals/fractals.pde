void setup() {
  size(500,500); 
}

void makeCircle(float x, float y, float d) {
  ellipse(x,y,d,d);
  if(d > 25) {
    makeCircle(x-d/2,y,d/2);
    makeCircle(x+d/2,y,d/2);
    makeCircle(x,y-d/2,d/2);
    makeCircle(x,y+d/2,d/2);
  }
}


void draw() {
  background(0);
  stroke(255);
  noFill();
  makeCircle(width/2,height/2, 250);
}
