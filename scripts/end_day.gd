
extends Control
@export var date_label: Label
@export var stats_label: Label
@export var pay_value: Label
@export var bonus_value: Label
@export var company_cont_ded: Label
@export var repetition_comp_line: Control
@export var repetition_comp_ded: Label
@export var net_value: Label
@export var failure_notice: TextureRect
var results: Variant = {}
var results_stats: String = ""

func _ready():
	date_label.text = Time.get_date_string_from_system()
	results = results_single.results_struct
	if(results.has("met_target") && !results.met_target):
		failure_notice.visible = true
		pay_value.text = "$0"
		bonus_value.text = "$0"
		company_cont_ded.text = "$0"
		repetition_comp_ded.text = "$0"
		net_value.text = "$0"
	else:
		failure_notice.visible = false
		pay_value.text = "$19"
		bonus_value.text = "$34"
		company_cont_ded.text = "$13"
		if(results.has("repeat_attempt") && results.repeat_attempt):
			repetition_comp_ded.visible = true
			repetition_comp_ded.text = "$37"
			net_value.text = "$0"
		else:
			repetition_comp_ded.visible = false
			net_value.text = "$40"
	if(results.has("errors_cleared")):
		results_stats = "Errors Cleared: " + str(results.errors_cleared) + "\n"
	if(results.has("module_miss_count")):
		results_stats += "Mistakes: " + str(results.module_miss_count) + "\n"
	if(results.has("modules_per_minute")):
		results_stats += "Control Activations: " + str(results.modules_per_minute) + "\n"
	stats_label.text = results_stats

func return_to_menu():
	transition_screen_single.transitioned.connect(go_to_game_menu)
	transition_screen_single.transition()

func go_to_game_menu():
	get_tree().change_scene_to_file("res://scenes/game_menu.tscn")
