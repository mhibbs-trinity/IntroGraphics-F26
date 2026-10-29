#define PROCESSING_TEXTURE_SHADER

varying vec2 vertTexCoord;

void main() {
  gl_FragColor = vec4(vertTexCoord, 0.0, 1.0);
}
