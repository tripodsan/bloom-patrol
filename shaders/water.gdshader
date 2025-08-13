shader_type canvas_item;

varying vec2 vx;

const vec4[] pat = {
  vec4(1, 1, 1, 1),
  vec4(0, 0, 0, 1),
  vec4(1, 1, 1, 1),
  vec4(1, 1, 1, 1),

  vec4(1, 1, 1, 1),
  vec4(1, 0, 0, 1),
  vec4(0, 1, 1, 0),
  vec4(1, 1, 1, 1),

  vec4(1, 1, 1, 1),
  vec4(1, 1, 1, 1),
  vec4(0, 0, 0, 0),
  vec4(1, 1, 1, 1)
};

void vertex() {
  vx = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

float random (vec2 st) {
  return fract(sin(dot(st,vec2(12.9898,78.233)))*43758.5453123);
}

void fragment() {
  COLOR.rgba = vec4(1);
  vec2 p = floor(vx / 4.0);
  ivec2 i = ivec2(vx) % 4;
  float r = random(p);
  int sx = int(round(sin(TIME * (r * 2.0 + 1.0)) * 1.1));
  if (r < 0.05) {
    int var = int(r * 100.0) % 3;
    COLOR.rgb = vec3(pat[i.y + var * 4][i.x + sx]);
  }
}
