class_name switch_module
extends abstract_module

@export var button_obj: Button
@export var label_obj: RichTextLabel
@onready var on_switch_tex = $on_switch_tex
@onready var off_switch_tex = $off_switch_tex
var state : bool = false

func set_label(label: String):
	label_obj.clear()
	label_obj.append_text(label)

func button_pressed():
	if(check_latches_unlocked()):
		state = button_obj.button_pressed
		var payload = control_def
		payload["value"] = state
		trigger.emit(payload)
		trigger_with_ref.emit(self)
		toggle_switch()
		click.play()

func get_current_values():
	return {"value"= button_obj.button_pressed}

func set_value(setting: bool):
	state = setting
	button_obj.button_pressed = setting
	toggle_switch()

func toggle_switch():
	if(state):
		on_switch_tex.visible = true
		off_switch_tex.visible = false
	else:
		on_switch_tex.visible = false
		off_switch_tex.visible = true
