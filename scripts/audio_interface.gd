class_name audio_interface extends AudioStreamPlayer

@export var group: String

func _ready():
	var buttons: Array = get_tree().get_nodes_in_group(group)
	print(buttons)
	for inst in buttons:
		inst.pressed.connect(on_button_pressed)

func on_button_pressed():
	play()
