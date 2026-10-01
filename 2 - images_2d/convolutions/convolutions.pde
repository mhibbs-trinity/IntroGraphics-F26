PImage img;
PImage gimg;
PImage copy;
PImage rboy;
PImage[] frames;
float[][] kernel;

boolean spotlightOn = false;
boolean circlesOn = false;
boolean robotOn = false;

//MODE determines which filter is applied, can be changed with keys
char filterMode = 'g';

//###### Some Constant Example Kernels ######
float amt = 1f/25f;
float[][] blur5 = {{amt,amt,amt,amt,amt},
                  {amt,amt,amt,amt,amt},
                  {amt,amt,amt,amt,amt},
                  {amt,amt,amt,amt,amt},
                  {amt,amt,amt,amt,amt}};
float am7 = 1f/49f;                  
float[][] blur7 = {{am7,am7,am7,am7,am7,am7,am7},
                  {am7,am7,am7,am7,am7,am7,am7},
                  {am7,am7,am7,am7,am7,am7,am7},
                  {am7,am7,am7,am7,am7,am7,am7},
                  {am7,am7,am7,am7,am7,am7,am7},
                  {am7,am7,am7,am7,am7,am7,am7},
                  {am7,am7,am7,am7,am7,am7,am7}};                  
float amd = 1f/5f;
float[][] diagBlur={{amd,0,0,0,0},
                    {0,amd,0,0,0},
                    {0,0,amd,0,0},
                    {0,0,0,amd,0},
                    {0,0,0,0,amd}};

float[][] horiEdge={{0,0,0,0,0},
                    {0,0,0,0,0},
                    {-1,-1,2,0,0},
                    {0,0,0,0,0},
                    {0,0,0,0,0}};
float[][] vertEdge={{0,0,-1,0,0},
                    {0,0,-1,0,0},
                    {0,0, 4,0,0},
                    {0,0,-1,0,0},
                    {0,0,-1,0,0}};
float[][] lilEdge ={{-1,-1,-1},
                    {-1, 8,-1},
                    {-1,-1,-1}};                    
float[][] bigEdge ={{-1,-1,-1,-1,-1},
                    {-1,-1,-1,-1,-1},
                    {-1,-1,24,-1,-1},
                    {-1,-1,-1,-1,-1},
                    {-1,-1,-1,-1,-1}};
float[][] sharpen ={{-1,-1,-1,-1,-1},
                    {-1,-1,-1,-1,-1},
                    {-1,-1,25,-1,-1},
                    {-1,-1,-1,-1,-1},
                    {-1,-1,-1,-1,-1}};
float[][] emboss2  ={{-1,-1, 0},
                    {-1, 0, 1},
                    { 0, 1, 1}};                    
float[][] emboss  ={{-2,-1, 0},
                    {-1, 1, 1},
                    { 0, 1, 2}};

void updateFilteredCopy() {
  switch(filterMode) {
    case 'b': case 'B':
      copy = convolve(img, blur5); break;
    case 'n': case 'N':
      copy = convolve(img, blur7); break;
    case 'e': case 'E':
      copy = simpleEdge(img); break;
    case 'd': case 'D':
      copy = convolve(img, diagBlur); break;
    case 'g': case 'G':
      copy = grayScale(img); break;
    case 'h': case 'H':
      copy = convolve(img, horiEdge); break;
    case 'v': case 'V':
      copy = convolve(img, vertEdge); break;
    case 'a': case 'A':
      copy = convolve(img, bigEdge); break;  
    case 'l': case 'L':
      copy = convolve(img, sharpen); break;
    case 's': case 'S':
      copy = convolve(img, sharpen); break;
    case 'm':
      copy = convolve(img, emboss); break;
    case 'M':
      copy = convolve(img, emboss2); break;
    default: break;
  }
}

void keyPressed() {
  switch(key) {
    case '1': img = loadImage("SundayInPark.jpg"); break;
    case '2': img = loadImage("alamo.png"); break;
    case '3': img = loadImage("balloons.png"); break;
    case '4': img = loadImage("city.png"); break;
    case '5': img = loadImage("MTower.jpg"); break;
    case '6': img = loadImage("orion.png"); break;
    case '7': img = loadImage("PearlEarring.jpg"); break;
    case '8': img = loadImage("timon.png"); break;
    case '9': img = loadImage("raft.png"); break;
    case '0': img = loadImage("camera.png"); break;
    default: filterMode = key;
  }
  updateFilteredCopy();
}

void settings() {
  img = loadImage("raft.png");
  size(img.width,img.height);
}

void setup() {
  loadRobot();
  //gimg = loadImage("green_bike.jpg");
  gimg = loadImage("green_dude.jpg");
  updateFilteredCopy();
}

PImage convolve(PImage img, float[][] kernel) {
  img.loadPixels();
  PImage modImg = createImage(img.width, img.height, RGB);
  modImg.loadPixels();
  
  int ox = kernel.length/2;
  int oy = kernel[0].length/2;
  
  for(int x=ox; x<img.width-ox; x++) {
    for(int y=oy; y<img.height-oy; y++) {
      float r = 0;
      float g = 0;
      float b = 0;
      for(int kx=0; kx<kernel.length; kx++) {
        for(int ky=0; ky<kernel[0].length; ky++) {
          color c = img.pixels[(y-oy+ky)*img.width + (x-ox+kx)];
          r += red(c)*kernel[kx][ky];
          g += green(c)*kernel[kx][ky];
          b += blue(c)*kernel[kx][ky];
        }
      }
      modImg.pixels[y*img.width+x] = color(bound(r),bound(g),bound(b));
    }
  }
  modImg.updatePixels();
  return modImg;
}

