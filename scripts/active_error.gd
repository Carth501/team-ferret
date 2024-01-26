class_name active_error extends Node

signal resolved_error(id: String)

var id: String
var pattern: Array
var step_index: int
var module_instances: Dictionary = {}
var cubicle_reference: cubicle

func set_id(new_id: String):
	id = new_id

func set_pattern(new_pattern: Array):
	pattern = new_pattern

func connect_to_cubicle(cubicle_instance: cubicle):
	cubicle_reference = cubicle_instance
	resolved_error.connect(cubicle_instance.announce_error_resolved)
	for module in pattern:
		var module_instance = cubicle_instance.module_obj_dic[module.id]
		if(!module_instance.trigger.is_connected(pattern_step)):
			module_instance.trigger.connect(pattern_step)
		module_instances[module.id] = module_instance
	check_next_step()

func pattern_step(payload):
	if(cubicle_reference.paused):
		return
	var next_step = pattern[step_index]
	if(payload.id == next_step.id):
		if(!next_step.has("value") || next_step.value == payload.value):
			increment_step()
	else:
		step_index = 0

func check_next_step():
	var next_step = pattern[step_index]
	var next_module = module_instances[next_step.id]
	var module_setting = next_module.get_current_values()
	if(next_step.has("value") && next_step.value == module_setting.value):
		increment_step()

func increment_step():
	step_index += 1
	if(step_index >= pattern.size()):
		resolved_error.emit(id)
		queue_free()
	else:
		check_next_step()
