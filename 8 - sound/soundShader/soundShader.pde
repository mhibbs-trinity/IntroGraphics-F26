import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer song;
String label;

PShader shader;
float rot;

PImage ampImg;
int numSamp = 1024;  // samples per audio buffer (image width)
int segs = 64;       // grid resolution; image has one row per grid row of vertices

void setup() {
  size(500,500, P3D);
  noStroke();
  shader = loadShader("dispfrag.glsl", "dispvert.glsl");
  ampImg = createImage(numSamp, segs+1, RGB);
  ampImg.loadPixels();
  for(int i=0; i<ampImg.pixels.length; i++) { ampImg.pixels[i] = color(128); }
  ampImg.updatePixels();

  minim = new Minim(this);
  //song = minim.loadFile("jane.mp3", numSamp);
  //song = minim.loadFile("felt.mp3", numSamp);
  //song = minim.loadFile("lastofus.mp3", numSamp);
  song = minim.loadFile("16Hz-20kHz-Exp-1f-10sec.mp3", numSamp);
  //song = minim.loadFile("derezzed.mp3", numSamp);
  //song = minim.loadFile("pillow.mp3", numSamp);
  //song = minim.loadFile("taphaniang.mp3", numSamp);
  AudioMetaData meta = song.getMetaData();
  label = meta.title() + " (" + meta.author() + ")"; 
  
  song.play();
}

void draw() {
  background(0); 
  pointLight(255,255,255, mouseX,mouseY,300);
  stroke(255);
  strokeWeight(5);
  point(mouseX,mouseY,300);
  strokeWeight(1);
  
  translate(width/2,height/2,-100);
  rotateY(rot);
  translate(-width/2,-height/2,100);
  
  float[] sla = song.left.toArray();
  ampImg.loadPixels();
  // scroll history down one row (go backwards so we don't overwrite rows before copying them)
  for(int i=ampImg.pixels.length-1; i>=numSamp; i--) {
    ampImg.pixels[i] = ampImg.pixels[i-numSamp];
  }
  // newest samples go in row 0; samples are -1..1
  for(int i=0; i<numSamp; i++) {
    ampImg.pixels[i] = color(map(sla[i], -1,1, 0,255));
  }
  ampImg.updatePixels();

  noStroke();
  fill(255);
  shader(shader);
  shader.set("scale", map(mouseY, 0,height, 0.0,500.0));
  shader.set("htmap", ampImg);

  float lo = 50.0;
  float hi = 450.0;
  float diff = hi-lo;
  float step = 1.0/segs;
  float tw = ampImg.width, th = ampImg.height;
  beginShape(QUADS);
  texture(ampImg);
  for(int i=0; i<segs; i++) {
    for(int j=0; j<segs; j++) {
      float u = i*step, v = j*step;
      normal(0,0,1);
      vertex(       lo+u*diff,        lo+v*diff, -100,        u*tw,        v*th);
      vertex(       lo+u*diff, lo+(v+step)*diff, -100,        u*tw, (v+step)*th);
      vertex(lo+(u+step)*diff, lo+(v+step)*diff, -100, (u+step)*tw, (v+step)*th);
      vertex(lo+(u+step)*diff,        lo+v*diff, -100, (u+step)*tw,        v*th);
    }
  }
  endShape();
}

void mouseDragged() {
  float diff = mouseX - pmouseX;
  rot += diff/width;
}
