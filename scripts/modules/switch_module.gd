class_name switch_module extends abstract_module

@export var button_obj: Button
@export var label_obj: RichTextLabel

func set_label(label: String):
	label_obj.clear()
	label_obj.append_text(label)

func button_pressed():
	var payload = {"id"= id, "value"= button_obj.button_pressed}
	trigger.emit(payload)

func get_current_values():
	return {"value"= button_obj.button_pressed}
