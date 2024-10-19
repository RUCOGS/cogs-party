//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_strength;
uniform float u_speed;
uniform float u_angle;
uniform float u_scale;
uniform float u_time;

float ease_in(float t) {
	return t * t * t;
}

void main() {
	float hue = v_vTexcoord.x * cos(radians(u_angle)) - v_vTexcoord.y * sin(radians(u_angle));
	hue = fract(hue * u_scale + fract(u_time  * u_speed));
	float x = 1. - abs(mod(hue / (1./ 6.), 2.) - 1.);
	vec3 rainbow;
	if(hue < 1./6.){
		rainbow = vec3(1., x, 0.);
	} else if (hue < 1./3.) {
		rainbow = vec3(x, 1., 0);
	} else if (hue < 0.5) {
		rainbow = vec3(0, 1., x);
	} else if (hue < 2./3.) {
		rainbow = vec3(0., x, 1.);
	} else if (hue < 5./6.) {
		rainbow = vec3(x, 0., 1.);
	} else {
		rainbow = vec3(1., 0., x);
	}
	vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);
	float final_strength = ease_in(v_vTexcoord.x) * u_strength;
	gl_FragColor = color + vec4(rainbow, color.a) * final_strength;
}