shader_type canvas_item;

uniform float hlSwitch;

void fragment()
{
	vec2 uv = 2. *  UV - 1.;
	float r = length(uv);
	// 0.3 is a magic number, just guessing to be close to where the collision boundary is
	float val = smoothstep(0.3, 0.35, r);
  	COLOR = (1.0 - hlSwitch) * (1. - val) * vec4(0.4, 0.6, 0.9, 1.0) + (hlSwitch) * (1. - val) * vec4(1., 1., 0., 1.);
}