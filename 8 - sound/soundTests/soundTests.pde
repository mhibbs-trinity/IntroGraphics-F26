import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer song;
FFT fft;

BeatDetect beat;

float eRadius;


void setup()
{
  size(200, 200, P3D);
  minim = new Minim(this);
  //song = minim.loadFile("derezzed.mp3", 1024);
  //song = minim.loadFile("fall.mp3", 1024);
  song = minim.loadFile("taphaniang.mp3", 1024);
  song.play();
  
  // a beat detection object song SOUND_ENERGY mode
  //beat = new BeatDetect();
  
  // a beat detection object song FREQ_ENERGY mode
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  
  ellipseMode(RADIUS);
  eRadius = 20;
}

void draw()
{
  background(0);
  beat.detect(song.mix);
  float a = map(eRadius, 20, 80, 60, 255);
  fill(60, 255, 0, a);
  //SOUND_ENERGY mode
  //if ( beat.isOnset() ) eRadius = 80;
  
  //FREQ_ENERGY mode
  //if( beat.isKick() ) eRadius = 80;
  //if( beat.isSnare() ) eRadius = 80;
  if( beat.isHat() ) eRadius = 80;
  
  ellipse(width/2, height/2, eRadius, eRadius);
  eRadius *= 0.95;
  if ( eRadius < 20 ) eRadius = 20;
}

/*
void setup() {
  size(1024,400);
  minim = new Minim(this);
  //song = minim.loadFile("derezzed.mp3", 1024);
  //song = minim.loadFile("fall.mp3", 1024);
  //song = minim.loadFile("taphaniang.mp3", 1024);
  song = minim.loadFile("16Hz-20kHz-Exp-1f-5sec.mp3", 1024);
  
  song.play();
  
  fft = new FFT(song.bufferSize(), song.sampleRate());
}

void draw() {
  background(0);
  
  fft.forward(song.mix);
  stroke(0,255,0,255);
  float spSz = fft.specSize();
  for(int i=0; i<spSz; i++) {
    float x = map(i, 0,spSz, 0,width);
    line(x, height, x,height-fft.getBand(i)*10);
  }
  
  stroke(255);
  float bufSz = song.bufferSize();
  for(int i=0; i<bufSz-1; i++) {
    line(map(  i, 0,bufSz, 0,width), map(song.mix.get(i),   -1,1, height,0),
         map(i+1, 0,bufSz, 0,width), map(song.mix.get(i+1), -1,1, height,0));
    //line(  i, map(song.mix.get(i),   -1,1, height,0),
    //     i+1, map(song.mix.get(i+1), -1,1, height,0));
  }
}
*/
void stop() {
  song.close();
  minim.stop();
  super.stop();
}
