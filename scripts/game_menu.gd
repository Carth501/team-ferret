class_name game_menu extends Node

@export var level_select_panel: Panel

func load_continue():
	var loader = get_node("/root/level_loader_single")
	if(loader == null):
		push_error("loader singleton not found.")
	if(!loader.ready):
		await loader.ready
	loader.load_continue()

func toggle_level_selection():
	level_select_panel.visible = !level_select_panel.visible
