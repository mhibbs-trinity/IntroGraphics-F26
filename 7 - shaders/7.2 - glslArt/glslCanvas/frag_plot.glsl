#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_TEXTURE_SHADER

varying vec2 vertTexCoord;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec3 threshhold(vec2 st, float limit) {
  float t = step(limit, st.x);
  return vec3(t);
}

vec3 smoothThreshold(vec2 st, float limit) {
  float t = smoothstep(limit-0.25, limit+0.25, st.x);
  return vec3(t);
}


vec3 gradient(vec2 st) {
  float x = st.x;
  return vec3(x);
}

float line(vec2 st) {
  return 1.0 - step(0.01, abs(st.x - st.y));
}

float smoothLine(vec2 st) {
  //smoothstep is like step, but puts a smooth curve instead of a hard edge
  return smoothstep(0.05, 0.0, abs(st.x - st.y)); 
}

float circle(vec2 st, vec2 center, float radius) {
  float d = distance(st, center);
  return step(radius, d) - step(radius+0.01, d);
}

float smoothCircle(vec2 st, vec2 center, float radius) {
  float d = distance(st, center);
  return smoothstep(radius+0.01, radius, d) - 
         smoothstep(radius, radius-0.01, d);
}

float box(vec2 st, vec2 center, vec2 size) {
  vec2 tl = center - size * 0.5;
  vec2 br = center + size * 0.5;
  float inBoxX = step(tl.x, st.x) - step(br.x, st.x);
  float inBoxY = step(tl.y, st.y) - step(br.y, st.y);
  return inBoxX * inBoxY;
}

float smoothBox(vec2 st, vec2 center, vec2 size) {
  vec2 tl = center - size * 0.5;
  vec2 br = center + size * 0.5;
  float inBoxX = smoothstep(tl.x, tl.x + 0.01, st.x) - smoothstep(br.x - 0.01, br.x, st.x);
  float inBoxY = smoothstep(tl.y, tl.y + 0.01, st.y) - smoothstep(br.y - 0.01, br.y, st.y);
  return inBoxX * inBoxY;
}

void main() { 
  vec3 baseColor = vec3(0.0);
  //baseColor = gradient(vertTexCoord);
  //baseColor = threshhold(vertTexCoord, 0.5);
  baseColor = smoothThreshold(vertTexCoord, 0.5);

  float plot = 0.0;
  plot = smoothLine(vertTexCoord);
  //plot = smoothCircle(vertTexCoord, vec2(0.5), 0.3);
  //plot = box(vertTexCoord, vec2(0.5), vec2(0.3,0.3));
  vec3 color = (1.0-plot) * baseColor +
                plot * vec3(1.0,0.0,0.0);

  color = mix(vec3(0.8,0.0,0.4), vec3(0.0,0.4,0.8), plot);
  gl_FragColor = vec4(color,1.0);
}