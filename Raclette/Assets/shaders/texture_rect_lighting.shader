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
render_mode unshaded;

uniform sampler2D sNormalMap: hint_normal;
uniform float ambient: hint_range(0., 1.) = 0.05;
uniform float specular: hint_range(0., 1.) = 0.0;
uniform vec3 lightDir = vec3(0., 1., 0.);

// Fragment Shader
void fragment()
{
	vec4 normal_mapAndSpecular = texture(sNormalMap, fract(UV));
	vec3 normal = normalize(-1.+2.*normal_mapAndSpecular.xyz);
	vec4 albedo = texture(TEXTURE, fract(UV));
	float lTerm = dot(normalize(lightDir), normal);
	
	COLOR = vec4(clamp((ambient+lTerm)*albedo.rgb+specular*normal_mapAndSpecular.w, 0., 1.), albedo.a);
}