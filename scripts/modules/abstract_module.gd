class_name abstract_module extends Control

signal trigger(payload)

var id: String

func set_id(new_id: String):
	id = new_id

func get_current_values():
	return {}

func set_value(setting):
	push_error(str(
		"abstract_module set_value called. Attempted to set value to ", setting))
