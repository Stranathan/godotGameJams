shader_type canvas_item;

varying vec3 testCol;

float when_gt(float x, float y) 
{
  return max(sign(x - y), 0.0);
}
float when_lt(float x, float y)
{
  return max(sign(y - x), 0.0);
}

uniform vec2 squashStretch;

void vertex() 
{
	VERTEX.x +=  (sign(VERTEX.x) * 25. * squashStretch.x) + (-sign(VERTEX.x) * 20. * squashStretch.y);
	testCol = vec3(1., 0., 1.);
	testCol *= when_lt(VERTEX.y, 0);
	VERTEX.y +=  when_lt(VERTEX.y, 0) * (-sign(VERTEX.y) * 25. * squashStretch.x + sign(VERTEX.y) * 50. * squashStretch.y); 
}

void fragment()
{
	vec3 col = vec3(0.2, 0.2, 1.0) + testCol;
	COLOR = vec4(col, 1.0);
}