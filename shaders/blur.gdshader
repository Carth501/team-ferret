shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float lod: hint_range(0.0, 5) = 0.0;

void fragment() {
    vec2 uv = UV;

	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
	color += vec4(0.1, 0.1, 0.1, 1.0);
	COLOR = color;
}
