void setup() {
  size(500,500);
  background(0);
}
void draw() {
  //background(0);
  stroke(255);
  strokeWeight(map(dist(pmouseX,pmouseY, mouseX,mouseY), 0,20, 1,5));
  if(mousePressed) line(pmouseX,pmouseY, mouseX,mouseY);
}
