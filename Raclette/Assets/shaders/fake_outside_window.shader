shader_type canvas_item;
render_mode unshaded, blend_mix;

uniform vec3 viewDir;

// Fragment Shader
void fragment()
{
	vec2 offset = viewDir.xy*0.1;
	//offset.x = 1.-offset.x;
	vec2 suv = SCREEN_UV;
	suv.y = 1.-suv.y;
	COLOR = textureLod(TEXTURE, suv+offset, 0.0);
	//COLOR.rg = offset;
	//COLOR.b = 0.;
}