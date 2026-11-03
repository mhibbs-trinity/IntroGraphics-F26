#define PROCESSING_TEXTURE_SHADER

varying vec2 uv;

uniform float time;
uniform float mouseX;
uniform float mouseY;

uniform int mode;

vec4 palette1( float t ) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263,0.416,0.557);
    return vec4(a + b*cos( 6.28318*(c*t+d) ), 1.0);
}

vec4 palette2( float t ) {
    vec3 a = vec3(-0.012,0.500,0.500);
    vec3 b = vec3(-0.582,-0.392,-0.702);
    vec3 c = vec3(0.658,1.000,1.000);
    vec3 d = vec3(0.087, 0.677, 0.497);
    return vec4(a + b*cos( 6.28318*(c*t+d) ), 1.0);
}

vec4 colorByTexCoord() { // 0
  return vec4(uv, 0.0, 1.0);
}

vec4 colorByFractTexCoord() { // 1
  return vec4(fract(uv * 4), 0.0, 1.0);
}

vec4 colorByDistanceFromOrigin() { // 2
  float dist = length(fract(uv * 4)- vec2(0.5, 0.5));
  return palette1(dist);
}

vec4 colorBySinDistToOrigin() { // 3
  float od = length(uv - vec2(0.5, 0.5));
  float d = distance(fract(uv * 4), vec2(0.5, 0.5));
  //d = sin(d * 10);
  d = abs(sin(d * 10));
  return palette1(d);
}

vec4 colorBySinDistToOriginWithTime() { // 4
  float od = length(uv - vec2(0.5, 0.5));
  float d = distance(fract(uv * 4), vec2(0.5, 0.5));
  d = abs(sin(d * 10 + time));
  return palette1(d);
}

vec4 colorBySinDistToOriginWithTimeAndMouse() { // 5
  float od = length(uv - vec2(0.5, 0.5));
  float d = distance(fract(uv * 4), vec2(0.5, 0.5));
  d = abs(sin(d * 10 * mouseX + time));
  return palette1(d);
}

vec4 colorBySinDistToOriginWithTimeAndMouseShowNeon() { // 6
  float od = length(uv - vec2(0.5, 0.5));
  float d = distance(fract(uv * 4), vec2(0.5, 0.5));
  d = abs(sin(d * 10 + time));
  if(mouseX < 0.5) {
    d = d;
  } else {
    d = 0.05 / d;
  }
  return vec4(d, d, d, 1.0);
}

vec4 colorWithNeon() { // 7
  float od = length(uv - vec2(0.5, 0.5));
  float d = distance(fract(uv * 4), vec2(0.5, 0.5));
  d = abs(sin(d * 10 + time));
  d = 0.05 / d;
  return vec4(d, d, d, 1.0) * palette1(od)g;
}

vec4 colorWithNeonSpread() { // 8
  float od = length(uv - vec2(0.5, 0.5));
  float d = distance(fract(uv * 4), vec2(0.5, 0.5));
  d = d * exp(-od * 4);
  d = abs(sin(d * 10 + time));
  d = 0.05 / d;
  return vec4(d, d, d, 1.0) * palette1(od);
}


void main() {
  if(mode == 0) {
    gl_FragColor = palette1(uv.x+time);
  } else if(mode == 1) {
    gl_FragColor = colorByFractTexCoord();
  } else if(mode == 2) {
    gl_FragColor = colorByDistanceFromOrigin();
  } else if(mode == 3) {
    gl_FragColor = colorBySinDistToOrigin();
  } else if(mode == 4) {
    gl_FragColor = colorBySinDistToOriginWithTime();
  } else if(mode == 5) {
    gl_FragColor = colorBySinDistToOriginWithTimeAndMouse();
  } else if(mode == 6) {
    gl_FragColor = colorBySinDistToOriginWithTimeAndMouseShowNeon();
  } else if(mode == 7) {
    gl_FragColor = colorWithNeon();
  } else if(mode == 8) {
    gl_FragColor = colorWithNeonSpread();
  }
}