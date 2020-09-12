#include "util.hlsl"

#define PARAM_DEBUG 0

	float4 main( 
	float4 pos : SV_POSITION, // 正規化されてない
	float2 uv  : UV,
	float2 uvp : UVP
) : SV_TARGET
{
	float min_v = Float0;
	float max_v = Float1;
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
	float4 color2      = rgb2Hsv(color);
	float brightness   = (clamp(color2.z, min_v, max_v) - min_v) * color_gain;
	float2 pattern_pos = asuint(trunc( fmod(uv*pos.xy, float2(4,4)) ));
	float threshold    = pattern[pattern_pos.y][pattern_pos.x];
	if(brightness > threshold) {
		color = WHITE;
	} else {
		color = BLACK;
	}

	return ApplyBasicParamater(pos, color);
}