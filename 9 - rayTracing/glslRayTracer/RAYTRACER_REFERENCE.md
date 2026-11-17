# GLSL Ray Tracer Incremental Build Reference

This document maps the incremental shader files in `glslRayTracer/` to a recommended learning + implementation sequence. Each stage isolates a new concept (geometry, lighting, materials, sampling, reflections) and introduces the functions and data structures needed.

## File Progression Overview (Existing Examples)
| Stage | File | Focus |
|-------|------|-------|
| 0 | `texCoordsFrag.glsl` | Base fragment shader, confirms texture coordinates (no ray tracing) |
| 1 | `simpleSphere.glsl` | Single sphere intersection, normals, diffuse + Phong specular |
| 2 | `simplePlanes.glsl` | Multiple infinite planes, diffuse + Phong |
| 3 | `sphereAndPlaneShadow.glsl` | One sphere + multiple planes, unified closest hit + hard shadows |
| 4 | `multiSpheresAndPlanes.glsl` | Multiple spheres + planes, ambient term, texture on one sphere |
| 5 | `antialiasedScene.glsl` | Adds per-pixel stochastic supersampling (anti-aliasing) |
| 6 | `reflections.glsl` | Material parameters (diffuse/specular/ambient), single-bounce reflections, light as geometry |

## Recommended Implementation Order (From Scratch)

### 1. Screen-to-Ray Setup
Convert 2D screen coordinates to 3D rays:
```glsl
vec2 uv = vertTexCoord.xy;        // Texture coords [0,1]
vec3 ro = camPos;                 // Ray origin (camera position)
vec3 pixPt = vec3(-1 + 2*uv, 0);  // Map to [-1,1] plane at z=0
vec3 rd = normalize(pixPt - ro);  // Ray direction (unit vector)
```
**Math:** Each pixel defines a point on a virtual screen plane. The ray shoots from the camera through this point into the scene.

### 2. Sphere Intersection (`iSphere`)
**Goal:** Find where a ray intersects a sphere.

**Setup:**
- Ray equation: `P(t) = ro + t·rd`
- Sphere equation: `|P - C|² = r²` where C = center, r = radius

**Derivation:**
Substitute ray into sphere equation:
```
|ro + t·rd - C|² = r²
```
Let `oc = ro - C`:
```
|oc + t·rd|² = r²
(oc + t·rd)·(oc + t·rd) = r²
oc·oc + 2t(oc·rd) + t²(rd·rd) = r²
```
Since `rd` is normalized (`rd·rd = 1`):
```
t² + 2(oc·rd)t + (oc·oc - r²) = 0
```
This is a **quadratic equation** `at² + bt + c = 0`:
- `a = 1`
- `b = 2·dot(oc, rd)`
- `c = dot(oc, oc) - r²`

**Solving:**
```
t = (-b ± √(b² - 4c)) / 2
```
Discriminant `d = b² - 4c`:
- `d < 0`: No intersection (miss)
- `d = 0`: Tangent (1 intersection)
- `d > 0`: Two intersections (entry & exit)

**Implementation:**
```glsl
float iSphere(in vec3 ro, in vec3 rd, in vec4 sph) {
  vec3 oc = ro - sph.xyz;
  float b = 2.0 * dot(oc, rd);
  float c = dot(oc, oc) - sph.w*sph.w;
  float d = b*b - 4.0*c;
  if(d < 0.0) return -1.0;  // No hit
  
  float t1 = (-b - sqrt(d)) / 2.0;  // Closer intersection
  float t2 = (-b + sqrt(d)) / 2.0;  // Farther intersection
  
  if(t1 > 0.0)
    if(t2 > 0.0) return min(t1, t2);  // Both ahead: return closer
    else return t1;                    // Only t1 ahead
  else if(t2 > 0.0) return t2;        // Camera inside sphere
  else return -0.5;                    // Sphere behind camera
}
```
**Returns:** Distance `t` to intersection (negative if no valid hit).

### 3. Surface Normal (`nSphere`)
**Goal:** Calculate the outward-pointing normal vector at a sphere surface point.

