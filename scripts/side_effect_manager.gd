class_name side_effect_manager extends Node

var cpc_calc : cpc_calculator
var simulation_screen : Node

func set_cpc_calc(new_cpc_calc : cpc_calculator):
	cpc_calc = new_cpc_calc

func set_sim_screen(new_sim_screen : Node):
	simulation_screen = new_sim_screen

func register_side_effects(module : abstract_module):
	var control_def = module.control_def
	if(control_def.has("side_effects")):
		var effects = control_def.side_effects
		if(effects.has("cont_flat_cpc_penalty")):
			module.trigger.connect(cont_flat_cpc_penalty)
		if(effects.has("disabled")):
			module.trigger_with_ref.connect(disabled_effect)

func cont_flat_cpc_penalty(payload : Variant):
	if(!payload.has("side_effects")):
		push_error("trying to trigger side effects when there are none.")
	if(!payload.side_effects.has("cont_flat_cpc_penalty")):
		push_error("trying to trigger the wrong side effect, or something like that.")
	if(!payload.has("value") || payload.value == payload.side_effects.cont_flat_cpc_penalty.value):
		cpc_calc.cpc_cont_const -= payload.side_effects.cont_flat_cpc_penalty.magnitude
	else:
		cpc_calc.cpc_cont_const += payload.side_effects.cont_flat_cpc_penalty.magnitude

func disabled_effect(ref : abstract_module):
	if(!ref.control_def.has("side_effects")):
		push_error("trying to trigger side effects when there are none.")
	var side_effects = ref.control_def.side_effects
	if(!side_effects.has("disabled")):
		push_error("trying to trigger the wrong side effect, or something like that.")
	ref.disable_for(side_effects.disabled.duration)
