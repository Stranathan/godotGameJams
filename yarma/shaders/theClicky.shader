shader_type canvas_item;

uniform vec2 c1;
uniform vec2 c2;
uniform vec2 c3;
uniform vec2 scale;

float smin( float a, float b, float k )
{
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return mix( b, a, h ) - k*h*(1.0-h);
}

float when_gt(float x, float y)
{
	return max(sign(x - y), 0.0);
}

float when_lt(float x, float y)
{
	return max(sign(y - x), 0.0);
}

void fragment()
{
	// 1. / SCREEN_PIXEL_SIZE --> resolution
	vec2 uv = 2. * UV - 1.;//(1. / SCREEN_PIXEL_SIZE) * vec2(1. / 1024., 1. / 600.);
	
	// scale is coming from theClicky parent
	uv.x *= scale.x / scale.y;
	
	vec2 clickyPos = c1 / 32.0;
	vec2 clicky2Pos = c2 / 32.0;
	vec2 clicky3Pos = c3 / 32.0;
	
	clickyPos.x *= scale.x / scale.y;
	clicky2Pos.x *= scale.x / scale.y;
	clicky3Pos.x *= scale.x / scale.y;
	
	float len = length(uv - clickyPos);
	float len2 = length(uv - clicky2Pos);
	float len3 = length(uv - clicky3Pos);
	
	float sm = smin(len, len2, 0.5);
	sm = smin(sm, len3, 0.5);
	
	float theVal = smoothstep(0.08, 0.085, sm);
	
	vec3 col = vec3(theVal);
	COLOR = vec4(col, when_lt(theVal, 1.0)); //vec4(vec3(val), 1.);
}