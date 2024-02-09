class_name abstract_module extends Control

signal trigger(payload)

var id: String
var control_def : Variant
@export var warning : warning_popup 
@export var hover_area : Control 

func set_id(new_id: String):
	id = new_id

func set_control_def(new_control : Variant):
	control_def = new_control
	id = new_control.id
	if(new_control.has("warning_text")):
		warning.set_text(new_control.warning_text)
		hover_area.mouse_entered.connect(warning.show_panel)
		hover_area.mouse_exited.connect(warning.hide_panel)

func get_current_values():
	return {}

func set_value(setting):
	push_error(str(
		"abstract_module set_value called. Attempted to set value to ", setting))
