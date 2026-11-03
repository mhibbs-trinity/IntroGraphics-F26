
PShader shade;
PImage blank;
TextureSphere ts;
float frame;
PImage textureImage;
int FUNC = 0;
float rotAmt = PI;

void setup() {
  //This is doing something very dumb just to have a dummy picture
  blank = createImage(1,1,RGB);
  textureImage = loadImage("grid.png");
  //textureImage = loadImage("orion.png");
  //textureImage = loadImage("raft.png");
  //textureImage = loadImage("SundayInPark.jpg");
  
  ts = new TextureSphere(300, 50, textureImage);

  size(800,800,P3D); 
  //shade = loadShader("basicFrag.glsl","vert.glsl");
  //shade = loadShader("neonFrag.glsl","vert.glsl");
  shade = loadShader("frag.glsl","vert.glsl");
  shader(shade);
}

void draw() {
  frame++;
  shade.set("time",frame / 60f);
  shade.set("mouseX", map(mouseX, 0,width, 0,1));
  shade.set("mouseY", map(mouseY, 0,height, 0,1));
  shade.set("mode",FUNC);
  
  background(0);

  translate(width/2,height/2);
  rotateX(PI/2);
  rotateZ(rotAmt);
  ts.display();

  // beginShape(QUADS);
  // texture(blank);
  // vertex(0,         0,0, 0,0);
  // vertex(width,     0,0, 1,0);
  // vertex(width,height,0, 1,1);
  // vertex(0,    height,0, 0,1);
  // endShape();
}


void keyPressed() {
  if(key == '0') { FUNC = 0; }
  if(key == '1') { FUNC = 1; }
  if(key == '2') { FUNC = 2; }
  if(key == '3') { FUNC = 3; }
  if(key == '4') { FUNC = 4; }
  if(key == '5') { FUNC = 5; }
  if(key == '6') { FUNC = 6; }
  if(key == '7') { FUNC = 7; }
  if(key == '8') { FUNC = 8; }
}

void mouseDragged() {
  rotAmt += (float(mouseX - pmouseX)) / width;
}