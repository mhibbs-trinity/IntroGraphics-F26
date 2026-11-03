#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define INFINITY 1000000.0
#define PI 3.14159265358979
#define EPSILON 0.0001

uniform vec2 u_resolution;
uniform float u_time;
uniform float u_mouse;

/***************** SPHERES *****************/
struct Sphere {
  vec4 pt; //xyz is center point; w is radius
  vec3 col;
};

/* Intersection, normal, and textuer calculation for a sphere */
float iSphere(in vec3 ro, in vec3 rd, in vec4 sph) {
	vec3 oc = ro - sph.xyz;
	float b = 2.0 * dot(oc,rd);
	float c = dot(oc,oc) - sph.w*sph.w;
	float d = b*b - 4.0*c;
	if(d < 0.0) return -1.0;
	//Refraction requires getting "hits" on the sphere on the far
	//side, so both the + and - need to be checked
	float t1 = (-b - sqrt(d)) / 2.0;
	float t2 = (-b + sqrt(d)) / 2.0;
	if(t1 > 0.0)
		if(t2 > 0.0) return min(t1,t2);
		else return t1;
	else if(t2 > 0.0) return t2;
	else return -0.5;
}
vec3 nSphere(in vec3 pos, in vec4 sph) {
	return normalize((pos - sph.xyz) / sph.w);
}
vec2 uvSphere(in vec3 pos, in vec4 sph) {
  vec3 norm = nSphere(pos, sph);
  float v = (asin(norm.y) + PI/2.0) / PI;
  float u = (atan(norm.x, norm.z) + PI) / (2.0 * PI);
  return vec2(u,v);
}


/***************** LIGHTS *****************/

vec3 litPos = vec3(2,2,4);
float diffuseAmt(in vec3 pt, in vec3 norm) {
  return dot(norm, normalize(litPos - pt));
}
float phongAmt(in vec3 pt, in vec3 dir, in vec3 norm, in float shiny) {
  vec3 ref = reflect(normalize(dir), norm);
  return pow(max(0.0,dot(ref, normalize(litPos - pt))), shiny);
}

/***************** SCENE *****************/
const int numSpheres = 1;
Sphere spheres[numSpheres];

float isectAllSpheres(in vec3 ro, in vec3 rd, out int sid) {
  float t = INFINITY;
  sid = -1;
  for(int i=0; i<numSpheres; i++) {
    float ts = iSphere(ro + EPSILON * rd, rd, spheres[i].pt);
    if(ts > 0.0 && ts < t) {
      t = ts;
      sid = i;
    }
  }
  return t;
}

/***************** MAIN *****************/
void main() {
  spheres[0] = Sphere(vec4(0.0,0.0,-1.0, 1.0), vec3(0.8824, 0.0235, 0.0235));
  //spheres[1] = Sphere(vec4(0,-1,-3,2), vec3(0,1,0));

  vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy); //[-1, +1] in window space
  uv /= min(u_resolution.x, u_resolution.y); //[-1, +1] in smallest dimension, square coords


  //Create a ray through this pixel
  vec3 ro = vec3(0.0, 0.0, 4.0);
  vec3 pixPt = vec3(uv.xy, 0.0);
  vec3 rd = normalize(pixPt - ro);

  float tSphere;
  int hitSphereID;
  tSphere = isectAllSpheres(ro, rd, hitSphereID);

  vec3 hitPt = ro + tSphere * rd;
   int id = hitSphereID;

  if(tSphere < INFINITY) {
    float d = length(ro + tSphere * rd);
    vec3 norm = nSphere(ro + tSphere * rd, spheres[0].pt); //Index expression must be constant???
    gl_FragColor = vec4(norm, 1.0);
    return;
  } else {
    vec3 col = vec3(abs(uv.x), abs(uv.y), 0.0);
    gl_FragColor = vec4(1.0);
    //gl_FragColor = vec4(col, 1.0);
    //gl_FragColor = vec4(tSphere / 10000.0, 0.0, 0.0, 1.0);
  }
}

