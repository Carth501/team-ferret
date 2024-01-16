class_name active_error extends Node

signal resolved_error(id: String)

var id: String
var pattern: Array
var step_index: int

func set_id(new_id: String):
	id = new_id

func set_pattern(new_pattern: Array):
	pattern = new_pattern

func connect_to_modules(module_dic: Dictionary):
	for module in pattern:
		var module_instance = module_dic[module]
		module_instance.trigger.connect(pattern_step)

func pattern_step(payload):
	print(str("error ", id, " recieved trigger with payload: ", payload))
	if(payload.id == pattern[step_index]):
		step_index += 1
		if(step_index >= pattern.size()):
			print(str("error ", id, " resolved"))
			resolved_error.emit(id)
			queue_free()
	else:
		step_index = 0
