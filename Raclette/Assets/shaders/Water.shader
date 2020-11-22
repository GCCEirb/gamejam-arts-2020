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