#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying mat3 normMat;
//varying vec3 ecNormal;
varying vec3 lightDir;

void main() {
  // no normal map here, so just show the amplitude texture (tinted by fill color)
  gl_FragColor = texture2D(texture, vertTexCoord.st) * vertColor;
}