class_name cpc_monitor extends Control

@export var concurrent_player_display: Label
@export var cpc_target: Label
@export var active_errors: Label
var rng = RandomNumberGenerator.new()

func set_count(value: int):
	var disguising_offset = rng.randfn(0, float(value)/100)
	value = value + disguising_offset
	concurrent_player_display.text = str(value)

func set_error_count(value: int):
	active_errors.text = str(value)

func set_target(value: int):
	cpc_target.text = str(value)
