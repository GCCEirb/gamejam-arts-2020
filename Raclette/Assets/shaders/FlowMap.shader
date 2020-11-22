shader_type canvas_item;
render_mode unshaded;

uniform sampler2D sFlowMap: hint_aniso;
uniform vec4 cColor : hint_color = vec4(1.);

float remap01(float x, float m_, float _m)
{
	return clamp((x-m_)/(_m-m_), 0., 1.);
}

void flowmap(
	float time,
    float blend_cycle, float cycle_speed,
    float offset,
    vec2 flow, float flow_speed, vec2 flow_scale,
    vec2 base_uv,
    out float blend_factor,
    out vec2 ouv1, out vec2 ouv2)
{
    // Compute cycle, phases
	float half_cycle = blend_cycle * 0.5;

	float phase0 = mod(offset + time * cycle_speed, blend_cycle);
	float phase1 = mod(offset + time * cycle_speed + half_cycle, blend_cycle);

	// Blend factor to mix the two layers
	blend_factor = abs(half_cycle - phase0)/half_cycle;

	// Offset by halfCycle to improve the animation for color (for normalmap not absolutely necessary)
	phase0 -= half_cycle;
	phase1 -= half_cycle;

	// Multiply with scale to make flow speed independent from the uv scaling
	flow *= flow_speed * flow_scale;

	ouv1 = flow * phase0 + base_uv;
	ouv2 = flow * phase1 + base_uv;
}

// Fragment Shader
void fragment()
{
	vec2 ouv1, ouv2;
	float blend_factor;
	vec4 map = texture(sFlowMap, UV);
	
	flowmap(TIME, 1.0, 0.5, 0.,
	    -1.+2.*map.rg, 2.0, vec2(0.01, 0.02),
	    UV,
	    blend_factor, ouv1, ouv2);
	COLOR = cColor*mix(texture(TEXTURE, ouv1), texture(TEXTURE, ouv2), blend_factor);
}