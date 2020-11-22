shader_type canvas_item;
render_mode unshaded, blend_mix;

uniform sampler2D sNoise : hint_aniso;
uniform float deformScale: hint_range(0., 1.);
// Fragment Shader
void fragment()
{
	vec4 sprite = texture(TEXTURE, UV);
	if(sprite.a<0.1) discard;
	vec2 offset = deformScale*(-1.+2.*texture(sNoise,UV).rg);
	vec4 screenTex = textureLod(SCREEN_TEXTURE, SCREEN_UV+offset, 0.0);
	COLOR = mix(screenTex, sprite, 0.9);
}