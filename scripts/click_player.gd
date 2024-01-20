extends Node

var click_audio_stream: AudioStreamPlayer

func _ready():
	click_audio_stream = $"/root/click"
	var button_parent = get_parent()
	if(!button_parent.has_signal("pressed")):
		push_error("click_player does not have a parent button")
	button_parent.pressed.connect(click_audio_stream.play)
