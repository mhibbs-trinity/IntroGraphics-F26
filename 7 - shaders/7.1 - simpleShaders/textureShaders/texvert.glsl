#define PROCESSING_TEXTURE_SHADER

uniform mat4 transform;
uniform mat4 texMatrix;

attribute vec4 vertex;
attribute vec4 color;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  gl_Position = transform * vertex; //Vertex position after modelview + projection

  //Pass through varyings
  /** Remember: varying values get interpolated across the fragments in the triangle **/
  vertColor = color;
  //Need to transform the texture coordinate to correct for perspective projection
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}