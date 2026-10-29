#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  //Lookup a color from the texture using the interpolated texture coordinates (tinted by the vertex color)
  gl_FragColor = texture2D(texture, vertTexCoord.st) * vertColor;
}