shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec3 black:source_color = vec3(0.0);
uniform vec3 white:source_color = vec3(1.0);

void fragment() {
    vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;

    if (c.r < 0.5) {
      COLOR.rgb = black;
    } else {
      COLOR.rgb = white;
    }
}