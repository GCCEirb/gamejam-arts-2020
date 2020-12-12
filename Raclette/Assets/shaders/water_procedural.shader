/*******************************************************************************
 * @author: pierre.plans@gmail.com
 *
 * MIT License
 *
 * Copyright (c) 2020 Pierre-Marie Plans
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 ******************************************************************************/
shader_type canvas_item;
render_mode unshaded, blend_mix;

uniform sampler2D sNoise : hint_aniso;
uniform float noiseAmplitude: hint_range(0., 0.1);
uniform float percentHeight: hint_range(0., 1.);
uniform float deformScale: hint_range(0., 1.);
uniform float deformSpeed: hint_range(0., 1.);
uniform vec4 colorDepth: hint_color = vec4(1.);
uniform vec4 colorSurface: hint_color = vec4(1.);
uniform float flowFreq: hint_range(0., 4.);
// Fragment Shader

float remap01(float x, float m_, float _m)
{
	return clamp((x-m_)/(_m-m_), 0., 1.);
}

float horizLine(float a, float b, float s)
{
	return clamp(s*(1.-abs(a-b)), 0., 1.);
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

void fragment()
{
	vec2 uvFlow = SCREEN_UV; uvFlow.y = 1.-uvFlow.y;
	float height = percentHeight;
	float alpha = remap01(UV.y, height, 1.);
	
	float cT = cos(0.1*TIME), sT = sin(deformSpeed*TIME);
	vec2 flowAscension = vec2(cT, deformSpeed*TIME);
	
	vec2 baseNoise = -1.+2.*texture(sNoise,flowFreq*(uvFlow+flowAscension)).rg;
	vec4 bubblesTex = alpha*(-1.+2.*texture(NORMAL_TEXTURE, flowFreq*(uvFlow+flowAscension)).rgba);
	
	float blend_factor;
	vec2 ouv1, ouv2;
	flowmap(TIME, 1.0, 0.5, 0.,
	    -1.+2.*bubblesTex.rg, 2.0, vec2(0.01, 0.02),
	    UV,
	    blend_factor, ouv1, ouv2);
	vec2 bubbles = mix(bubblesTex.rg, bubblesTex.ba, blend_factor);
	
	vec2 offset = alpha*deformScale*(baseNoise+bubbles);
	height = clamp(height+noiseAmplitude*baseNoise.y, 0., 1.);
	alpha = remap01(UV.y, height, 1.);
	vec4 screenTex = textureLod(SCREEN_TEXTURE, SCREEN_UV+offset, 0.0);
	vec4 waterColor = mix(colorSurface, colorDepth, alpha*alpha);
	waterColor *= (alpha>0.?1.:0.);
	COLOR = mix(screenTex, waterColor, max(0.4, alpha)) + colorSurface*remap01(horizLine(UV.y, height, 1.), 0.99, 1.);
}