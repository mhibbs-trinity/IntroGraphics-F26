

PShader shade;
PImage img = createImage(1,1,RGB);
float t = 0;

float yRot = 0;

enum Mode {
  MODE_SIMPLE,
  MODE_PLOT,
  MODE_PATTERN,
  MODE_FLARE,
  MODE_FUNCTIONS,
}

Mode MODE = Mode.MODE_SIMPLE;
int FUNC = 0;
int BASEMODE = 0;
int PLOTMODE = 0;

void setup() {
  size(600,600,P3D);
  updateMode();
  shader(shade);
}

void draw() {
  rotateY(yRot);
  shader(shade);
  
  shade.set("mode", int(FUNC));
  shade.set("baseMode", int(BASEMODE));
  shade.set("plotMode", int(PLOTMODE));
  shade.set("u_resolution", float(width), float(height));
  shade.set("u_mouse", float(mouseX), float(mouseY));
  shade.set("u_time", millis() / 1000f);
  
  shade.set("time", t);
  shade.set("mouseX", map(mouseX, 0,width, 0,1));
  shade.set("mouseY", map(mouseY, 0,height, 0,1));
  t += 0.01;
  
  background(0);
  beginShape(QUADS);
  texture(img);
  vertex(0,         0,0, 0,0);
  vertex(width,     0,0, 1,0);
  vertex(width,height,0, 1,1);
  vertex(0,    height,0, 0,1);
  endShape();
  
}

void mouseDragged() {
  float dx = pmouseX - mouseX;
  if(abs(dx) > 0) {
    yRot += dx / width;
  }
}

void keyPressed() {
  if(key == '0') { FUNC = 0; BASEMODE = 0; PLOTMODE = 0; }
  if(key == '1') { FUNC = 1; BASEMODE = 1; }
  if(key == '2') { FUNC = 2; BASEMODE = 2; }
  if(key == '3') { FUNC = 3; BASEMODE = 3; }
  if(key == '4') { FUNC = 4; PLOTMODE = 1; }
  if(key == '5') { FUNC = 5; PLOTMODE = 2; }
  if(key == '6') { FUNC = 6; PLOTMODE = 3; }
  if(key == '7') { FUNC = 7; PLOTMODE = 4; }
  if(key == '8') { FUNC = 8; PLOTMODE = 5; }
  if(key == '9') { PLOTMODE = 6; }

  if(key == 'S' || key == 's') {
    MODE = Mode.MODE_SIMPLE;
  }
  if(key == 'P' || key == 'p') {
    MODE = Mode.MODE_PLOT;
  }
  if(key == 'T' || key == 't') {
    MODE = Mode.MODE_PATTERN;
  }
  if(key == 'R' || key == 'r') {
    MODE = Mode.MODE_FLARE;
  }
  if(key == 'F' || key == 'f') {
    MODE = Mode.MODE_FUNCTIONS;
  }
  updateMode();
}

void updateMode() {
  if(MODE == Mode.MODE_SIMPLE) {
    shade = loadShader("frag.glsl","vert.glsl");
  } else if(MODE == Mode.MODE_PLOT) {
    shade = loadShader("frag_plot.glsl","vert.glsl");
  } else if(MODE == Mode.MODE_PATTERN) {
    shade = loadShader("frag_pattern.glsl","vert.glsl");
  } else if(MODE == Mode.MODE_FLARE) {
    shade = loadShader("frag_flare.glsl","vert.glsl");
  } else if(MODE == Mode.MODE_FUNCTIONS) {
    shade = loadShader("frag_functions.glsl","vert.glsl");
  }
}
