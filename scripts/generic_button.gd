class_name generic_button extends Button

signal button_press(string: String)
var string: String

func set_string(new_string: String):
	string = new_string
	pressed.connect(emit_string)

func set_label(string_name: String):
	text = string_name

func emit_string():
	button_press.emit(string)
