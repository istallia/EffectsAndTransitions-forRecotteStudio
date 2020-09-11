-- HACK:
-- AF_Shaderにすると、VideoObjectにアタッチできなくなる。
-- これはTransitionにすることで回避できるが、
-- Transitionはパラメータを露出させることができない。
-- その為、こちらでShaderの設定をし、TransitionでGetShaderして描画するようにしている。
function GetInfo()
	local info = {
		name = "ISTA_effect_wipe-in-circle-2",
		displayname = {
			en = "ISTA_effect_wipe-in-circle-2",
			ja = "ISTA_ワイプイン(円形/内側)"
		},
		tag = "in",
		-- affects = AF_Shader, 
		shader = {
			ps = "../ISTA_effect_wipe-in-circle-2.cso"
		}
	}
	return info
end
	

function InitEffect()
	SetDuration(0.5)
	AddProperty(NewProperty("curve", { ja="時間曲線", en="TimeCurve"},  "curve"))
end


function ApplyEffect(effInfo, param)
	local tt     = CurveProp("curve", effInfo.t)
	local rect   = param.bounds
	local shader = GetShader("ps")
	SetShaderFloat(shader, 0, 1 - tt)
	SetShaderFloat(shader, 1, rect.w)
	SetShaderFloat(shader, 2, rect.h)
	param.shader = shader
	return param
end
