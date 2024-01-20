class_name audio_interface extends AudioStreamPlayer

@onready var audio_cont: audio_continuity = get_node("/root/audio_continuity_single")

func _ready():
	if(!audio_cont.ready):
		await audio_cont.ready
	var resume_time = audio_cont.get_resume()
	if(resume_time > 0):
		play(resume_time)
	
func record_exit_time():
	audio_cont.set_resume(get_playback_position())
