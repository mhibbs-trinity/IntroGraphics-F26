#define PROCESSING_TEXLIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;
uniform vec4 lightPosition;

uniform float scale;
uniform float freq;
uniform float time;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;
varying vec2 uv;

const float TWO_PI = 6.2831853;

float func(vec2 p) {                     // p in pixels
  //return sin(p.x * TWO_PI / 133.0);
  return sin(p.x * TWO_PI / freq + time) * cos(p.y * TWO_PI / freq + time*2);
}


void main() {
  
  float EPS = 0.5;
  vec2 p = vertex.xy;
  float ht = scale * func(p);
  vec4 offsetPos = vertex + vec4(normal * ht, 0.0);

  float dhdx = scale * (func(p + vec2(EPS,0.0)) - func(p - vec2(EPS,0.0))) / (2.0*EPS);
  float dhdy = scale * (func(p + vec2(0.0,EPS)) - func(p - vec2(0.0,EPS))) / (2.0*EPS);
  vec3 n = normalize(cross(vec3(1.0, 0.0, dhdx), vec3(0.0, 1.0, dhdy)));

  gl_Position = transform * offsetPos;
  vec3 ecVertex = vec3(modelview * offsetPos);
  uv = (texMatrix * vec4(texCoord, 1.0, 1.0)).xy;
  ecNormal = normalMatrix * n;
  lightDir = normalize(lightPosition.xyz - ecVertex);
  vertColor = color;
}
