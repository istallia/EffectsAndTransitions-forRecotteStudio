#include "util.hlsl"

#define PARAM_DEBUG 0

bool between(float x, float2 xw) {
  return (x >= xw.x && x <= xw.x + xw.y);
}

bool in_area(float2 p, float4 xywh) {
  return (between(p.x, xywh.xz) && between(p.y, xywh.yw));
}

float4 main( 
  float4 pos : SV_POSITION, // 正規化されてない
  float2 uv  : UV,
  float2 uvp : UVP
  ) : SV_TARGET
{
  float len     = Float0;
  float time    = Float1;
  float4 zoom_a = float4(Float2, Float3, Float4, Float5);
  float4 bounds = Color3;
  float4 norm   = float4(bounds.z, bounds.w, bounds.z, bounds.w);
  float4 a1     = Color0 / float4(100, 100, 100, 100);
  float4 a2     = Color1 / float4(100, 100, 100, 100);
  float4 a3     = Color2 / float4(100, 100, 100, 100);

  #if PARAM_DEBUG
  float4 dump = dumpParam(p, pos.xy);
  if(dump.a > 0) return dump;
  #endif

  float2 uv2 = uv * zoom_a.zw + zoom_a.xy;

  float4 color = float4(0, 0, 0, 0);
  if(in_area(uv2, a1) || in_area(uv2, a2) || in_area(uv2, a3)) {
    float2 uv3 = (trunc(uv2*norm.xy/float2(len,len)) * float2(len,len) + len/2) / norm.xy;
    color      = tex(uv3);
  } else {
    color = tex(uv2);
  }
  return ApplyBasicParamater(pos, color);
}