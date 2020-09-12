#include "util.hlsl"

#define PARAM_DEBUG 0

float4 main( 
  float4 pos : SV_POSITION, // 正規化されてない
  float2 uv  : UV,
  float2 uvp : UVP
  ) : SV_TARGET
{
  float err_px       = Float0;

  #if PARAM_DEBUG
  float4 dump = dumpParam(p, pos.xy);
  if(dump.a > 0) return dump;
  #endif

  static float2 for_err_uv = float2(3.14, 1.414);
  float2 err_uv            = float2(rand(uv), rand(reflect(uv, for_err_uv)));
  err_uv                   = err_uv * float2(err_px/pos.z, err_px/pos.w);
  float4 color             = tex(uv+err_uv);
  return ApplyBasicParamater(pos, color);
}