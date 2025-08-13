shader_type canvas_item;

uniform bool debug = false;

varying vec2 vx;

const vec4[] pat = {
  vec4(1, 1, 1, 0),
  vec4(0, 0, 0, 0),
  vec4(0, 0, 0, 0),
  vec4(0, 0, 0, 0),
  vec4(0, 1, 1, 0),
  vec4(1, 0, 0, 1),
  vec4(0, 0, 0, 0),
  vec4(0, 0, 0, 0),
  vec4(1, 1, 1, 1),
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
      if (random(floor(vx)) < 0.02) {
        COLOR.rgb = vec3(0);
      }
    } else if (COLOR.rgb == vec3(0.0, 0.0, 1.0)) {
      // water
      COLOR.rgba = vec4(0);
    }
  }
}
