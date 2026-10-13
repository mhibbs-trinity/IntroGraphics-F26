void setup() {
  size(600,600,P3D);
}


void draw() {
  background(0);
  noStroke();
  fill(255);
  translate(width/2,height/2,0);
  
  lightSpecular(255,0,255);
  pointLight(100,100,100, map(mouseX,0,width,-width/2,width/2),
                          map(mouseY,0,height,-height/2, height/2),500);
  sphereDetail(50);
  shininess(100);
  sphere(150);
}
