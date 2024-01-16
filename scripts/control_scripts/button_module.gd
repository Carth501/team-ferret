class_name button_module extends abstract_module

@export var button_object: Button

func set_label(label: String):
	button_object.text = label

func button_pressed():
	var payload = {"id"= id}
	print(str("button_pressed ", payload))
	trigger.emit(payload)
