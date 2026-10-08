boolean accumulate = false;

void setup() {
  size(500,500,P3D);
  if (accumulate) {
    translate(width/2,height/2, 0);
    pushMatrix();
  }
}

void draw() {
  if (accumulate) {
    popMatrix();
    //translate(0.1,0.1,0);
  }  
  else { //if (!accumulate) { 
    translate(width/2,height/2, 0);
    rotateX(map(mouseY, 0,width, TWO_PI,0));
    //rotateY(map(mouseX, 0,width, 0,TWO_PI));
  }

  lights();
  background(0);
   
  float lightX = mouseX - width/2;
  float lightY = mouseY - height/2;
  float lightZ = 400;
  pointLight(255,255,255, lightX,lightY,lightZ);
  stroke(255);
  strokeWeight(10);
  point(lightX,lightY,lightZ); 
  
  ambientLight(50,0,0);
  
  //Axes
  noFill();
  strokeWeight(5);
  stroke(color(255,0,0));
  line(-width,0,0, width,0,0);
  stroke(color(0,255,0));
  line(0,-height,0, 0,height,0);
  stroke(color(0,0,255));
  line(0,0,width, 0,0,0);//-width);

  fill(255);
  noStroke();
  sphere(100);
  
  if (accumulate) {
    pushMatrix();
  }
}

void mouseDragged() {
  if (accumulate) {
    popMatrix();
    rotateX(map(pmouseY-mouseY, 0,width, 0,TWO_PI));
    pushMatrix();
  }
}
