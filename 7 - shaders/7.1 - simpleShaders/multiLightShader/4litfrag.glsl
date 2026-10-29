#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

uniform int lightCount;
uniform vec3 lightDiffuse[4];

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 hVector[4];
varying vec3 lightDir[4];

void main() {  
  vec3 normal = normalize(ecNormal);
  vec3 totLightCol = vec3(0.0);
  for(int i=0; i<lightCount; i++) {
  	vec3 direction = normalize(lightDir[i]);
  	vec3 h = normalize(hVector[i]);
  	float intensity = max(0.0, dot(direction, normal));
  	float specular = pow(dot(h, normal), 1000.0);
  	totLightCol += vec3(intensity)*lightDiffuse[i];
  	totLightCol += vec3(specular)*lightDiffuse[i];
  }	
  gl_FragColor = vec4(totLightCol,1.0)*vertColor;
}