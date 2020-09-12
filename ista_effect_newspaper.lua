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
	SetDuration(0.5)
	AddProperty(NewProperty("min_v", { ja="最低の明るさ(0～1)", en="Min Brightness(0～1)"},  "float", nil, 0))
	AddProperty(NewProperty("max_v", { ja="最高の明るさ(0～1)", en="Max Brightness(0～1)"},  "float", nil, 1))
end


function ApplyEffect(effInfo, param)
	local min_v  = GetProperty("min_v")
	local max_v  = GetProperty("max_v")
	local shader = GetShader("ps")
	SetShaderFloat(shader, 0, min_v)
	SetShaderFloat(shader, 1, max_v)
	param.shader = shader
	return param
end
