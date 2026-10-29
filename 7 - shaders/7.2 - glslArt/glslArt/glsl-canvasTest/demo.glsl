#ifdef GL_ES
precision mediump float;
#endif

//attribute vec4 a_position;
//attribute vec2 a_texture;
uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

float map(float value, float lo1, float hi1, float lo2, float hi2) {
  return lo2 + (value - lo1) * (hi2 - lo2) / (hi1 - lo1);
}
vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
  return a + b * cos(6.28318 * (c * t + d));
}
vec3 customPalette(float t) {
  //vec3 a = vec3(0.5, 0.5, 0.5);
  //vec3 b = vec3(0.5, 0.5, 0.5);
  //vec3 c = vec3(1.0, 1.0, 1.0);
  //vec3 d = vec3(0.0, 0.33, 0.67);

  vec3 a = vec3(-0.012,0.500,0.500);
  vec3 b = vec3(-0.582,-0.392,-0.702);
  vec3 c = vec3(0.658,1.000,1.000);
  vec3 d = vec3(0.087, 0.677, 0.497);
  return palette(t, a, b, c, d);
}

void main() {
  //vec4 pos = a_position;
  vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
  //gl_FragColor = vec4(vec3(0.3765, 0.7882, 0.1686), 1.0);
  float d = length(uv);
  float ogd = d;

  vec3 finalColor = vec3(0.0);
  for(int i=0; i<1; i++) {
    //uv = fract(uv * 1.37) - 0.5;
    //uv = fract(uv * map(u_mouse.x, 0.0,800.0, 1.0,4.0)) - 0.5;
    //uv = fract(uv * 1.5) - 0.5;
    //d = length(uv) * exp(-ogd);

    //Circle pattern
    d = pow(sin(d * 8.0 + u_time), 1.0);

    //Lissajous pattern
    /* Parametric equations are:
      x = a cos (kt)
      y = b sin (kt); t = 0 to 2π
      Solving for t, and plugging in:
      acos(x/a) / k = t
      Pluging in to other equation:
      y = b sin (acos(x/a))
      Solving for zero:
      0 = b sin (acos(x/a)) - y
    */
    d = 0.5 * sin( acos(uv.x / 0.5) + u_time ) - uv.y;
    //d = sin(d);
    d = 1.0*sin(uv.x * 8.0 + u_time)/(uv.x * 8.0);
    
    //float lx = cos(2.2 * uv.x + u_time);
    //float ly = sin(4.0 * uv.y + u_time);
    //d = length(vec2(lx,ly));


    d = abs(d);
    d = 0.02 / d;

    d = uv.x*uv.x + uv.y*uv.y - 1.0;

    d = uv.x*uv.x*uv.x - uv.y * uv.y; //Semicubical parabola


    float a = 0.5 + pow(u_time, 0.25);
    float c = 0.5 + u_time * 0.01;
    d = pow(uv.x*uv.x + uv.y*uv.y, 2.0) - 2.0 * c*c * (uv.x*uv.x - uv.y*uv.y) - (a*a*a*a - c*c*c*c);

    d = sin(d);
    d = abs(d);
    d = 0.05 / d;

    //d *= 0.1;

    //vec3 col = vec3(1.0);
    //vec3 col = vec3(0.2314, 0.7882, 0.1882);
    vec3 col = customPalette(ogd * 0.5 + u_time * 0.5);
    col *= d;

    finalColor += col;
  }

  gl_FragColor = vec4(finalColor, 1.0);
}

