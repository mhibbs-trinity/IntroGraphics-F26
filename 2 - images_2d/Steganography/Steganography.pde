PImage img;
PImage copy;


void settings() {
  //img = loadImage("SundayInPark.jpg");
  img = loadImage("alamo.png");
  //img = loadImage("balloons.png");
  //img = loadImage("city.png");
  //img = loadImage("MTower.jpg");
  //img = loadImage("orion.png");
  //img = loadImage("PearlEarring.jpg");
  //img = loadImage("riverwalk.png");
  //img = loadImage("timon.png");
  //img = loadImage("raft.png");
  //img = loadImage("camera.png");
  //gimg = loadImage("green_bike.jpg");
  //img = loadImage("robotBoy_run.jpg");
  size(img.width,img.height);
}

int offset = 32;

void setup() {
  copy = stegoCreate(img, "HELLO THERE!!! TRINITY CSCI IS THE BEST!!!");
  println(stegoDecode(copy));
}

void draw() {
  background(0);
  if(keyPressed) {
    image(copy, 0,0);
  } else {
    image(img,0,0);
  }  
}

PImage stegoCreate(PImage img, String txt) {
  PImage copy = createImage(img.width, img.height, ARGB);
  img.loadPixels();
  copy.loadPixels();
  
  int charCounter = 0;
  for(int i=0; i<img.pixels.length; i++) {
    color c = img.pixels[i];
    
    char encodeChar = txt.charAt(charCounter);
    charCounter = (charCounter + 1) % txt.length();
    
    int charVal = (int)encodeChar - offset;
    int rlo = (charVal >> 4) & 0x0003;
    int glo = (charVal >> 2) & 0x0003;
    int blo = charVal & 0x0003;
 
    color newColor = color(((int)red(c)   & 0xfffc) + rlo, 
                           ((int)green(c) & 0xfffc) + glo, 
                           ((int)blue(c)  & 0xfffc) + blo);
    copy.pixels[i] = newColor;
  }
  copy.updatePixels();
  return copy;
}

String stegoDecode(PImage img) {
  String result = "";
  img.loadPixels();
  println(img.pixels.length);
  for(int i=0; i<img.pixels.length; i++) {
    color c = img.pixels[i];

    int redLo = ((int)red(c) & 0x0003) << 4;
    int greenLo = ((int)green(c) & 0x0003) << 2;
    int blueLo = ((int)blue(c) & 0x0003);
    
    int charNum = redLo + greenLo + blueLo;
    charNum += offset;
    result += ((char)charNum);
    //if(i%10000 == 0) println(i);
  }
  return result;
}
