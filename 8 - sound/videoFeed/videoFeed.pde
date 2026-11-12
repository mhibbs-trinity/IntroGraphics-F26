


//*
import processing.video.*;
// Size of each cell in the grid
int videoScale = 15;
// Number of columns and rows in the system
int cols, rows;
// Variable for capture device
Capture video;

void setup() {
  size(640, 480);
  // Initialize columns and rows
  cols = width / videoScale;
  rows = height / videoScale;
  // Construct the Capture object
  video = new Capture(this, cols, rows);
  video.start();
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(0);
  video.loadPixels();
  
  //for (int i = 0; i < video.width; i++) {
  //  for (int j = 0; j < video.height; j++) {
  //    color c = video.pixels[i + j * video.width];
  //    stroke(c);
  //    point(i,j);
  //  }
  //}
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      color c = video.pixels[i + j * cols];
      fill(c);
      noStroke();
      ellipse(i*videoScale,j*videoScale,videoScale,videoScale);
    }
  }
  
}
//*/


/* Rect/Ellipse for video //

import processing.video.*;
// Size of each cell in the grid
int videoScale = 10;
// Number of columns and rows in the system
int cols, rows;
// Variable for capture device
Capture video;

void setup() {
  size(640, 480);
  // Initialize columns and rows
  cols = width / videoScale;
  rows = height / videoScale;
  // Construct the Capture object
  video = new Capture(this, cols, rows);
  video.start();
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(0);
  video.loadPixels();
  // Begin loop for columns
  for (int i = 0; i < cols; i++) {
    // Begin loop for rows
    for (int j = 0; j < rows; j++) {
      // Where are you, pixel-wise?
      int x = i*videoScale;
      int y = j*videoScale;

      // Reverse the column to mirro the image.
      int loc = (video.width - i - 1) + j * video.width;

      color c = video.pixels[loc];
      // A rectangle's size is calculated as a function of the pixel’s brightness.
      // A bright pixel is a large rectangle, and a dark pixel is a small one.
      float sz = (brightness(c)/255) * videoScale;

      rectMode(CENTER);
      ellipseMode(CENTER);
      fill(255);
      noStroke();
      //rect(x + videoScale/2, y + videoScale/2, sz, sz);
      ellipse(x + videoScale/2, y + videoScale/2, sz, sz);
    }
  }
}
//*/

/* Weird lines from video //
import processing.video.*;
// Two global variables
float x;
float y;

// Variable to hold onto Capture object.
Capture video;

void setup() {
  size(640, 480);
  background(255);
  // Start x and y in the center
  x = width/2;
  y = height/2;
  // Start the capture process
  video = new Capture(this, width, height);
  video.start();
}

void captureEvent(Capture video) {
  // Read image from the camera
  video.read();
}

void draw() {
  video.loadPixels();
  for(int ctr=0; ctr<100; ctr++) {
    float newx = constrain(x + random(-20, 20), 0, width-1);
    float newy = constrain(y + random(-20, 20), 0, height-1);
  
    // Find the midpoint of the line
    int midx = int((newx + x) / 2);
    int midy = int((newy + y) / 2);
    // Pick the color from the video, reversing x
    color c = video.pixels[midx + midy * width];
  
    // Draw a line from (x,y) to (newx,newy)
    stroke(c);
    strokeWeight(4);
    line(x, y, newx, newy);
  
    // Save (newx,newy) in (x,y)
    x = newx;
    y = newy;
  }
}
//*/


/* Simplest video capture/show  //

import processing.video.*;
Capture video;
void setup() {
  size(640,480);
  video = new Capture(this, 640,480);
  video.start();
}
void draw() {
  if(video.available()) {
    video.read();
    image(video,0,0);
  }
}
/*/
