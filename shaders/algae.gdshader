shader_type canvas_item;

uniform bool debug = false;

const ivec2 MASK = ivec2(~3);

const vec4[] pat = {
  vec4(1, 1, 1, 1),
  vec4(1, 0, 1, 1),
  vec4(1, 1, 1, 1),
  vec4(1, 1, 1, 1),

  vec4(1, 0, 1, 1),
  vec4(1, 1, 1, 1),
  vec4(1, 0, 1, 1),
  vec4(1, 1, 1, 1),

  vec4(1, 0, 1, 1),
  vec4(0, 1, 1, 1),
  vec4(1, 0, 1, 1),
  vec4(1, 1, 1, 1),

  vec4(1, 0, 1, 1),
  vec4(0, 1, 0, 1),
  vec4(1, 0, 1, 1),
  vec4(1, 1, 1, 1),

  vec4(1, 0, 1, 1),
  vec4(0, 0, 0, 1),
  vec4(1, 0, 1, 1),
  vec4(1, 1, 1, 1),

  vec4(0, 1, 0, 1),
  vec4(1, 0, 1, 1),
  vec4(0, 1, 0, 1),
  vec4(1, 1, 1, 1)
};

float random (vec2 st) {
  return fract(sin(dot(st,vec2(12.9898,78.233)))*43758.5453123);
}

void fragment() {
  if (!debug) {
    ivec2 p = ivec2(UV / TEXTURE_PIXEL_SIZE) + ivec2(1, 1);
    vec2 ap = vec2(p & MASK) * TEXTURE_PIXEL_SIZE;
    vec4 c = texture(TEXTURE, ap);
    ivec2 i = p % 4;
    i.y += (p.x / 4) % 2 * 3;
    int idx = -1;
    float r = random(ap);
    if (c.g >= 1.0) {
      float blink = sin(TIME * r * 2.0);
      idx = blink > 0.95 ? 5 : 4;
    } else if (c.g > 0.75) {
      idx = 3;
    } else if (c.g > 0.5) {
      idx = 2;
    } else if (c.g > 0.25) {
      idx = 1;
    } else if (c.g > 0.1) {
      idx = 0;
    }

    if (idx < 0) {
      COLOR = vec4(0.0);
    } else {
      COLOR.rgb = vec3(pat[i.y % 4+ idx * 4][i.x % 4 ]);
      COLOR.a = 1.0;
    }
  }
}
