shader_type canvas_item;
render_mode unshaded, blend_mix;

// Fragment Shader
void fragment()
{
	vec2 offset = vec2(0.);
	vec2 suv = SCREEN_UV;
	suv.y = 1.-suv.y;
	COLOR = textureLod(TEXTURE, suv+offset, 0.0);
}