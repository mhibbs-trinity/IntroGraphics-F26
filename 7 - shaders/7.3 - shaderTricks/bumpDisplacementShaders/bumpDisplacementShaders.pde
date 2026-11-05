
PShader shader;
PImage colTex;
PImage htTex;
PImage normTex;
float rot;

int mode = 0; //Set to 1 for displacement mapping; to 0 for bump mapping
void keyPressed() {
  if(key == '0') mode = 0; //bump map (normal mapping)
  if(key == '1') mode = 1; //displacement map
  if(key == '2') mode = 2; //dynamic "function" map
  updateShader();
}

void setup() {
  size(500,500, P3D);
  noStroke();
  colTex = loadImage("pebble_color.png");
  //colTex = loadImage("gray.png");
  htTex = loadImage("pebble_height.png");
  normTex = loadImage("pebble_normal.png");
  updateShader();
}
void updateShader() {
  if(mode == 0) {
    shader = loadShader("bumpfrag.glsl", "bumpvert.glsl");
  } else if(mode == 1) { 
    shader = loadShader("dispfrag.glsl", "dispvert.glsl");
  } else if(mode == 2) {
    shader = loadShader("dispfuncfrag.glsl", "dispfuncvert.glsl");
  }
}

void draw() {
  background(0); 
  pointLight(255,255,255, mouseX,mouseY,300);
  stroke(255);
  strokeWeight(5);
  point(mouseX,mouseY,300);
  strokeWeight(1);
  
  translate(width/2,height/2);
  rotateY(rot);
  translate(-width/2,-height/2);
  
  noStroke();
  fill(255);
  shader(shader);
  shader.set("scale", map(mouseY, 0,height, 0.0,100.0));
  shader.set("freq", map(mouseX, 0,width, 100.0,800.0));
  shader.set("time", millis() / 1000.0);
  shader.set("normmap", normTex);
  shader.set("htmap", htTex);
  
  if(mode == 1 || mode == 2) {
    float lo = 50.0;
    float hi = 450.0;
    float diff = hi-lo;
    float segs = 20.0;
    float step = 1.0/segs;
    beginShape(QUADS);
    texture(colTex);
    for(float u=0; u<1.0; u+=step) {
      for(float v=0; v<1.0; v+=step) {
        normal(0,0,1);
        vertex(       lo+u*diff,        lo+v*diff, -100,        u*1024,        v*1024);
        vertex(       lo+u*diff, lo+(v+step)*diff, -100,        u*1024, (v+step)*1024);
        vertex(lo+(u+step)*diff, lo+(v+step)*diff, -100, (u+step)*1024, (v+step)*1024);
        vertex(lo+(u+step)*diff,        lo+v*diff, -100, (u+step)*1024,        v*1024);
      }
    }
    endShape();
  }
  else if(mode == 0) {
    beginShape(QUAD);
    texture(colTex);
    normal(0,0,1);
    vertex( 50, 50,0,    0,   0);
    vertex( 50,450,0,    0,1024);
    vertex(450,450,0, 1024,1024);
    vertex(450, 50,0, 1024,   0);
    endShape();
  }
}

void mouseDragged() {
  float diff = mouseX - pmouseX;
  rot += diff/width;
}
