#define PROCESSING_TEXTURE_SHADER

varying vec2 vertTexCoord;

uniform float time;
uniform float mouseX;
uniform float mouseY;

uniform int mode;

void colorByTexCoord() { // 0
  gl_FragColor = vec4(vertTexCoord, 0.0, 1.0);
}

void colorByFractTexCoord() { // 1
  gl_FragColor = vec4(fract(vertTexCoord * 4), 0.0, 1.0);
}

void colorByDistanceFromOrigin() { // 2
  float dist = length(fract(vertTexCoord * 4)- vec2(0.5, 0.5));
  gl_FragColor = vec4(dist, dist, dist, 1.0);
}

void colorBySinDistToOrigin() { // 3
  float od = length(vertTexCoord - vec2(0.5, 0.5));
  float d = distance(fract(vertTexCoord * 4), vec2(0.5, 0.5));
  //d = sin(d * 10);
  d = abs(sin(d * 10));
  gl_FragColor = vec4(d, d, d, 1.0);
}

void colorBySinDistToOriginWithTime() { // 4
  float od = length(vertTexCoord - vec2(0.5, 0.5));
  float d = distance(fract(vertTexCoord * 4), vec2(0.5, 0.5));
  d = abs(sin(d * 10 + time));
  gl_FragColor = vec4(d, d, d, 1.0);
}

void colorBySinDistToOriginWithTimeAndMouse() { // 5
  float od = length(vertTexCoord - vec2(0.5, 0.5));
  float d = distance(fract(vertTexCoord * 4), vec2(0.5, 0.5));
  d = abs(sin(d * 10 * mouseX + time));
  gl_FragColor = vec4(d, d, d, 1.0);
}

void colorBySinDistToOriginWithTimeAndMouseShowNeon() { // 6
  float od = length(vertTexCoord - vec2(0.5, 0.5));
  float d = distance(fract(vertTexCoord * 4), vec2(0.5, 0.5));
  d = abs(sin(d * 10 + time));
  if(mouseX < 0.5) {
    d = d;
  } else {
    d = 0.05 / d;
  }
  gl_FragColor = vec4(d, d, d, 1.0);
}

void colorWithNeon() { // 7
  float od = length(vertTexCoord - vec2(0.5, 0.5));
  float d = distance(fract(vertTexCoord * 4), vec2(0.5, 0.5));
  d = abs(sin(d * 10 + time));
  d = 0.05 / d;
  gl_FragColor = vec4(d, d, d, 1.0);
}

void colorWithNeonSpread() { // 8
  float od = length(vertTexCoord - vec2(0.5, 0.5));
  float d = distance(fract(vertTexCoord * 4), vec2(0.5, 0.5));
  d = d * exp(-od * 4);
  d = abs(sin(d * 10 + time));
  d = 0.05 / d;
  gl_FragColor = vec4(d, d, d, 1.0);
}


void main() {
  if(mode == 0) {
    colorByTexCoord();
  } else if(mode == 1) {
    colorByFractTexCoord();
  } else if(mode == 2) {
    colorByDistanceFromOrigin();
  } else if(mode == 3) {
    colorBySinDistToOrigin();
  } else if(mode == 4) {
    colorBySinDistToOriginWithTime();
  } else if(mode == 5) {
    colorBySinDistToOriginWithTimeAndMouse();
  } else if(mode == 6) {
    colorBySinDistToOriginWithTimeAndMouseShowNeon();
  } else if(mode == 7) {
    colorWithNeon();
  } else if(mode == 8) {
    colorWithNeonSpread();
  }
}