**Math:** For a sphere centered at C with radius r, the normal at point P is:
```
N = (P - C) / |P - C|
```
Since `|P - C| = r` for points on the surface:
```
N = (P - C) / r
```

**Implementation:**
```glsl
vec3 nSphere(in vec3 pos, in vec4 sph) {
  return normalize((pos - sph.xyz) / sph.w);
}
```
**Note:** Division by radius before normalization preserves direction. The normalize ensures unit length.

**Debug tip:** Visualize normals as color: `color = norm * 0.5 + 0.5` maps [-1,1] → [0,1].

### 4. Diffuse Lighting (`diffuseAmt`)
**Goal:** Calculate Lambertian (diffuse) reflection based on surface orientation to light.

**Math:** Lambert's cosine law states reflected light intensity is proportional to `cos(θ)` where θ is the angle between the surface normal and light direction:
```
I_diffuse = I_light · max(0, N · L)
```
- `N` = surface normal (unit vector)
- `L` = direction to light source (unit vector)
- `N · L = cos(θ)`

**Implementation:**
```glsl
float diffuseAmt(in vec3 pt, in vec3 norm) {
  return dot(norm, normalize(litPos - pt));
}
```
**Returns:** Value in [-1, 1]. Clamp to [0, 1] when using (negative means light from behind).

**Physical meaning:** Surfaces facing the light receive more photons per area; angled surfaces receive fewer.

### 5. Specular Highlight (`phongAmt`)
**Goal:** Calculate specular reflection (shininess/highlights) using the Phong model.

**Math:** Phong reflection depends on alignment between the reflection vector and view direction:
```
I_specular = I_light · (R · V)^n
```
- `R` = reflection of light direction around normal: `R = reflect(L, N)`
- `V` = direction toward viewer
- `n` = shininess exponent (higher = tighter highlight)

**Reflection vector derivation:**
```
R = 2(N · L)N - L
```
This is GLSL's built-in `reflect()` function.

**Implementation:**
```glsl
float phongAmt(in vec3 pt, in vec3 dir, in vec3 norm, in float shiny) {
  vec3 ref = reflect(normalize(dir), norm);
  return pow(max(0, dot(ref, normalize(litPos - pt))), shiny);
}
```
**Parameters:**
- `dir`: incoming ray direction (viewer → point)
- `shiny`: exponent (10 = broad, 1000 = sharp highlight)

**Note:** `reflect()` expects incident direction (toward surface), so `dir` points from camera to surface.

### 6. UV Mapping for Sphere (`uvSphere`)
**Goal:** Map 3D sphere surface to 2D texture coordinates.

**Math:** Use spherical coordinates (θ, φ):
- φ (latitude): angle from equator, range [-π/2, π/2]
- θ (longitude): angle around poles, range [0, 2π]

From normalized surface normal `(nx, ny, nz)`:
```
φ = asin(ny)              // Latitude from y-component
θ = atan2(nx, nz)         // Longitude from x,z components
u = (θ + π) / (2π)        // Map [−π,π] → [0,1]
v = (φ + π/2) / π         // Map [−π/2,π/2] → [0,1]
```

**Implementation:**
```glsl
vec2 uvSphere(in vec3 pos, in vec4 sph) {
  vec3 norm = nSphere(pos, sph);
  float v = (asin(norm.y) + PI/2.0) / PI;
  float u = (atan(norm.x, norm.z) + PI) / (2.0 * PI);
  return vec2(u, v);
}
```
**Result:** Texture coordinates where u wraps around equator, v goes from pole to pole.

**Pitfall:** Seam at θ = ±π requires careful handling in textures.

### 7. Plane Intersection (`iPlane`)
**Goal:** Find where a ray intersects an infinite plane.

**Setup:**
- Plane equation: `(P - P₀) · N = 0` where P₀ is any point on plane, N is normal
- Ray equation: `P(t) = ro + t·rd`

**Derivation:**
```
(ro + t·rd - P₀) · N = 0
ro·N + t(rd·N) - P₀·N = 0
t(rd·N) = (P₀ - ro)·N
t = (P₀ - ro)·N / (rd·N)
```

