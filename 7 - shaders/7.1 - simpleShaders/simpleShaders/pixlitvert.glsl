#define PROCESSING_LIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec4 lightPosition;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;

void main() {
  gl_Position = transform * vertex; //Vertex position after transform + projection  
  vec3 ecVertex = vec3(modelview * vertex);  //Vertex in eye coordinates (before projection)
  ecNormal = normalize(normalMatrix * normal); 
  lightDir = normalize(lightPosition.xyz - ecVertex);  
  vertColor = color;
}