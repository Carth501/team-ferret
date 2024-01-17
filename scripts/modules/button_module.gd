class_name button_module extends abstract_module

@export var rtl_object: RichTextLabel

func set_label(label: String):
	rtl_object.clear()
	rtl_object.append_text(label)

func button_pressed():
	var payload = {"id"= id}
	trigger.emit(payload)
