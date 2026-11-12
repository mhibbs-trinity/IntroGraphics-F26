/* Music-reactive video shader
 *
 * The webcam (or a movie) is drawn through a fragment shader (fx.glsl) whose
 * effects are driven by the music:
 *   - bass / mid / high energy from the FFT          -> float uniforms
 *   - kick-drum beats from BeatDetect                 -> float uniform that decays
 *   - the whole spectrum and the raw waveform         -> 1-pixel-tall textures
 *   - the previous output frame (for feedback trails) -> texture (ping-pong buffers)
 *
 * Keys:  1-8 toggle effects (see the HUD),  h = toggle HUD,  space = pause/play
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.video.*;

// ---------- settings ----------
boolean USE_MIC = false;     // true = react to the microphone (live music in the room) instead of a file
boolean MIRROR  = true;      // mirror the webcam like a selfie view

// ---------- audio ----------
Minim minim;
AudioPlayer song;
AudioSource audio;           // either the song or the mic; both have .mix, bufferSize(), sampleRate()
FFT fft;
BeatDetect beat;
int bufSize = 1024;

// smoothed 0..1 levels sent to the shader
float bass, mid, high, kick;
float[] peaks = {1, 1, 1};   // running max of each band, for automatic gain

PImage specImg, waveImg;     // spectrum + waveform, passed to the shader as textures
float[] specSmooth;
float specPeak = 1;

// ---------- video + shader ----------
Capture video;
//Movie video;               // to use a movie file instead, swap these lines and the ones in setup()
PShader fx;
PGraphics prev, curr;        // ping-pong buffers: last frame's output is an input to this frame

String[] fxNames = {"bass zoom", "spectrum ripple", "waveform wobble", "RGB split",
                    "kick glitch", "neon edges", "hue shift", "feedback trails"};
String[] fxUniforms = {"fxZoom", "fxRipple", "fxWave", "fxSplit",
                       "fxGlitch", "fxEdges", "fxHue", "fxTrails"};
boolean[] fxOn = {true, true, false, true, true, false, true, true};
boolean showHUD = true;

void setup() {
  size(960, 720, P2D);

  video = new Capture(this, 640, 480);
  video.start();
  //video = new Movie(this, "myvideo.mp4");   // put the file in this sketch's folder
  //video.loop();

  minim = new Minim(this);
  if (USE_MIC) {
    audio = minim.getLineIn(Minim.STEREO, bufSize);
  } else {
    //song = minim.loadFile("jane.mp3", bufSize);
    //song = minim.loadFile("felt.mp3", bufSize);
    //song = minim.loadFile("lastofus.mp3", bufSize);
    //song = minim.loadFile("16Hz-20kHz-Exp-1f-10sec.mp3", bufSize);  // sweep: watch the ripple ring move outward
    song = minim.loadFile("derezzed.mp3", bufSize);
    //song = minim.loadFile("pillow.mp3", bufSize);
    //song = minim.loadFile("taphaniang.mp3", bufSize);
    song.loop();
    audio = song;
  }

  fft = new FFT(audio.bufferSize(), audio.sampleRate());
  fft.logAverages(30, 8);    // log-spaced bands (8 per octave starting at 30Hz) - closer to how we hear
  beat = new BeatDetect(audio.bufferSize(), audio.sampleRate());
  beat.setSensitivity(250);

  specImg = createImage(fft.avgSize(), 1, RGB);
  waveImg = createImage(audio.bufferSize(), 1, RGB);
  specSmooth = new float[fft.avgSize()];

  fx = loadShader("fx.glsl");  // fragment only; Processing supplies the default texture vertex shader

  prev = createGraphics(width, height, P2D);
  curr = createGraphics(width, height, P2D);
}

void captureEvent(Capture c) { c.read(); }
void movieEvent(Movie m) { m.read(); }

void draw() {
  analyzeAudio();

  // swap buffers: what we drew last frame becomes "prevFrame"
  PGraphics tmp = prev; prev = curr; curr = tmp;

  fx.set("prevFrame", prev);
  fx.set("spectrum", specImg);
  fx.set("waveform", waveImg);
  fx.set("resolution", float(width), float(height));
  fx.set("time", millis() / 1000.0);
  fx.set("bass", bass);
  fx.set("mid", mid);
  fx.set("high", high);
  fx.set("kick", kick);
  for (int i = 0; i < fxUniforms.length; i++) {
    fx.set(fxUniforms[i], fxOn[i] ? 1.0 : 0.0);
  }

  curr.beginDraw();
  curr.background(0);
  if (video.width > 0) {          // camera may take a moment to deliver its first frame
    curr.shader(fx);
    if (MIRROR) {
      curr.translate(width, 0);
      curr.scale(-1, 1);
    }
    curr.image(video, 0, 0, width, height);   // the video becomes the shader's "texture"
  }
  curr.endDraw();

  image(curr, 0, 0);
  if (showHUD) drawHUD();
}

// ---------- audio analysis ----------

void analyzeAudio() {
  fft.forward(audio.mix);
  beat.detect(audio.mix);

  // energy in three frequency ranges (Hz), normalized against their own recent peaks
  bass = follow(bass, level(fft.calcAvg(20, 150), 0));
  mid  = follow(mid,  level(fft.calcAvg(400, 2000), 1));
  high = follow(high, level(fft.calcAvg(4000, 12000), 2));

  // kick jumps to 1 on a beat, then decays
  if (beat.isKick()) kick = 1;
  else kick *= 0.88;

  // spectrum texture: one pixel per log band. Higher bands are tilted up since they're naturally quieter.
  float maxNow = 0;
  for (int i = 0; i < fft.avgSize(); i++) {
    float v = fft.getAvg(i) * (1 + i * 0.08);
    maxNow = max(maxNow, v);
    specSmooth[i] = follow(specSmooth[i], constrain(v / specPeak, 0, 1));
  }
  specPeak = max(1, max(maxNow, specPeak * 0.995));

  specImg.loadPixels();
  for (int i = 0; i < specImg.width; i++) specImg.pixels[i] = color(specSmooth[i] * 255);
  specImg.updatePixels();

  // waveform texture: samples are -1..1, stored as 0..255 (128 = silence)
  waveImg.loadPixels();
  for (int i = 0; i < waveImg.width; i++) {
    waveImg.pixels[i] = color(map(audio.mix.get(i), -1, 1, 0, 255));
  }
  waveImg.updatePixels();
}

// Auto-gain: divide by a slowly-decaying peak so quiet and loud songs both use the full 0..1 range,
// then cut off the bottom 30% so the effects pulse instead of sitting at a constant level.
float level(float raw, int which) {
  peaks[which] = max(1, max(raw, peaks[which] * 0.995));
  return constrain((raw / peaks[which] - 0.3) / 0.7, 0, 1);
}

// Fast attack, slow release: jump up quickly on hits, fall back smoothly.
float follow(float current, float target) {
  return lerp(current, target, target > current ? 0.6 : 0.08);
}

// ---------- HUD ----------

void drawHUD() {
  resetShader();
  noStroke();
  fill(0, 150);
  rect(10, 10, 230, 230, 6);

  fill(255);
  textSize(13);
  for (int i = 0; i < fxNames.length; i++) {
    fill(fxOn[i] ? color(120, 255, 160) : color(140));
    text((i + 1) + "  " + fxNames[i], 20, 32 + i * 18);
  }

  // level meters
  String[] lbl = {"bass", "mid", "high", "kick"};
  float[] val = {bass, mid, high, kick};
  for (int i = 0; i < 4; i++) {
    fill(200);
    text(lbl[i], 20, 190 + (i / 2) * 22);
    fill(255, 120, 60);
    rect(60 + (i % 2) * 90, 180 + (i / 2) * 22, 60 * val[i], 10);
  }
  fill(200);
  if (isPaused()) text("[paused]", 170, 232);

  // spectrum bars along the bottom
  float bw = (float) width / specSmooth.length;
  for (int i = 0; i < specSmooth.length; i++) {
    fill(lerpColor(color(60, 120, 255), color(255, 60, 160), (float) i / specSmooth.length), 180);
    float h = specSmooth[i] * 80;
    rect(i * bw, height - h, bw - 1, h);
  }
}

boolean isPaused() { return song != null && !song.isPlaying(); }

void keyPressed() {
  if (key >= '1' && key <= '8') fxOn[key - '1'] = !fxOn[key - '1'];
  if (key == 'h') showHUD = !showHUD;
  if (key == ' ' && song != null) {
    if (song.isPlaying()) song.pause(); else song.loop();
  }
}
