void setup() {
  size(500,500);
}

void draw() {
  background(255);
 
  beginShape();
  for(float theta=0; theta <= TWO_PI; theta += TWO_PI/9) {
    vertex(width/2 + cos(theta) * 200, height/2 + sin(theta) * 200); 
  }
  endShape();
  
  if(mousePressed) {
    println(mouseX + "," + mouseY);
  }
  
  
}
