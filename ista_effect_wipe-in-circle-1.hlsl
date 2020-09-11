#include "util.hlsl"

#define PARAM_DEBUG 0

float4 main( 
   float4 pos : SV_POSITION, // 正規化されてない
   float2 uv : UV,
   float2 uvp : UVP
   ) : SV_TARGET
{
    float2 objectSize  = float2(Float1, Float2);
    float effTime      = Float0;
    float screenWidth  = objectSize.x;
    float screenHeight = objectSize.y;
    float maxRadius    = max(screenWidth, screenHeight) * 0.707;
    float targetRadius = maxRadius * effTime;
    float ratio        = screenWidth / screenHeight;

    #if PARAM_DEBUG
    float4 dump = dumpParam(p, pos.xy);
    if(dump.a > 0) return dump;
    #endif

    float4 color = tex(uv);
    float2 pos2  = (uv - 0.5) * objectSize.xy;
    float radius = length(pos2);
    if(radius > targetRadius) {
      color.a = 0;
    }
    return ApplyBasicParamater(pos, color);
}