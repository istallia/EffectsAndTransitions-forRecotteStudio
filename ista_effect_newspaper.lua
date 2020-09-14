-- HACK:
-- AF_Shaderにすると、VideoObjectにアタッチできなくなる。
-- これはTransitionにすることで回避できるが、
-- Transitionはパラメータを露出させることができない。
-- その為、こちらでShaderの設定をし、TransitionでGetShaderして描画するようにしている。
function GetInfo()
	local info = {
		name = "ISTA_effect_newspaper",
		displayname = {
			en = "ISTA_effect_newspaper",
			ja = "ISTA_新聞"
		},
		tag = "video",
		-- affects = AF_Shader, 
		shader = {
			ps = "../ISTA_effect_newspaper.cso"
		}
	}
	return info
end
	

function InitEffect()
	SetDuration(2)
	AddProperty(NewProperty("min_v", { ja="最低の明るさ(0～100)", en="Min Brightness(0～100)"},  "float", nil, 0))
	AddProperty(NewProperty("max_v", { ja="最高の明るさ(0～100)", en="Max Brightness(0～100)"},  "float", nil, 100))
	AddProperty(NewProperty("hsv", {ja="輝度の代わりに明度を使う(1でYes)", en="Use brightness instead of lightness (Yes = 1)"}, "int", nil, 0))
end


function ApplyEffect(effInfo, param)
	local min_v  = GetProperty("min_v")
	local max_v  = GetProperty("max_v")
	local is_hsv = GetProperty("hsv")
	local rect   = param.bounds
	local n_x    = rect.w
	local n_y    = rect.h
	local shader = GetShader("ps")
	SetShaderFloat(shader, 0, min_v)
	SetShaderFloat(shader, 1, max_v)
	SetShaderFloat(shader, 2, is_hsv)
	SetShaderFloat(shader, 3, n_x)
	SetShaderFloat(shader, 4, n_y)
	param.shader = shader
	return param
end