**Implementation:**
```glsl
float iPlane(in vec3 ro, in vec3 rd, in vec3 p, in vec3 n) {
  return dot(p - ro, n) / dot(rd, n);
}
```
**Edge cases:**
- `dot(rd, n) ≈ 0`: Ray parallel to plane (no intersection or infinite)
- `t < 0`: Plane behind camera
- Always check `t > 0` before using

**Efficiency:** Single dot product division—much faster than sphere intersection.

### 8. Multiple Planes Array + Loop
Iterate through all planes, track closest positive `t`:
```glsl
float isectAllPlanes(in vec3 ro, in vec3 rd, out int pid) {
  float t = 10000;  // Large initial value
  pid = -1;
  for(int i = 0; i < numPlanes; i++) {
    float tp = iPlane(ro, rd, planes[i].pt, planes[i].norm);
    if(tp > 0 && tp < t) {
      t = tp;
      pid = i;
    }
  }
  return t;
}
```

### 9. Combine Sphere + Planes: Unified Closest-Hit
Call both aggregators, compare distances:
```glsl
float isectAll(in vec3 ro, in vec3 rd, 
               out float hitSphere, out int hitSphereID,
               out float hitPlane, out int hitPlaneID) {
  hitSphere = isectAllSpheres(ro, rd, hitSphereID);
  hitPlane = isectAllPlanes(ro, rd, hitPlaneID);
  if(hitSphereID >= 0 && hitPlaneID >= 0) return min(hitSphere, hitPlane);
  if(hitPlane > 0) return hitPlane;
  return -1;
}
```

### 10. Shadow Ray: Epsilon Offset & Occlusion Test
**Goal:** Determine if a point is in shadow (another object blocks the light).

**Method:**
1. Compute direction to light: `toLight = normalize(litPos - hitPt)`
2. Cast ray from `hitPt` toward light
3. Check if any object intersects before reaching light

**Epsilon offset:** Start ray slightly above surface to avoid self-intersection:
```glsl
vec3 shadowRayOrigin = hitPt + EPSILON * toLight;
float closestT = isectAll(shadowRayOrigin, toLight, ...);
if(closestT < distance(hitPt, litPos)) {
  // Object between surface and light → in shadow
  dif = 0;
  phg = 0;
}
```
**Why EPSILON?** Floating-point precision errors can cause the ray to re-intersect its own surface. A small offset (e.g., 0.0001) prevents this "shadow acne."

### 11-17. Advanced Topics
(Continued with multiple spheres, aggregators, ambient lighting, anti-aliasing, materials, reflections as described in original order...)

11. Multiple spheres array + `isectAllSpheres` helper.
12. Unified aggregator `isectAll` (spheres + planes) returning IDs & distances.
13. Ambient term to prevent total darkness in shadow.
14. Anti-aliasing: jitter rays (random offset in pixel footprint) & average.
15. Material system: per-object diffuse/specular/ambient fractions.
16. Reflection rays (single bounce): use `reflect(rd, normal)`; recursion depth guard.
17. Optional extensions: refraction, fresnel, soft shadows, multi-bounce, BRDF improvements.

## Minimal Viable Ray Tracer (Stage 1)
Required components:
- Ray setup
- `iSphere`
- `nSphere`
- `diffuseAmt`
- Main loop: compute hit, shade diffuse, output color

Pseudocode outline:
```
ro = camPos
rd = normalize(pixPt - ro)
t = iSphere(ro, rd, sphere)
if (t < 0) discard
hitPt = ro + t * rd
norm = nSphere(hitPt, sphere)
color = max(0, diffuseAmt(hitPt, norm)) * sphereColor
```

## Core Functions By Category
Geometry:
- `float iSphere(vec3 ro, vec3 rd, vec4 sph)`
- `vec3 nSphere(vec3 pos, vec4 sph)`
- `vec2 uvSphere(vec3 pos, vec4 sph)` (optional for textures)
- `float iPlane(vec3 ro, vec3 rd, vec3 p, vec3 n)`
- Aggregators: `isectAllSpheres`, `isectAllPlanes`, `isectAll`

