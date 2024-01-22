class_name level_clock extends Control

signal times_up
@export var display: Label
@export var seconds_remaining: int

func _ready():
	update_display()

func tick():
	seconds_remaining -= 1
	update_display()
	if(seconds_remaining <= 0):
		times_up.emit()

func update_display():
	var minutes = str("%02d" % floori(seconds_remaining/60.0))
	var seconds = str("%02d" % (seconds_remaining%60))
	display.text = str(minutes, ":", seconds)

func set_value(value: int):
	seconds_remaining = value
	update_display()
