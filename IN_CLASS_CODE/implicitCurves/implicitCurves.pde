void setup() {
  size(500,500);
}

void draw() {
  translate(width/2,height/2);
  strokeWeight(10);
  for(int x=-width; x<width; x++) {
    for(int y=-height; y<height; y++) {
      float z = x*x + y*y;
      if(abs(z - 200*200) < 10) {
        point(x,y);
      }
    }
  }
}
