class_name level_loader extends Node

var cubicle_instance: cubicle
var next_level_id: String

func load_level(id: String):
	next_level_id = id
	transition_screen_single.transitioned.connect(go_to_cubicle)
	transition_screen_single.transition()

func load_continue():
	load_level(get_next_level_id())

func get_next_level_id() -> String:
	var current_save = save_handler_single.active_save
	var data_lib = data_libraries_single.level_data
	for level in data_lib:
		if(current_save.has("complete_levels")):
			if(!current_save.complete_levels.has(level.metadata.id)):
				return level.metadata.id
	var rng = RandomNumberGenerator.new()
	var index = rng.randi_range(0, data_lib.size() - 1)
	return data_lib[index].metadata.id

func cubicle_ready(new_cubicle: cubicle):
	cubicle_instance = new_cubicle
	if(next_level_id != null && next_level_id != ""):
		cubicle_instance.load_level(next_level_id)
	else:
		cubicle_instance.load_level()

func go_to_cubicle():
	var tree = get_tree()
	var error = tree.change_scene_to_file("res://scenes/cubicle.tscn")
	if(error != OK):
		push_error(str("level_loader ", error))
	transition_screen_single.transitioned.disconnect(go_to_cubicle)
