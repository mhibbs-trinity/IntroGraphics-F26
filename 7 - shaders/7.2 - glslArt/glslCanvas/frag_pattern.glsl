#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_TEXTURE_SHADER

varying vec2 vertTexCoord;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


void main() { 
  vec3 baseColor = vec3(0.0);
  vec2 st = fract(vertTexCoord * 4.0);

  float d = distance(st, vec2(0.5));
  d = abs(sin(d * 20.0 + u_time));

  d = 0.05 / d;

  vec3 color = baseColor + d * vec3(0.0, 1.0, 0.0);
  
  gl_FragColor = vec4(color,1.0);
}