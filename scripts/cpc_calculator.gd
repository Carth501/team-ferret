class_name cpc_calculator extends Node

signal update_cpc(int)
signal reached_goal

@export var display: cpc_monitor
var cpc = 1
var target = 500
var error_count = 0
var par = 5

func calculate():
	cpc = ceil(cpc as float * calc_coefficient())
	display.set_count(cpc)
	update_cpc.emit(cpc)
	if(cpc >= target):
		reached_goal.emit()

func calc_coefficient() -> float:
	var base_coef = 1.001
	var par_difference = (par - error_count) * 0.02
	var weighted_coeff = base_coef + par_difference
	return max(weighted_coeff, 1)

func set_cpc(value: int):
	cpc = value

func update_error_count(new_value: int):
	error_count = new_value
	display.set_error_count(new_value)

func set_target(value: int):
	target = value
	display.set_target(value)
