class_name switch_module extends abstract_module

@export var button_obj: Button
@export var label_obj: Label

func set_label(label: String):
	label_obj.text = label

func button_pressed():
	var payload = {"id"= id, "bool"= button_obj.toggle_mode}
	trigger.emit(payload)
