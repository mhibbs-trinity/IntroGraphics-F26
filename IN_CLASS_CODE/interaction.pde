float y = 200;

float m = PI/4;
float dm = -PI/128;

void setup() {
  size(500,500);
  background(0);
}

void draw() {
  background(0);
  stroke(255);
  if(mousePressed) {
    float d = dist(pmouseX,pmouseY, mouseX,mouseY);
    strokeWeight(d/2);
    line(pmouseX,pmouseY, mouseX,mouseY);
  }
  
  fill(255,255,0);
  stroke(255,0,0);
  arc(250,250, 200,200, m,TWO_PI-m, CHORD);
  m += dm;
  if(m <= 0 || m >= PI/4) dm *= -1;
  
}
