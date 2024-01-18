class_name main_menu extends Node

func load_continue():
	var loader = get_node("/root/level_loader_single")
	if(loader == null):
		push_error("loader singleton not found.")
	if(!loader.ready):
		await loader.ready
	loader.load_continue()
