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
  float err_px  = Float0;
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
    static float2 for_err_uv = float2(3.14, 1.414);
    float2 err_uv            = float2(rand(uv2), rand(reflect(uv2, for_err_uv))) * 2 - 1;
    err_uv                   = err_uv * float2(err_px/norm.x, err_px/norm.y);
    color                    = tex(frac(uv2+err_uv+1));
  } else {
    color = tex(uv2);
  }
  return ApplyBasicParamater(pos, color);
}