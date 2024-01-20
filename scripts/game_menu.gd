class_name game_menu extends Node

@export var level_select_panel: Panel
var active_save_file: Variant

func _ready():
	request_save()

func request_save():
	var save_handler = get_node("/root/save_handler_single")
	if(save_handler == null):
		push_error("save_handler singleton not found.")
	if(!save_handler.ready):
		await save_handler.ready
	active_save_file = save_handler.active_save

func load_continue():
	var loader = get_node("/root/level_loader_single")
	if(loader == null):
		push_error("loader singleton not found.")
	if(!loader.ready):
		await loader.ready
	loader.load_continue()

func toggle_level_selection():
	level_select_panel.visible = !level_select_panel.visible

func jump_to_title():
	var save_handler = get_node("/root/save_handler_single")
	save_handler.exit_to_title()
