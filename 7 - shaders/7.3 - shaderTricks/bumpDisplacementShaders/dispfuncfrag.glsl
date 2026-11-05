#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER

uniform sampler2D texture;


varying vec4 vertColor;
varying vec2 uv;
varying vec3 ecNormal;
varying vec3 lightDir;

void main() {
  float intensity = max(0.0, dot(lightDir, ecNormal));
  vec4 tintColor = vec4(intensity,intensity,intensity,1.0);
  //gl_FragColor = texture2D(texture, uv) * tintColor;
  gl_FragColor = tintColor;
  //gl_FragColor = vec4(nc.x,nc.y,nc.z,1.0);
  //gl_FragColor = texture2D(texture, vertTexCoord.st) * tintColor;
  //gl_FragColor = vec4(lightDir, 1.0);
  //gl_FragColor = vec4(1.0);
}