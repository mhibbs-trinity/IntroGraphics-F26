
void setup() {
  size(600,600, P3D);
}

void draw() {
  background(0);
  //camera(width/2,height/2,1200, 0,0,0, 0,1,0);
  //ortho(-width/2,width/2, -height/2,height/2);
  //frustum(-width/2,width/2, -height/2,height/2, map(mouseX,0,width,0,1000),5000);
  //lights();
  noStroke();
  
  translate(200,200,0);
  camera(width/2,height/2,1200, 0,0,0, 0,1,0);
  
  pointLight(255,255,255, mouseX,mouseY,1200);
  
  
  //rotateX(map(mouseX, 0,width, 0,2*PI));
  //rotateY(map(mouseY, 0,height, 0,2*PI));
  //rect(0,0, 200,200); 
  box(200,100,300);
  pushMatrix();
  translate(200,200,0);
  //sphereDetail(4,(int)map(mouseY, 0,height, 3,100));
  sphere(100);
  popMatrix();
  stroke(200,50,50);
  strokeWeight(5);
  line(0,0,0, width,0,0);
  stroke(50,200,50);
  line(0,0,0, 0,height,0);
  stroke(50,50,200);
  line(0,0,0, 0,0,600);
}
