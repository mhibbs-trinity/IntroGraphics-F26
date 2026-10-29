
PShader shade;
PImage img;

float frame;

void setup() {
  //This is doing something very dumb just to have a dummy picture
  img = createImage(1,1,RGB);
  
  size(800,800,P3D); 
  //shade = loadShader("basicFrag.glsl","vert.glsl");
  //shade = loadShader("neonFrag.glsl","vert.glsl");
  shade = loadShader("flareFrag.glsl","vert.glsl");
  shader(shade);
}

void draw() {
  frame++;
  shade.set("time",frame / 60f);
  shade.set("mouseX",(float)mouseX);
  
  background(0);
  beginShape(QUADS);
  texture(img);
  vertex(0,         0,0, 0,0);
  vertex(width,     0,0, 1,0);
  vertex(width,height,0, 1,1);
  vertex(0,    height,0, 0,1);
  endShape();
}
