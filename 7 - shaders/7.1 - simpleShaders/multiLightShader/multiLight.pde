PShader shade;
float litAngle = 0;

void setup() {
  size(500,500,P3D);
  noStroke();
  fill(255);
  
  shade = loadShader("4litfrag.glsl", "4litvert.glsl");
}

void draw() {
  shader(shade);
  background(0);
  translate(width/2, height/2);
  float rad = 700;
  float lvl = 100;
  pointLight(lvl,lvl,lvl, rad*cos(litAngle),        rad*sin(litAngle),        rad);
  pointLight(lvl, 0, 0, rad*cos(litAngle+PI/2),   rad*sin(litAngle+PI/2),   rad);
  pointLight( 0,lvl, 0, rad*cos(litAngle+PI),     rad*sin(litAngle+PI),     rad);
  pointLight( 0, 0,lvl, rad*cos(litAngle+PI*3/2), rad*sin(litAngle+PI*3/2), rad);
  
  //sphereDetail(30);
  sphere(200);
  //box(200);
}

void mouseDragged() {
  litAngle += float(mouseX - pmouseX)/width;
}