Lighting:
- `float diffuseAmt(vec3 pt, vec3 norm)` (Lambert)
- `float phongAmt(vec3 pt, vec3 dir, vec3 norm, float shiny)` (specular)
- Ambient: simple constant added (`ambient * baseColor`)

Sampling / Utilities:
- `rand(vec2 co)` & `withinPixRand(...)` for anti-alias jitter
- `EPSILON` to offset secondary ray origins

Materials (Stage 6):
- Extend `Sphere` / `Plane` with `diffuse`, `specular`, `ambient` floats
- Combine: `color = (dif + ambient) * baseColor + specular * reflectedColor`

Reflections:
- Use `reflect(rd, normal)` to get reflection direction
- Single bounce: call a simpler shading function (`specularRayOne`) for reflected ray to avoid infinite recursion
- Clamp color components to `[0,1]`

## Suggested Simplified Intermediate Variants
- Normals-only visualization: output `(norm * 0.5 + 0.5)` to validate orientation
- Diffuse-only shading: drop specular term early
- No-shadows vs shadows comparison toggle
- Single-object mode (only sphere) before arrays
- Anti-aliasing off (1 sample) vs on (N samples) to see jaggies removal
- Reflection off vs on to show added realism

## Function Dependency Notes
- `uvSphere` depends on `nSphere`
- Shadow test requires all aggregators (`isectAll*`) & light position
- Reflection requires finished shading path for a secondary ray; avoid calling fully recursive function for first experiment
- Anti-aliasing wraps existing `determineColorOfRay` calls; it should not alter intersection logic

## Common Pitfalls & Fixes
- Self-intersection artifacts: add `EPSILON * dir` when launching shadow/reflection rays
- Missing positive root in sphere: ensure you test both `t1`, `t2` and choose smallest > 0
- Plane intersection division by ~0: if `dot(rd, n)` is near zero, treat as no hit
- Specular blowout: clamp result or adjust shininess (start ~10–50) before very high values (1000)
- Shadow acne: increase `EPSILON` slightly if speckling appears
- Performance: keep sample count low (e.g., 8–16) for real-time anti-aliasing

## Verification Strategy Per Stage
1. UV output: gradient matches screen
2. Sphere intersection: discard outside sphere, show solid color
3. Normals: smooth color variation confirming geometry
4. Diffuse: terminator line moves as light moves
5. Specular: highlight appears when view aligns with reflection to light
6. Planes: walls form an enclosed box; normals correct
7. Shadows: hard edge appears where occluded
8. Multiple spheres: proper depth ordering (nearest visible)
9. Anti-aliasing: edges less jagged when sampling increases
10. Reflections: mirrored objects show scene or highlight sphere texture

## Extensibility Ideas (Beyond Current Files)
- Add `Fresnel` term: blend base + reflection using `pow(1 - dot(rd, norm), 5)`
- Soft shadows: sample area light region
- Glossy reflections: perturb reflection direction within a cone
- Refraction: implement Snell’s law + inside/outside checks
- Depth of field: sample rays from aperture disk toward focal plane

## Quick Reference: Data Structures Evolution
- Stage 1: `Sphere { vec4 pt; vec3 col; }`
- Stage 2: `Plane { vec3 pt; vec3 norm; vec3 col; }`
- Stage 4+: Arrays of spheres/planes & unified intersection
- Stage 6: Add material coefficients per object

## Recommended Code Modularization (If Refactoring Later)
- `raySetup(uv, camPos) -> (ro, rd)`
- `closestHit(ro, rd) -> {type, id, t}`
- `surfaceInfo(type, id, ro, rd, t) -> {pt, norm, baseColor, material}`
- `shade(surface, ro, rd) -> color`
- `trace(ro, rd, depth) -> color` (depth-limited recursion for reflections)

## Minimal Version vs Final Version Summary
- Minimal: single object, diffuse only, no shadows, no textures, no recursion, 1 sample
- Final (current max in repo): multi-object, diffuse + specular + ambient, shadows, textures, stochastic AA, single-bounce reflections, materials

Use this roadmap to implement incrementally without getting blocked by advanced features prematurely.
