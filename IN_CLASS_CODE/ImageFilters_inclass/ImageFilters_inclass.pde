PImage img;
PImage eimg;

void settings() {
  //img = loadImage("SundayInPark.jpg");
  //img = loadImage("alamo.png");
  //img = loadImage("balloons.png");
  //img = loadImage("city.png");
  //img = loadImage("MTower.jpg");
  //img = loadImage("orion.png");
  //img = loadImage("PearlEarring.jpg");
  //img = loadImage("riverwalk.png");
  //img = loadImage("timon.png");
  img = loadImage("raft.png");
  //img = loadImage("camera.png");
  //img = loadImage("robotBoy_run.jpg");
  eimg = createImage(img.width, img.height, RGB);
  size(img.width,img.height);
}

void setup() {
  img.loadPixels();
  eimg.loadPixels();
  for(int i=0; i<img.pixels.length; i++) {
    color c = img.pixels[i];
    color newcolor = color(0);
    /*
    if(red(c) > 128) {
      newcolor = color(255);
    }*/
    float avg = (red(c) + green(c) + blue(c)) / 3;
    avg = brightness(c);
    eimg.pixels[i] = color(avg);
  }
  eimg.updatePixels();
}

void draw() {
  if(mousePressed) {
    image(img, 0,0);
  } else {
    image(eimg, 0,0);
  }
}
