class_name cpc_calculator extends Node

signal update_cpc(int)
signal reached_goal
signal below_threshold

@export var display: cpc_monitor
var cpc = 1
var target = 500
var high_score = 0
var threshold: float
var error_count = 0
var par = 5
var cpc_cont_const := 0
var danger := false

func calculate():
	cpc = floori((cpc + 1) * calc_coefficient()) + cpc_cont_const
	cpc = maxi(cpc, 0)
	if(cpc > high_score):
		high_score = cpc
	if(threshold && cpc < high_score * threshold):
		below_threshold.emit()
	if(cpc >= target):
		reached_goal.emit()

func send_updates():
	display.set_count(cpc)
	update_cpc.emit(cpc)

func calc_coefficient() -> float:
	var base_coef = 1
	var par_difference = (par - error_count) * 0.02
	var weighted_coeff = base_coef + par_difference
	return max(weighted_coeff, 0)

func set_cpc(value: int):
	cpc = value

func update_error_count(new_value: int):
	error_count = new_value
	display.set_error_count(new_value)
	if(threshold && !danger && cpc < high_score * threshold * 1.3):
		danger = true
		display.in_danger()
	elif(threshold && danger && cpc > high_score * threshold * 1.3):
		danger = false
		display.out_of_danger()

func set_target(value: int):
	target = value
	display.set_target(value)

func set_threshold(percent: float):
	threshold = percent
