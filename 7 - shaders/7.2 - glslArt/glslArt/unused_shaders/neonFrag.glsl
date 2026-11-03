#define PROCESSING_TEXTURE_SHADER

uniform float time;
uniform float mouseX;

varying vec4 vertTexCoord; //These are in [0,1]

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

vec3 palette( float t ) {
  /*
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263,0.416,0.557);
  */
    vec3 a = vec3(-0.012,0.500,0.500);
    vec3 b = vec3(-0.582,-0.392,-0.702);
    vec3 c = vec3(0.658,1.000,1.000);
    vec3 d = vec3(0.087, 0.677, 0.497);

    return a + b*cos( 6.28318*(c*t+d) );
}

void main() {
  //Change coordinates into clip space [-1,1]
  vec2 clip = vertTexCoord.xy * 2.0 - 1.0;
  vec2 clipOrig = clip;

  vec3 finalColor = vec3(0.0);

  for(float i = 0.0; i<4.0; i++) {
    //clip = clip * 2.0; 
    //clip = fract(clip * 1.5);
    clip = fract(clip * map(mouseX, 0,800, 1.0,3.0));
    clip = clip - 0.5;

    //Distance to center point
    float d = length(clip);

    d = d * exp(-length(clipOrig));

    d = sin(d * 8.0 + time);
    d = abs(d);

    //d = map(mouseX, 0,800, 1,0.02) / d;
    //d = pow(0.1 / d, 1.2);
    d = 0.05 / d;

    //vec3 col = vec3(1.0, 1.0, 1.0);
    vec3 col = palette(length(clipOrig));// + i * 0.4 + time * 0.4);

    finalColor += col * d;
  }
  gl_FragColor = vec4(finalColor, 1.0);
}
