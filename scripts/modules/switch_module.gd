class_name switch_module extends abstract_module

@export var button_obj: Button
@export var label_obj: RichTextLabel

func set_label(label: String):
	label_obj.clear()
	label_obj.append_text(label)

func button_pressed():
	var payload = {"id"= id, "bool"= button_obj.toggle_mode}
	trigger.emit(payload)
