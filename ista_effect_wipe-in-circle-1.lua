require "effects/lib"


-- HACK:
-- AF_Shaderにすると、VideoObjectにアタッチできなくなる。
-- これはTransitionにすることで回避できるが、
-- Transitionはパラメータを露出させることができない。
-- その為、こちらでShaderの設定をし、TransitionでGetShaderして描画するようにしている。
function GetInfo()
	local info = {
		name = "ISTA_effect_wipe-in-circle-1",
		displayname = {
			en = "ISTA_effect_wipe-in-circle-1",
			ja = "ISTA_ワイプイン(円形/外側)"
		},
		tag = "in",
		-- affects = AF_Shader, 
		shader = {
			ps = "../ISTA_effect_wipe-in-circle-1.cso"
		}
	};
	return info;
end
	

function InitEffect()
	local label = {

	};

	SetDuration(0.5);
	AddShaderProperty(" ", label);
end


function ApplyEffect(effInfo, param)
	param.shader = SetShaderProperty(" ", param);
	return param;
end
