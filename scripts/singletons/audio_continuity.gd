class_name audio_continuity extends Node

var resume_time: float

func set_resume(time: float):
	resume_time = time

func get_resume() -> float:
	var hold = resume_time
	resume_time = 0
	return hold
