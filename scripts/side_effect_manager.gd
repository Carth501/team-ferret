class_name side_effect_manager extends Node

var cpc_calc : cpc_calculator
var simulation_screen : Node
var e_factory : error_factory

func set_cpc_calc(new_cpc_calc : cpc_calculator):
	cpc_calc = new_cpc_calc

func set_sim_screen(new_sim_screen : Node):
	simulation_screen = new_sim_screen

func set_error_factory(new_error_factory : error_factory):
	e_factory = new_error_factory

func register_side_effects(module : abstract_module):
	var control_def = module.control_def
	if(control_def.has("side_effects")):
		var effects = control_def.side_effects
		if(effects.has("cont_flat_cpc_penalty")):
			module.trigger.connect(cont_flat_cpc_penalty)
		if(effects.has("disabled")):
			module.trigger_with_ref.connect(disabled_effect)
		if(effects.has("monitor_reset")):
			module.trigger.connect(monitor_reset)
		if(effects.has("percent_cpc_penalty")):
			module.trigger.connect(percent_cpc_penalty)
		if(effects.has("cause_errors")):
			module.trigger.connect(cause_errors)

func cont_flat_cpc_penalty(payload : Variant):
	if(!payload.has("side_effects")):
		push_error("trying to trigger side effects when there are none.")
	if(!payload.side_effects.has("cont_flat_cpc_penalty")):
		push_error("trying to trigger the wrong side effect, or something like that.")
	if(!payload.has("value") || payload.value == payload.side_effects.cont_flat_cpc_penalty.value):
		cpc_calc.cpc_cont_const -= payload.side_effects.cont_flat_cpc_penalty.magnitude
		cpc_calc.cpc_cont_const = maxi(cpc_calc.cpc_cont_const, 0)
	else:
		cpc_calc.cpc_cont_const += payload.side_effects.cont_flat_cpc_penalty.magnitude

func disabled_effect(ref : abstract_module):
	if(!ref.control_def.has("side_effects")):
		push_error("trying to trigger side effects when there are none.")
	var side_effects = ref.control_def.side_effects
	if(!side_effects.has("disabled")):
		push_error("trying to trigger the wrong side effect, or something like that.")
	ref.disable_for(side_effects.disabled.duration)

func monitor_reset(payload : Variant):
	simulation_screen.visible = false
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = payload.side_effects.monitor_reset.duration
	timer.timeout.connect(monitor_restore)
	timer.start()

func monitor_restore():
	simulation_screen.visible = true

func percent_cpc_penalty(payload : Variant):
	cpc_calc.cpc -= cpc_calc.cpc * payload.side_effects.percent_cpc_penalty.magnitude

func cause_errors(payload : Variant):
	for error_id in payload.side_effects.cause_errors:
		e_factory.create_error_by_id(error_id)
