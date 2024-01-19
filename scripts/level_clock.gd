class_name level_clock extends Control

@export var display: Label
@export var seconds_remaining: int

func _ready():
	update_display()

func tick():
	seconds_remaining -= 1
	update_display()

func update_display():
	var minutes = str("%02d" % (seconds_remaining/60))
	var seconds = str("%02d" % (seconds_remaining%60))
	display.text = str(minutes, ":", seconds)

func set_value(value: int):
	seconds_remaining = value
	update_display()
