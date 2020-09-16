-- HACK:
-- AF_Shaderにすると、VideoObjectにアタッチできなくなる。
-- これはTransitionにすることで回避できるが、
-- Transitionはパラメータを露出させることができない。
-- その為、こちらでShaderの設定をし、TransitionでGetShaderして描画するようにしている。
function GetInfo()
	local info = {
		name = "ISTA_effect_hide-id-2",
		displayname = {
			en = "ISTA_effect_hide-id-2",
			ja = "ISTA_ID隠し(モザイク)"
		},
		tag = "video",
		-- affects = AF_Shader, 
		shader = {
			ps = "../ista_effect_hide-id-2.cso"
		}
	}
	return info
end
	

function InitEffect()
	SetDuration(2)
	AddProperty(NewProperty("err", {ja="粗さ[px]", en="error[px]"},  "int", nil, 4))
	-- AddProperty(NewProperty("a1_x", {ja="範囲1 X[px]", en="Area1 X[px]"}, "int", nil, 0))
	-- AddProperty(NewProperty("a1_y", {ja="範囲1 Y[px]", en="Area1 Y[px]"}, "int", nil, 0))
	-- AddProperty(NewProperty("a1_w", {ja="範囲1 幅[px]", en="Area1 Width[px]"}, "int", nil, 4096))
	-- AddProperty(NewProperty("a1_h", {ja="範囲1 高さ[px]", en="Area1 Height[px]"}, "int", nil, 2160))
	-- AddProperty(NewProperty("a2_x", {ja="範囲2 X[px]", en="Area2 X[px]"}, "int", nil, 0))
	-- AddProperty(NewProperty("a2_y", {ja="範囲2 Y[px]", en="Area2 Y[px]"}, "int", nil, 0))
	-- AddProperty(NewProperty("a2_w", {ja="範囲2 幅[px]", en="Area2 Width[px]"}, "int", nil, 0))
	-- AddProperty(NewProperty("a2_h", {ja="範囲2 高さ[px]", en="Area2 Height[px]"}, "int", nil, 0))
	-- AddProperty(NewProperty("a3_x", {ja="範囲3 X[px]", en="Area3 X[px]"}, "int", nil, 0))
	-- AddProperty(NewProperty("a3_y", {ja="範囲3 Y[px]", en="Area3 Y[px]"}, "int", nil, 0))
	-- AddProperty(NewProperty("a3_w", {ja="範囲3 幅[px]", en="Area3 Width[px]"}, "int", nil, 0))
	-- AddProperty(NewProperty("a3_h", {ja="範囲3 高さ[px]", en="Area3 Height[px]"}, "int", nil, 0))
	AddProperty(NewProperty("area_1", { ja="範囲1", en="Area1"}, "rect", "crop_rate", Rect(0,0,100,100)))
	AddProperty(NewProperty("area_2", { ja="範囲2", en="Area2"}, "rect", "crop_rate", Rect(-1,-1,100,100)))
	AddProperty(NewProperty("area_3", { ja="範囲3", en="Area3"}, "rect", "crop_rate", Rect(-1,-1,100,100)))
	AddInOutTimeProperties()
	AddProperty(NewProperty("crop", { ja="ズーム範囲", en="Range"}, "rect", "crop_rate", Rect(0,0,100,100)))
end


function ApplyEffect(effInfo, param)
	local err    = GetProperty("err")
	local screen = param.bounds
	local s_x    = screen.x -- シェーダ内で正規化しなくとも、posがpx単位なので直接比較してやればいいかも？
	local s_y    = screen.y -- でもパラメータが4セットもあると長い、長すぎる
	local s_w    = screen.w
	local s_h    = screen.h
	local a1     = GetProperty("area_1")
	local a2     = GetProperty("area_2")
	local a3     = GetProperty("area_3")
	if a1.x + a1.y < 0 then
		a1 = {x=0, y=0, w=0, h=0}
	end
	if a2.x + a2.y < 0 then
		a2 = {x=0, y=0, w=0, h=0}
	end
	if a3.x + a3.y < 0 then
		a3 = {x=0, y=0, w=0, h=0}
	end
	a1           = {r=a1.x, g=a1.y, b=a1.w, a=a1.h}
	a2           = {r=a2.x, g=a2.y, b=a2.w, a=a2.h}
	a3           = {r=a3.x, g=a3.y, b=a3.w, a=a3.h}
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
