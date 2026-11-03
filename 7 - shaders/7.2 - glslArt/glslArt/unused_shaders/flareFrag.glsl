#define PROCESSING_TEXTURE_SHADER
varying vec4 vertTexCoord;
uniform float time;
void main() {
  //Change coordinates into clip space [-1,1]
  vec2 clip = vertTexCoord.xy * 2.0 - 1.0;
  
  vec2 uv = vertTexCoord.xy;

  vec3 c = vec3(0.0);

  vec2 p = uv;
  p -= 0.5;
  
  float z = time;
  
  z += 0.07;

  float d = length(p);
  uv += p / d * (sin(z) + 1.0) * abs(sin(d * 9.0 - z * 2.0));
  c[0] = 0.01 / length(mod(uv, 1.0) - 0.5);

  gl_FragColor = vec4(c / d, time);
}


