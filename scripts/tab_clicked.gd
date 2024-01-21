class_name TabWithClick
extends TabContainer

var click_audio_stream: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	click_audio_stream = $"/root/click"
	if(!has_signal("tab_selected")):
		push_error("This node is not a proper TabBar")
	tab_selected.connect(click_audio_stream.play)
