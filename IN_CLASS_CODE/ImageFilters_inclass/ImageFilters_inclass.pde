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
  
  copy = createImage(img.width, img.height, RGB);

  size(img.width,img.height);
}

void setup() {
  img.loadPixels();
  copy.loadPixels();
  for(int i=0; i<img.pixels.length; i++) {
    color c = img.pixels[i];
    color newcolor = color(0);
    /*
    if(red(c) > 128) {
      newcolor = color(255);
    }*/
    float avg = (red(c) + green(c) + blue(c)) / 3;
    avg = brightness(c);
    copy.pixels[i] = color(avg);
  }
  copy.updatePixels();

  float amt = 1f/25f;
  float[][] blur5 = {{amt,amt,amt,amt,amt},
                     {amt,amt,amt,amt,amt},
                     {amt,amt,amt,amt,amt},
                     {amt,amt,amt,amt,amt},
                     {amt,amt,amt,amt,amt}};
  amt = 1f/49f;
  float[][] blur7 = {{amt,amt,amt,amt,amt,amt,amt},
                     {amt,amt,amt,amt,amt,amt,amt},
                     {amt,amt,amt,amt,amt,amt,amt},
                     {amt,amt,amt,amt,amt,amt,amt},
                     {amt,amt,amt,amt,amt,amt,amt},
                     {amt,amt,amt,amt,amt,amt,amt},
                     {amt,amt,amt,amt,amt,amt,amt}};
  float[][] diagBlur={{amt,0,0,0,0},
                      {0,amt,0,0,0},
                      {0,0,amt,0,0},
                      {0,0,0,amt,0},
                      {0,0,0,0,amt}};
}

void draw() {
  if(mousePressed) {
    image(img, 0,0);
  } else {
    image(copy, 0,0);
  }
}

PImage convolve(PImage img, float[][] kernel) {
  img.loadPixels();
  PImage modImg = createImage(img.width, img.height, RGB);
  modImg.loadPixels();
  
  /****/
  
  modImg.updatePixels();
  return modImg;
}

PImage greenScreen(PImage img, PImage gimg) {
  PImage copy = createImage(gimg.width,gimg.height,RGB);
  img.loadPixels();
  copy.loadPixels();
  gimg.loadPixels();
  

  copy.updatePixels();
  return copy;
}

void loadRobot() {
  rboy = loadImage("robotBoy_run.png");
  frames = new PImage [16];
  int ctr = 0;
  for(int y=0; y<rboy.height-100; y = y+275) {
    for(int x=0; x<rboy.width-100; x = x+275) {
      if(ctr < 16) {
        frames[ctr] = rboy.get(x,y, 275,275);
        ctr++;
      } 
    }
  }
  frameRate(15);
}