#define PROCESSING_LIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 cameraPosition;

uniform int lightCount;
uniform vec4 lightPosition[4];
uniform vec3 lightDiffuse[4];

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 hVector[4];
varying vec3 lightDir[4];

void main() {
  gl_Position = transform * vertex;    
  vec3 ecVertex = vec3(modelview * vertex);
  vec3 toEye = normalize(cameraPosition - ecVertex);
  ecNormal = normalize(normalMatrix * normal);
  
  for(int i=0; i<lightCount; i++) {
	  lightDir[i] = normalize(lightPosition[i].xyz - ecVertex);  
  	hVector[i] = normalize(lightDir[i] + toEye);
  }
  
  vertColor = color;
}