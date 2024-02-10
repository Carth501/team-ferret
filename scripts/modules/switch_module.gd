class_name switch_module
extends abstract_module

@export var button_obj: Button
@export var label_obj: RichTextLabel
@onready var switch_tex = $switch_tex

func set_label(label: String):
	label_obj.clear()
	label_obj.append_text(label)

func button_pressed():
	var state = button_obj.button_pressed
	var payload = control_def
	payload["value"] = state
	trigger.emit(payload)
	trigger_with_ref.emit(self)
	toggle_switch(state)

func get_current_values():
	return {"value"= button_obj.button_pressed}

func set_value(setting: bool):
	button_obj.button_pressed = setting
	toggle_switch(setting)

func toggle_switch(state: bool) -> void:
	var switch_on = "res://assets/images/modules/switch_on.png"
	var switch_off = "res://assets/images/modules/switch_off.png"
	if(state):
		switch_tex.texture = load(switch_on)
	else:
		switch_tex.texture = load(switch_off)
