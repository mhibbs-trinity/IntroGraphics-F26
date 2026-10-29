#define PROCESSING_COLOR_SHADER

uniform mat4 transform;

attribute vec4 vertex;
attribute vec4 color;

varying vec4 vertColor;

float map(float x, float oldLo, float oldHi, float newLo, float newHi) {
  return (x - oldLo) / (oldHi - oldLo) * (newHi - newLo) + newLo;
}

void main() {
  gl_Position = transform * vertex;    
  vertColor = vec4(map(vertex.x, -200.0, 200.0, 0.0, 1.0),
                   map(vertex.y, -200.0, 200.0, 0.0, 1.0),
                   map(vertex.z, -200.0, 200.0, 0.0, 1.0), 1.0);
}

