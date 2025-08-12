shader_type canvas_item;

uniform bool debug = false;

varying vec2 vx;

const vec4[] pat = {
  vec4(1, 1, 1, 0),
  vec4(0, 0, 0, 0),
  vec4(0, 0, 0, 0),
  vec4(0, 0, 0, 0)
};

void vertex() {
  vx = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

float random (vec2 st) {
  return fract(sin(dot(st,vec2(12.9898,78.233)))*43758.5453123);
}

void fragment() {
  if (!debug) {
    if (COLOR.g > COLOR.b) {
      COLOR.rgba = vec4(1.0);
      if (random(floor(vx)) < 0.03) {
        COLOR.rgb = vec3(0);
      }
    } else if (COLOR.b > COLOR.g) {
      COLOR.rgba = vec4(0);
      vec2 p = floor(vx / 4.0);
      ivec2 i = ivec2(vx) % 4;
      if (random(p) < 0.05) {
        COLOR.rgba = vec4(0.0, 0.0, 0.0, pat[i.y][i.x]);
      }
      //COLOR = texture(water,  tiled_uvs);
    }
  }
}
