#define PROCESSING_TEXTURE_SHADER
varying vec4 vertTexCoord;
uniform float time;
uniform float mouseX;

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}
vec3 palette( float t ) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263,0.416,0.557);
    return a + b*cos( 6.28318*(c*t+d) );
}

void main() {
  //Change coordinates into clip space [-1,1]
  vec2 clip = vertTexCoord.xy * 2.0 - 1.0;
  vec2 clipOrig = clip;
  float d = length(clip);
  

  clip = fract(clip * 1);
  clip = clip - 0.5;
  d = length(clip);
  
  float dexp = d * exp(-length(clipOrig));

  float ms = map(mouseX, 0,800, 0.01,10.0);

  float dsin = ms / abs(sin(dexp * 8.0));

  vec3 finalColor = palette(dsin);

  gl_FragColor = vec4(clip.x, clip.y, 0.0, 1.0);
  //gl_FragColor = vec4(dexp,d,d, 1.0);
  //gl_FragColor = vec4(d,dexp,dsin, 1.0);
  //gl_FragColor = vec4(finalColor, 1.0);
  //gl_FragColor = vec4(abs(clip.x),abs(clip.y),d, 1.0);
}


