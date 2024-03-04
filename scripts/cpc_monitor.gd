class_name cpc_monitor extends Control

@export var concurrent_player_display: Label
@export var cpc_target: Label
@export var active_errors: Label
@export var alert : alert_popup
var rng = RandomNumberGenerator.new()

func set_count(value: int):
	var disguising_offset = rng.randfn(0, float(value)/100)
	value += roundi(disguising_offset)
	concurrent_player_display.text = str(value)

func set_error_count(value: int):
	active_errors.text = str(value)

func set_target(value: int):
	cpc_target.text = str(value)

func in_danger():
	alert.show_alert()

func close_alert():
	alert.show_alert()
