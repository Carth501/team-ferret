class_name cpc_monitor extends Control

@export var concurrent_player_display: Label
@export var active_errors: Label

func set_count(value: int):
	concurrent_player_display.text = str(value)

func set_error_count(value: int):
	active_errors.text = str(value)
