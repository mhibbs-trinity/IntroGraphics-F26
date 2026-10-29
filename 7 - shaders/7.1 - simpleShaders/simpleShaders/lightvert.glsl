#define PROCESSING_LIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec4 lightPosition;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;

void main() {

  //The final position of the vertex after modelview and projection
  gl_Position = transform * vertex;

  //The coordinate/normal of the vertex in eye coordinates (before projection)
  vec3 ecVertex = vec3(modelview * vertex);   
  vec3 ecNormal = normalize(normalMatrix * normal);
  
  //Direction to point light source from the vertex
  vec3 lightDir = normalize(lightPosition.xyz - ecVertex);
  //Diffuse intensity of light from the point light source
  float intense = max(0.0, dot(lightDir, ecNormal));
  
  //Combine the diffuse intensity with the vertex color
  vertColor = vec4(intense, intense, intense, 1.0) * color;
}