#include "util.hlsl"

#define PARAM_DEBUG 0

float maxRGB(float4 color) {
	return max(max(color.r, color.g), color.b);
}
float minRGB(float4 color) {
	return min(min(color.r, color.g), color.b);
}

float4 main( 
	float4 pos : SV_POSITION, // 正規化されてない
	float2 uv  : UV,
	float2 uvp : UVP
) : SV_TARGET
{
	float n_x           = Float1;
	float n_y           = Float2;
	float min_v         = min(max(Float0/100, 0), 1);
	float max_v         = min(max(Float1/100, 0), 1);
	bool use_brightness = (Float2 > 0.5);
	if(max_v < min_v) {
		float tmp = max_v;
		max_v = min_v;
		min_v = tmp;
	}
	float color_gain        = 1 / (max_v - min_v);
	static float4x4 pattern = float4x4(1, 9, 3, 11, 13, 5, 15, 7, 4, 12, 2, 10, 16, 8, 14, 6) / 17;

	#if PARAM_DEBUG
	float4 dump = dumpParam(p, pos.xy);
	if(dump.a > 0) return dump;
	#endif

	float4 color       = tex(uv);
	float lightness    = 0;
	if(use_brightness) {
		lightness = maxRGB(color);
	} else {
		lightness = (maxRGB(color) + minRGB(color)) / 2;
	}
	lightness          = (clamp(lightness, min_v, max_v) - min_v) * color_gain;
	float2 pattern_pos = asuint(trunc( fmod(uv*float2(n_x,n_y), float2(4,4)) ));
	float threshold    = pattern[pattern_pos.y][pattern_pos.x];
	if(lightness > threshold) {
		color = WHITE;
	} else {
		color = BLACK;
	}

	return ApplyBasicParamater(pos, color);
}