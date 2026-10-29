#define PROCESSING_COLOR_SHADER

uniform mat4 transform;
attribute vec4 vertex;

float map(float x, float oldLo, float oldHi, float newLo, float newHi) {
  return (x - oldLo) / (oldHi - oldLo) * (newHi - newLo) + newLo;
}

void main() {
  gl_Position = transform * vertex;
}

