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
	AddProperty(NewProperty("err", { ja="拡散範囲[px]", en="error[px]"},  "int", nil, 10))
end


function ApplyEffect(effInfo, param)
	local tt     = CurveProp("curve", effInfo.t)
	local err    = GetProperty("err")
	local shader = GetShader("ps")
	SetShaderFloat(shader, 0, err)
	param.shader = shader
	return param
end
