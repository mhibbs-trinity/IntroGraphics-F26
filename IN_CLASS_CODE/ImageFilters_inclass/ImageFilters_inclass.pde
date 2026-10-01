PImage img;
PImage copy;
PImage gimg;
PImage rboy;

PImage[] frames;
float[][] kernel;

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
  
  //gimg = loadImage("green_bike.jpg");
  //gimg = loadImage("green_dude.jpg");
  
  //img = loadImage("robotBoy_run.jpg");
  eimg = createImage(img.width, img.height, ARGB);
  size(img.width,img.height);
}

void setup() {
  img.loadPixels();
  /*
  eimg.loadPixels();
  for(int i=0; i<img.pixels.length; i++) {
    color c = img.pixels[i];
    color newcolor = color(0);
    
    if(red(c) > 128) {
      newcolor = color(255);
    }
    float avg = (red(c) + green(c) + blue(c)) / 3;
    avg = brightness(c);
    copy.pixels[i] = color(avg);
  }
  eimg.updatePixels();
  */
}

void draw() {
  background(0);
  //if(mousePressed) {
  //image(img, 0,0);
  //} else {
  //  image(eimg, 0,0);
  //}
  showPicture(img);
}

void showPicture(PImage img) {
  img.loadPixels();
  loadPixels();
  for(int i=0; i<pixels.length; i++) {
    int x = i % width;
    int y = i / width;
    float d = dist(mouseX,mouseY, x,y);
    if(d < 300) {
      color c = img.pixels[i];
      pixels[i] = color(red(c),green(c),blue(c), map(d, 0,300, 0,255));
      //pixels[i] = img.pixels[i];
    }
  }
  updatePixels();
}
  
  
  
  
  
  
  
  
  
