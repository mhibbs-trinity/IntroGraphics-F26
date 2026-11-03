#define PROCESSING_TEXTURE_SHADER
varying vec4 vertTexCoord;
uniform float time;
void main() {
  //Change coordinates into clip space [-1,1]
  vec2 clip = vertTexCoord.xy * 2.0 - 1.0;
  float d = length(clip);
  float r = abs(cos(d * time));
  float g = abs(sin(d * time));
  gl_FragColor = vec4(r,g,d, 1.0);
  //gl_FragColor = vec4(abs(sin(d)),abs(cos(d)),d, 1.0);
}


