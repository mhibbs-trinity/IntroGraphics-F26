#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define INFINITY 1000000.0
#define PI 3.14159265358979
#define EPSILON 0.0001

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

float map(float value, float lo1, float hi1, float lo2, float hi2) {
  return lo2 + (value - lo1) * (hi2 - lo2) / (hi1 - lo1);
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
  vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy); //[-1, +1] in window space
  uv /= min(u_resolution.x, u_resolution.y); //[-1, +1] in smallest dimension, square coords

  vec2 oguv = uv; //store the original uv before any fractals
/*
  vec3 finalColor = vec3(0.0);
  for(int ctr=0; ctr<2; ctr++) {
    //uv = fract(uv * 1.37) - 0.5;
    //uv = fract(uv * map(u_mouse.x, 0.0,800.0, 1.0,4.0)) - 0.5;
    uv = fract(uv * 2.5) * 2.0 - 1.0;

    uv *= exp(-length(oguv));

    float f = 0.0;

    //** Circle equation **
    f = uv.x*uv.x + uv.y*uv.y - 0.25;

    //** Cassini Ovals **
    float a = 0.9;//0.5 + pow(u_time, 0.25);
    float c = 0.3;//0.5 + u_time * 0.01;
    f = pow(uv.x*uv.x + uv.y*uv.y, 2.0) - 2.0 * c*c * (uv.x*uv.x - uv.y*uv.y) - (a*a*a*a - c*c*c*c);

    //** 6-petaled flower **
    //f = pow(3.0*uv.x*uv.x - uv.y*uv.y, 2.0) * uv.y*uv.y - pow(uv.x*uv.x + uv.y*uv.y, 4.0);
    
    
    f *= 8.0;
    f = sin(f + u_time);
    f = abs(f);
    f = 0.1 / f;

    vec3 col = palette(length(uv) * length(oguv));

    finalColor += f * vec3(col);
  } 
  gl_FragColor = vec4(finalColor, 1.0);
  */

  float d = length(uv);
  float z = u_time;
  //uv += uv / d *(sin(z) + 1.0) * abs(sin(d * 9.0 - z * 2.0));
  vec2 uvd = uv / d;

  //uv = uvd;
  //uv = uv + uvd;
  uv *= sin(u_time);// + 1.0;
  uv *= abs(sin(length(uv) * 9.0 - u_time * 2.0));

  d = length(uv);
  d = 0.1 / d;

  //uv += uv / d * map(u_mouse.x, 0.0,u_resolution.x, -1.0,1.0);

  vec3 endcol = vec3(d);
  gl_FragColor = vec4(endcol, 1.0);


}

