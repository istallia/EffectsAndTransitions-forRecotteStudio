-- HACK:
-- AF_Shaderにすると、VideoObjectにアタッチできなくなる。
-- これはTransitionにすることで回避できるが、
-- Transitionはパラメータを露出させることができない。
-- その為、こちらでShaderの設定をし、TransitionでGetShaderして描画するようにしている。
function GetInfo()
	local info = {
		name = "ISTA_effect_frosted-glass",
		displayname = {
			en = "ISTA_effect_frosted-glass",
			ja = "ISTA_すりガラス"
		},
		tag = "video",
		-- affects = AF_Shader, 
		shader = {
			ps = "../ISTA_effect_frosted-glass.cso"
		}
	}
	return info
end
	

function InitEffect()
	SetDuration(0.5)
	AddProperty(NewProperty("err", { ja="拡散範囲[px]", en="error[px]"},  "int", nil, 5))
end


function ApplyEffect(effInfo, param)
	local err    = GetProperty("err")
	local rect   = param.bounds
	local n_x    = rect.w
	local n_y    = rect.h
	local shader = GetShader("ps")
	SetShaderFloat(shader, 0, err)
	SetShaderFloat(shader, 1, n_x)
	SetShaderFloat(shader, 2, n_y)
	param.shader = shader
	return param
end
