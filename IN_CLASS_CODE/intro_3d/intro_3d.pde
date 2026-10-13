void setup() {
  size(500,500,P3D);
}

void draw() {
  background(0);
  
  //lights();
  
  PVector eye = new PVector(width/2,height/2,500);
  PVector dir = new PVector(0,0,-1);//map(mouseX,0,width,-1,1),0,-1);
  
  PVector target = PVector.add(eye,dir);
  
  camera(eye.x,eye.y,eye.z, target.x,target.y,target.z, 0,1,0);
    
  pointLight(255,255,255, map(mouseX,0,width,-width,width),map(mouseY,0,height,-height,height),200);
    
  fill(255,0,0);
  //noStroke();
  
  translate(150,150);
  //rotateX(map(mouseX, 0,width, -PI/2,PI/2));    
  box(100);
  
  translate(150,150);
  sphereDetail(20);
  sphere(100);
 
  //rect(100,100, 100,100);
}
