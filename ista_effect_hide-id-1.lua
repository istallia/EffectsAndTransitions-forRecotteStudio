-- HACK:
-- AF_Shaderにすると、VideoObjectにアタッチできなくなる。
-- これはTransitionにすることで回避できるが、
-- Transitionはパラメータを露出させることができない。
-- その為、こちらでShaderの設定をし、TransitionでGetShaderして描画するようにしている。
function GetInfo()
	local info = {
		name = "ISTA_effect_hide-id-1",
		displayname = {
			en = "ISTA_effect_hide-id-1",
			ja = "ISTA_ID隠し(すりガラス)"
		},
		tag = "video",
		-- affects = AF_Shader, 
		shader = {
			ps = "../ista_effect_hide-id-1.cso"
		}
	}
	return info
end
	

function InitEffect()
	SetDuration(2)
	AddProperty(NewProperty("err", {ja="拡散範囲[px]", en="error[px]"},  "int", nil, 5))
	AddProperty(NewProperty("a1_x", {ja="範囲1 X[px]", en="Area1 X[px]"}, "int", nil, 0))
	AddProperty(NewProperty("a1_y", {ja="範囲1 Y[px]", en="Area1 Y[px]"}, "int", nil, 0))
	AddProperty(NewProperty("a1_w", {ja="範囲1 幅[px]", en="Area1 Width[px]"}, "int", nil, 4096))
	AddProperty(NewProperty("a1_h", {ja="範囲1 高さ[px]", en="Area1 Height[px]"}, "int", nil, 2160))
	AddProperty(NewProperty("a2_x", {ja="範囲2 X[px]", en="Area2 X[px]"}, "int", nil, 0))
	AddProperty(NewProperty("a2_y", {ja="範囲2 Y[px]", en="Area2 Y[px]"}, "int", nil, 0))
	AddProperty(NewProperty("a2_w", {ja="範囲2 幅[px]", en="Area2 Width[px]"}, "int", nil, 0))
	AddProperty(NewProperty("a2_h", {ja="範囲2 高さ[px]", en="Area2 Height[px]"}, "int", nil, 0))
	AddProperty(NewProperty("a3_x", {ja="範囲3 X[px]", en="Area3 X[px]"}, "int", nil, 0))
	AddProperty(NewProperty("a3_y", {ja="範囲3 Y[px]", en="Area3 Y[px]"}, "int", nil, 0))
	AddProperty(NewProperty("a3_w", {ja="範囲3 幅[px]", en="Area3 Width[px]"}, "int", nil, 0))
	AddProperty(NewProperty("a3_h", {ja="範囲3 高さ[px]", en="Area3 Height[px]"}, "int", nil, 0))
	AddInOutTimeProperties()
	AddProperty(NewProperty("crop", { ja="ズーム範囲", en="Range"}, "rect", "crop_rate", Rect(0,0,100,100)))
end


function ApplyEffect(effInfo, param)
	local err    = GetProperty("err")
	local a1_x   = GetProperty('a1_x')
	local a1_y   = GetProperty('a1_y')
	local a1_w   = GetProperty('a1_w')
	local a1_h   = GetProperty('a1_h')
	local a2_x   = GetProperty('a2_x')
	local a2_y   = GetProperty('a2_y')
	local a2_w   = GetProperty('a2_w')
	local a2_h   = GetProperty('a2_h')
	local a3_x   = GetProperty('a3_x')
	local a3_y   = GetProperty('a3_y')
	local a3_w   = GetProperty('a3_w')
	local a3_h   = GetProperty('a3_h')
	local screen = param.bounds
	local s_x    = screen.x -- シェーダ内で正規化しなくとも、posがpx単位なので直接比較してやればいいかも？
	local s_y    = screen.y -- でもパラメータが4セットもあると長い、長すぎる
	local s_w    = screen.w
	local s_h    = screen.h
	local a1     = {r=a1_x, g=a1_y, b=a1_w, a=a1_h}
	local a2     = {r=a2_x, g=a2_y, b=a2_w, a=a2_h}
	local a3     = {r=a3_x, g=a3_y, b=a3_w, a=a3_h}
	local a4     = {r=s_x, g=s_y, b=s_w, a=s_h}
	local zoom_a = GetProperty("crop")
	local t      = GetEffectLevelByTimeProperties(effInfo)
	local shader = GetShader("ps")
	SetShaderFloat(shader, 0, err)
	SetShaderFloat(shader, 1, t)
	SetShaderFloat(shader, 2, zoom_a.x*t/100)
	SetShaderFloat(shader, 3, zoom_a.y*t/100)
	SetShaderFloat(shader, 4, (zoom_a.w*t+100*(1-t))/100)
	SetShaderFloat(shader, 5, (zoom_a.h*t+100*(1-t))/100)
	SetShaderColor(shader, 0, a1)
	SetShaderColor(shader, 1, a2)
	SetShaderColor(shader, 2, a3)
	SetShaderColor(shader, 3, a4)
	param.shader = shader
	return param
end
