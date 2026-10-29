PShader shade;
int mode = 5;

void setup() {
  size(500,500,P3D);
  pixelDensity(1);
  noStroke();
  fill(255);
  
  shade = loadShader("fragment.glsl", "vertex.glsl");
  //shade.set("fraction",1.0);
}

void draw() {
  shader(shade);
  background(0);
  
  translate(width/2, height/2);
  sphereDetail(10);
  sphere(200);
}

