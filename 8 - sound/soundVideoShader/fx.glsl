#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

// ---- set automatically by Processing ----
uniform sampler2D texture;     // the video frame being drawn with image()
uniform vec2 texOffset;        // size of one texel of the video texture

// ---- set by the sketch ----
uniform sampler2D prevFrame;   // last frame's output, for feedback trails
uniform sampler2D spectrum;    // N x 1 image, log-spaced FFT bands (low -> high), red = level
uniform sampler2D waveform;    // N x 1 image, raw waveform (0.5 = silence)
uniform vec2 resolution;
uniform float time;
uniform float bass, mid, high, kick;   // music levels, 0..1

// effect toggles (0 or 1)
uniform float fxZoom, fxRipple, fxWave, fxSplit, fxGlitch, fxEdges, fxHue, fxTrails;

varying vec4 vertColor;
varying vec4 vertTexCoord;

// ---------- helpers ----------

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec3 rgb2hsv(vec3 c) {
  vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
  vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
  vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
  float d = q.x - min(q.w, q.y);
  return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + 1e-10)), d / (q.x + 1e-10), q.x);
}

vec3 hsv2rgb(vec3 c) {
  vec3 p = abs(fract(c.xxx + vec3(0.0, 2.0 / 3.0, 1.0 / 3.0)) * 6.0 - 3.0);
  return c.z * clamp(p - 1.0, 0.0, 1.0);
}

float luma(vec2 uv) {
  return dot(texture2D(texture, uv).rgb, vec3(0.299, 0.587, 0.114));
}

// Sobel edge strength of the video around uv
float sobel(vec2 uv) {
  vec2 o = texOffset * 1.5;
  float tl = luma(uv + vec2(-o.x,  o.y)), t = luma(uv + vec2(0.0,  o.y)), tr = luma(uv + vec2(o.x,  o.y));
  float l  = luma(uv + vec2(-o.x, 0.0)),                                  r  = luma(uv + vec2(o.x, 0.0));
  float bl = luma(uv + vec2(-o.x, -o.y)), b = luma(uv + vec2(0.0, -o.y)), br = luma(uv + vec2(o.x, -o.y));
  float gx = (tr + 2.0 * r + br) - (tl + 2.0 * l + bl);
  float gy = (tl + 2.0 * t + tr) - (bl + 2.0 * b + br);
  return length(vec2(gx, gy));
}

// ---------- main ----------

void main() {
  vec2 uv = vertTexCoord.st;
  vec2 center = vec2(0.5);
  vec2 aspect = vec2(resolution.x / resolution.y, 1.0);

  // 1. BASS ZOOM: the image punches in on bass hits
  uv = center + (uv - center) * (1.0 - 0.12 * bass * fxZoom);

  // 2. SPECTRUM RIPPLE: distance from the center picks a frequency band
  //    (low notes near the middle, high notes at the edges); loud bands make the image ripple there
  vec2 d = (uv - center) * aspect;
  float r = length(d);
  float band = texture2D(spectrum, vec2(clamp(r / 0.8, 0.0, 1.0), 0.5)).r;
  float ripple = sin(r * 70.0 - time * 10.0) * band * 0.025 * fxRipple;
  uv += normalize(d + 1e-5) / aspect * ripple;

  // 3. WAVEFORM WOBBLE: each row of pixels slides sideways by one sample of the waveform
  float w = texture2D(waveform, vec2(uv.y, 0.5)).r - 0.5;
  uv.x += w * 0.2 * (0.3 + mid) * fxWave;

  // 5. KICK GLITCH: on kicks, random horizontal bands jump sideways
  float row = floor(uv.y * 30.0);
  float frame = floor(time * 20.0);
  if (hash(vec2(row, frame)) < 0.4 * kick * fxGlitch) {
    uv.x += (hash(vec2(row, frame + 7.0)) - 0.5) * 0.25 * kick;
  }

  // 4. RGB SPLIT: red and blue are sampled at different spots (chromatic aberration)
  vec2 split = (uv - center) * (0.04 * kick + 0.03 * bass) * fxSplit;
  vec3 col;
  col.r = texture2D(texture, uv + split).r;
  col.g = texture2D(texture, uv).g;
  col.b = texture2D(texture, uv - split).b;

  // 6. NEON EDGES: outlines glow brighter with the high frequencies (hi-hats, cymbals)
  if (fxEdges > 0.5) {
    float e = smoothstep(0.15, 0.6, sobel(uv));
    vec3 neon = hsv2rgb(vec3(fract(time * 0.1 + r), 0.8, 1.0));
    col = mix(col * 0.5, col, 1.0 - e) + neon * e * (0.3 + 1.7 * high);
  }

  // 7. HUE SHIFT: colors drift over time and jump with the mids; mids also boost saturation
  if (fxHue > 0.5) {
    vec3 hsv = rgb2hsv(col);
    hsv.x = fract(hsv.x + time * 0.05 + mid * 0.35);
    hsv.y = clamp(hsv.y * (1.0 + 1.5 * mid), 0.0, 1.0);
    col = hsv2rgb(hsv);
  }

  // flash a little brighter on each kick
  col *= 1.0 + 0.5 * kick;

  // 8. FEEDBACK TRAILS: blend in last frame, slightly zoomed and rotated, so bright parts
  //    leave a spiralling tunnel. gl_FragCoord is in the same space as the prevFrame texture.
  if (fxTrails > 0.5) {
    vec2 q = (gl_FragCoord.xy / resolution - center) * aspect;
    float a = 0.02 * (mid - 0.3);
    q = mat2(cos(a), -sin(a), sin(a), cos(a)) * q;
    q *= 0.98 - 0.04 * bass;               // sample closer to the center -> trails stream outward
    q = q / aspect + center;
    vec3 prev = texture2D(prevFrame, q).rgb;
    col = max(col, prev * (0.80 + 0.12 * bass));
  }

  gl_FragColor = vec4(col, 1.0);
}