float[][] diagMotionBlur(int sz) {
  float[][] k = new float[sz][sz];
  for(int i=0; i<sz; i++) {
    for(int j=0; j<sz; j++) {
      if(i==j) k[i][j] = 1f/sz;
    }
  }
  return k;
}

float bound(float num) {
  if(num < 0) return 0;
  else if(num > 255) return 255;
  else return num;
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

PImage simpleBlur(PImage img) {
  img.loadPixels();
  PImage modImg = createImage(img.width,img.height,RGB);
  modImg.loadPixels();
  for(int x=1; x<img.width-1; x++) {
    for(int y=1; y<img.height-1; y++) {
      color mid = img.pixels[y*img.width + x];
      color left = img.pixels[y*img.width + x-1];
      color right = img.pixels[y*img.width + x+1];
      color up = img.pixels[(y-1)*img.width + x];
      color down = img.pixels[(y+1)*img.width + x];
      
      modImg.pixels[y*img.width + x] = color(
        (red(mid) + red(left) + red(right) + red(up) + red(down)) / 5,
        (green(mid) + green(left) + green(right) + green(up) + green(down)) / 5,
        (blue(mid) + blue(left) + blue(right) + blue(up) + blue(down)) / 5); 
    }
  }
  modImg.updatePixels();
  return modImg;
}

PImage simpleEdge(PImage img) {
  img.loadPixels();
  PImage modImg = createImage(img.width,img.height,RGB);
  modImg.loadPixels();
  for(int x=1; x<img.width-1; x++) {
    for(int y=1; y<img.height-1; y++) {
      color mid = img.pixels[y*img.width + x];
      color lr = img.pixels[(y+1)*img.width + x+1];
      if(brightness(mid) - brightness(lr) > 20) {
        modImg.pixels[y*img.width + x] = color(255);
      }
    }
  }
  modImg.updatePixels();
  return modImg;
}

PImage greenScreen(PImage img, PImage gimg) {
  PImage copy = createImage(gimg.width,gimg.height,RGB);
  img.loadPixels();
  copy.loadPixels();
  gimg.loadPixels();
  for(int x=0; x<gimg.width; x++) {
    for(int y=0; y<gimg.height; y++) {
      color bgcol = img.pixels[y*img.width + x];
      color gscol = gimg.pixels[y*gimg.width + x];
      if(green(gscol) > red(gscol) && green(gscol) > blue(gscol) && green(gscol) > 100) {
        copy.pixels[y*gimg.width + x] = bgcol;
      } else {
        copy.pixels[y*gimg.width + x] = gscol;
      }
    }
  }
  copy.updatePixels();
  return copy;
}

void randomCircles(PImage img) {
  int x = int(random(width));
  int y = int(random(height));
  img.loadPixels();
  color c = img.pixels[y*width + x];
  fill(c);
  noStroke();
  ellipse(x,y, 20,20);
}

void spotlight(PImage img) {
  img.loadPixels();
  loadPixels();
  for(int x=0; x<width; x++) {
    for(int y=0; y<height; y++) {
      /*
      if(dist(x,y, mouseX,mouseY) < 100) {
        pixels[y*width + x] = img.pixels[y*width + x];
      } else {
        pixels[y*width + x] = color(0);
      }*/
      pixels[y*width + x] = lerpColor(img.pixels[y*width+x], color(0), map(dist(x,y, mouseX,mouseY), 0,200, 0,1));
    }
  }
  updatePixels();
}

PImage rotateColors(PImage img) {
  PImage copy = createImage(img.width,img.height,RGB);
  img.loadPixels();
  copy.loadPixels();
  for(int i=0; i<img.pixels.length; i++) {
    color c = (color)img.pixels[i];
    copy.pixels[i] = color(blue(c), red(c), green(c));
  }
  copy.updatePixels();
  return copy;
}

PImage tintRed(PImage img) {
  PImage copy = createImage(img.width,img.height,RGB);
  img.loadPixels();
  copy.loadPixels();
  for(int i=0; i<img.pixels.length; i++) {
    color c = (color)img.pixels[i];
    copy.pixels[i] = color(red(c)+50, green(c), blue(c));
  }
  copy.updatePixels();
  return copy;
}

PImage grayScale(PImage img) {
  PImage copy = createImage(img.width,img.height,RGB);
  img.loadPixels();
  copy.loadPixels();
  for(int i=0; i<img.pixels.length; i++) {
    color c = (color)img.pixels[i];
    //float avg = (red(c) + blue(c) + green(c)) / 3.0;
    copy.pixels[i] = color(brightness(c));//avg,avg,avg);
  }
  copy.updatePixels();
  return copy;
}

int curr = 0;

void draw() {
  if(circlesOn) {
    for(int i=0; i<50; i++) randomCircles(img);
  } else {
    background(0);
    if(mousePressed) {
      image(img, 0,0);
    } else {
      image(copy,0,0);
    }
  
    if(spotlightOn) {
      spotlight(img);
    }
    
    //Robot animation 
    if(robotOn) {
      image(frames[curr], mouseX,mouseY);
      curr++;
      if(curr >= frames.length) {
        curr = 0;
      }
    }
  }
}
