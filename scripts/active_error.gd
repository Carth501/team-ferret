class_name active_error extends Node

signal resolved_error(id: String)

var id: String
var pattern: Array
var step_index: int

func set_id(new_id: String):
	id = new_id

func set_pattern(new_pattern: Array):
	pattern = new_pattern

func connect_to_cubicle(cubicle_instance: cubicle):
	resolved_error.connect(cubicle_instance.announce_error_resolved)
	for module in pattern:
		var module_instance = cubicle_instance.module_obj_dic[module]
		module_instance.trigger.connect(pattern_step)

func pattern_step(payload):
	if(payload.id == pattern[step_index]):
		step_index += 1
		if(step_index >= pattern.size()):
			resolved_error.emit(id)
			queue_free()
	else:
		step_index = 0
