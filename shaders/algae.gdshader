shader_type canvas_item;


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
  vec4(1, 1, 1, 1)
};

void fragment() {
  ivec2 p = ivec2(UV / TEXTURE_PIXEL_SIZE);
  vec2 ap = vec2(p / 4) * 4.0 * TEXTURE_PIXEL_SIZE;
  vec4 c = texture(TEXTURE, ap);
  ivec2 i = p % 4;
  i.y += (p.x / 4) % 2 * 3;
  if (c.g >= 1.0) {
    COLOR.rgb = vec3(pat[i.x % 4][i.y % 4]);
  } else if (c.g > 0.5) {
    COLOR.rgb = vec3(pat[i.x][i.y]);
  } else {
    COLOR = vec4(0.0);
  }
}
